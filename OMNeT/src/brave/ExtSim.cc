/*
 * ExtSim class is dealing with the external UDP connection to BRaVE. It contains methods to send
 * to BRaVE that are called from both the TrainApp and the ZCApp. It also receives packets from BRaVE
 * and forwards them to either the ZCApp or the TrainApp depending on whether they are a positionAdvisory
 * (send to the relevant train to send to the ZC) or a movementAuthority (to the relevant ZC to send back
 * to the Train).
 */

#include <ExtSim.h>
#include <fcntl.h>
#include <omnetpp/checkandcast.h>
#include <TrainApp.h>
#include <cstddef>
#include <cstdio>
#include <cstdlib>
#include <cstring>
#include <ZcApp.h>

#include<stdio.h>
#include<winsock2.h>
#include<mswsock.h>
#include<ws2tcpip.h>

using std::endl;
using std::istringstream;
using std::string;

ExtSim::ExtSim() {
    // TODO Auto-generated constructor stub

}

ExtSim::~ExtSim() {
    // TODO Auto-generated destructor stub
}

void ExtSim::initialize() {

    portin = par("portin");
    portout = par("portout");
    scheduleTime = par("scheduleTime");

    outputBuffer = "";

    tickMsg = new omnetpp::cMessage("tick");
    scheduleAt(omnetpp::cSimulation::getActiveSimulation()->getSimTime() + 5, tickMsg);

    WSADATA wsa;
    /*
     * Initialise winsock
     */
    printf("\nInitialising Winsock...");
    if (WSAStartup(MAKEWORD(2,2),&wsa) != 0)
    {
        printf("Failed. Error Code : %d",WSAGetLastError());
        WSACleanup();
        exit(EXIT_FAILURE);
    }
    printf("Initialised.\n");

    /**
     * Set up socket outgoing socket
     */
    if ((fd_out = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        printf("cannot create socket\n");
        WSACleanup();
        exit(1);
    }
    memset(&addr_out, 0, sizeof(addr_out));
    addr_out.sin_family = AF_INET;
    addr_out.sin_addr.s_addr = inet_addr("224.0.0.2");
    addr_out.sin_port = htons(portout);

    /**
     * Set up socket incoming socket.
     */
    if ((fd_in = socket(AF_INET, SOCK_DGRAM, 0)) < 0) {
        printf("cannot create socket\n");
        WSACleanup();
        exit(1);
    }
    memset(&addr_in, 0, sizeof(addr_in));
    addr_in.sin_family = AF_INET;
    addr_in.sin_addr.s_addr = htonl(INADDR_ANY);
    addr_in.sin_port = htons(portin);
    if(bind(fd_in, (struct sockaddr *) &addr_in, sizeof(addr_in)) < 0) {
        printf("error binding socket");
        WSACleanup();
        exit(1);
    }

    mreq.imr_multiaddr.s_addr = inet_addr("224.0.0.2");
    mreq.imr_interface.s_addr = htonl(INADDR_ANY);
    if(setsockopt(fd_in, IPPROTO_IP, IP_ADD_MEMBERSHIP, (char*)&mreq, sizeof(mreq)) < 0) {
        printf("cannot connect to multicast");
        WSACleanup();
        exit(1);
    }

    u_long iMode=0;     //0=blocking, 1=non-blocking
    ioctlsocket(fd_in,FIONBIO,&iMode);      // set blocking mode

}

void ExtSim::handleMessage(omnetpp::cMessage *msg) {
    if (msg == tickMsg) {

        char msgbuf[4096];

        int addrlen = sizeof(addr_in);
        int recvlen = recvfrom(fd_in, msgbuf, 4096, 0, (struct sockaddr *)&addr_in, &addrlen);

        std::string text = "";
//        if (recvlen > 0) {

//            std::stringstream sstm;
            text = std::string(msgbuf, recvlen);
//            text = sstm.str();

            while(text.find("/>") != std::string::npos) {
                std::size_t paEndPos = text.find("/>") + 3;
                std::string message = text.substr(0, paEndPos);
                text = text.substr(paEndPos);
                processMessage(message);
            }
//            recvlen = recvfrom(fd_in, msgbuf, 4096, 0, (struct sockaddr *)&addr_in, &addrlen);
//        }

        const char *msgChar = outputBuffer.c_str();
        if(strlen(msgChar) == 0) {
            outputBuffer = "ACK";
            msgChar = outputBuffer.c_str();
        }
        if (sendto(fd_out, msgChar, strlen(msgChar), 0, (struct sockaddr *) &addr_out, sizeof(addr_out)) < 0) {
            perror("sendto");
            exit(1);
        }
        outputBuffer.clear();

        scheduleAt(omnetpp::cSimulation::getActiveSimulation()->getSimTime() + scheduleTime,tickMsg);

    }
}

void ExtSim::processMessage(std::string message)
{

    if(message.find("<posnAdvisory ") != std::string::npos) {


        /*
         * Incoming Position Advisory from BRaVE - send to Train to forward to ZC.
         */
        int messageKind = 1001;
        omnetpp::cMessage *pkt = new omnetpp::cMessage(message.c_str(), messageKind);
        cModule *parent = getParentModule();

        /*
         * Get Node ID from trainId in XML string.
         */
        std::size_t tidPos = message.find("trainId=\"") + 10;      // Miss out "S" Prefix
        std::string trainIdSStr = message.substr(tidPos);
        std::size_t endtidPos = trainIdSStr.find("\"");
        std::string trainIdStr = trainIdSStr.substr(0,endtidPos);
        int gateNum;
        istringstream(trainIdStr) >> gateNum;
        gateNum--;
        std::stringstream sstm;
        sstm << ".node[" << gateNum << "]";
        std::string nodeId = sstm.str();

        /*
         * Send message to Node
         */
        cModule *train = parent->getModuleByPath(nodeId.c_str());
        std::string udpAppStr = ".udpApp[0]";
        cModule *udpApp = train->getModuleByPath(udpAppStr.c_str());
        TrainApp *trainApp = check_and_cast<TrainApp *>(udpApp);
        trainApp->handleIncomingMessage(pkt);
        delete pkt;

    } else if(message.find("<movementAuthority ") != std::string::npos) {

        /**
         * Incoming Movement authority from BRaVE - send to ZC to forward to train.
         */
        int messageKind = inet::UDP_I_DATA;

        omnetpp::cMessage *pkt = new omnetpp::cMessage(message.c_str(), messageKind);
        cModule *parent = getParentModule();

        /*
         * Get ZC ID from XML string.
         */
        std::size_t zcidPos = message.find("zcId=\"") + 6;
        std::string zcIdSStr = message.substr(zcidPos);
        std::size_t endzcIdPos = zcIdSStr.find("\"");
        std::string zcIdStr = zcIdSStr.substr(0,endzcIdPos);

        /*
         * Send message to Node
         */
        cModule *zc = parent->getModuleByPath(zcIdStr.c_str());
        std::string udpAppStr = ".udpApp[0]";
        cModule *udpApp = zc->getModuleByPath(udpAppStr.c_str());
        ZcApp *zcApp = check_and_cast<ZcApp *>(udpApp);
        zcApp->handleIncomingMessage(pkt);
        delete pkt;

    }

}

void ExtSim::notifyBrave(std::string message)
{
    outputBuffer = outputBuffer + message;
}

void ExtSim::finish() {
    WSACleanup();
}

