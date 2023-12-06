/*
 * TrainApp.cc
 *
 *  Created on: 19 May 2015
 *      Author: dave
 */

#include <ExtSim.h>
#include <IInterfaceTable.h>
#include <InterfaceEntry.h>
#include <L3AddressResolver.h>
#include <ModuleAccess.h>
#include <omnetpp/ccomponent.h>
#include <omnetpp/cdisplaystring.h>
#include <omnetpp/cexception.h>
#include <omnetpp/checkandcast.h>
#include <omnetpp/clog.h>
#include <omnetpp/cmessage.h>
#include <omnetpp/cnamedobject.h>
#include <omnetpp/cobject.h>
#include <omnetpp/cobjectfactory.h>
#include <omnetpp/cpacket.h>
#include <omnetpp/cpar.h>
#include <omnetpp/cregistrationlist.h>
#include <omnetpp/cstringtokenizer.h>
#include <omnetpp/cwatch.h>
#include <omnetpp/regmacros.h>
#include <omnetpp/simkerneldefs.h>
#include <omnetpp/simutil.h>
#include <TrainApp.h>
#include <TrainMobility.h>
#include <UDPControlInfo_m.h>
#include <cstddef>
#include <cstdio>
#include <cstring>
#include <sstream>
#include <string>


using std::endl;
using std::stringstream;
using std::istringstream;
using std::ostringstream;
using std::string;

Define_Module(TrainApp);
simsignal_t TrainApp::sentPkSignal = registerSignal("sentPk");
simsignal_t TrainApp::rcvdPkSignal = registerSignal("rcvdPk");


TrainApp::~TrainApp()
{
    cancelAndDelete(selfMsg);
}

void TrainApp::initialize(int stage)
{
    ApplicationBase::initialize(stage);

    if (stage == inet::INITSTAGE_LOCAL) {
        numSent = 0;
        numReceived = 0;
        WATCH(numSent);
        WATCH(numReceived);

        localPort = par("localPort");
        destPort = par("destPort");
        selfMsg = new cMessage("sendTimer");
    }
}

void TrainApp::finish()
{
    recordScalar("packets sent", numSent);
    recordScalar("packets received", numReceived);
    ApplicationBase::finish();
}

void TrainApp::setSocketOptions()
{
    int timeToLive = par("timeToLive");
    if (timeToLive != -1)
        socket.setTimeToLive(timeToLive);

    int typeOfService = par("typeOfService");
    if (typeOfService != -1)
        socket.setTypeOfService(typeOfService);

    const char *multicastInterface = par("multicastInterface");
    if (multicastInterface[0]) {
        inet::IInterfaceTable *ift = inet::getModuleFromPar<inet::IInterfaceTable>(par("interfaceTableModule"), this);
        inet::InterfaceEntry *ie = ift->getInterfaceByName(multicastInterface);
        if (!ie)
            throw cRuntimeError("Wrong multicastInterface setting: no interface named \"%s\"", multicastInterface);
        socket.setMulticastOutputInterface(ie->getInterfaceId());
    }

    bool receiveBroadcast = par("receiveBroadcast");
    if (receiveBroadcast)
        socket.setBroadcast(true);

    bool joinLocalMulticastGroups = par("joinLocalMulticastGroups");
    if (joinLocalMulticastGroups) {
        inet::MulticastGroupList mgl = inet::getModuleFromPar<inet::IInterfaceTable>(par("interfaceTableModule"), this)->collectMulticastGroups();
        socket.joinLocalMulticastGroups(mgl);
    }
}

inet::L3Address TrainApp::chooseDestAddr()
{
    int k = intrand(destAddresses.size());
    if (destAddresses[k].isLinkLocal()) {    // KLUDGE for IPv6
        const char *destAddrs = par("destAddresses");
        cStringTokenizer tokenizer(destAddrs);
        const char *token = nullptr;

        for (int i = 0; i <= k; ++i)
            token = tokenizer.nextToken();
        destAddresses[k] = inet::L3AddressResolver().resolve(token);
    }
    return destAddresses[k];
}

void TrainApp::sendPacket()
{
    char msgName[32];
    sprintf(msgName, "UDPBasicAppData-%d", numSent);
    cPacket *payload = new cPacket(msgName);
    payload->setByteLength(32);

    inet::L3Address destAddr = chooseDestAddr();

    emit(sentPkSignal, payload);
    socket.sendTo(payload, destAddr, destPort);
    numSent++;
}

void TrainApp::processStart()
{
    socket.setOutputGate(gate("udpOut"));
    const char *localAddress = par("localAddress");
    socket.bind(*localAddress ? inet::L3AddressResolver().resolve(localAddress) : inet::L3Address(), localPort);
    setSocketOptions();

    const char *destAddrs = par("destAddresses");
    cStringTokenizer tokenizer(destAddrs);
    const char *token;

    while ((token = tokenizer.nextToken()) != nullptr) {
        inet::L3Address result;
        inet::L3AddressResolver().tryResolve(token, result);
        if (result.isUnspecified())
            EV_ERROR << "cannot resolve destination address: " << token << endl;
        else
            destAddresses.push_back(result);
    }
}

void TrainApp::processSend()
{

}

void TrainApp::processStop()
{
    socket.close();
}

void TrainApp::handleMessageWhenUp(cMessage *msg)
{
    if (msg->isSelfMessage()) {
        ASSERT(msg == selfMsg);
        switch (selfMsg->getKind()) {
            case START:
                processStart();
                break;

            case SEND:
                processSend();
                break;

            case STOP:
                processStop();
                break;

            default:
                throw cRuntimeError("Invalid kind %d in self message", (int)selfMsg->getKind());
        }
    } else if (msg->getKind() == inet::UDP_I_DATA) {
        /**
         * Might need to check here that this message is for this train (ie not receiving from another train).
         */
        notifyTrain(msg);
    }
//    else if (msg->getKind() == inet::UDP_I_DATA) {
//        // process incoming packet
//        processPacket(PK(msg));
//    }
//    else if (msg->getKind() == inet::UDP_I_ERROR) {
//        EV_WARN << "Ignoring UDP error report\n";
//        delete msg;
//    }
//    else {
//        throw cRuntimeError("Unrecognized message (%s)%s", msg->getClassName(), msg->getName());
//    }

//    if (hasGUI()) {
        char buf[40];
        sprintf(buf, "rcvd: %d pks\nsent: %d pks", numReceived, numSent);
        getDisplayString().setTagArg("t", 0, buf);
//    }
}

void TrainApp::processPacket(cPacket *pk)
{
    emit(rcvdPkSignal, pk);
    EV_INFO << "Received packet: " << inet::UDPSocket::getReceivedPacketInfo(pk) << endl;
    delete pk;
    numReceived++;
}

bool TrainApp::handleNodeStart(inet::IDoneCallback *doneCallback)
{
    selfMsg->setKind(START);
    scheduleAt(0, selfMsg);
    return true;
}

bool TrainApp::handleNodeShutdown(inet::IDoneCallback *doneCallback)
{
    if (selfMsg)
        cancelEvent(selfMsg);
    //TODO if(socket.isOpened()) socket.close();
    return true;
}

void TrainApp::handleNodeCrash()
{
    if (selfMsg)
        cancelEvent(selfMsg);
}

/**
 * Handle message from BRaVE.
 */
void TrainApp::handleIncomingMessage(cMessage *msg)
{
    Enter_Method("Train sending");
    positionTrain(msg);

    char msgName[32];
    sprintf(msgName, "UDPBasicAppData-%d", numSent);
    cPacket *payload = new cPacket(msg->getFullName());
    payload->setByteLength(strlen(msg->getFullName()));

    inet::L3Address destAddr = chooseDestAddr();

    emit(sentPkSignal, payload);
    socket.sendTo(payload, destAddr, destPort);
    numSent++;

}

/**
 * Position train according to coordinates in message from BRaVE.
 */
void TrainApp::positionTrain(cMessage *msg) {
//    ApplPkt *packet = check_and_cast<ApplPkt *>(msg);
    const char* msgStr = msg->getName();
    std::string s = msgStr;

    std::size_t xPos = s.find("x=\"") + 3;
    std::string xsStr = s.substr(xPos);
    std::size_t endxPos = xsStr.find("\"");
    std::string xStr = xsStr.substr(0,endxPos);

    std::size_t yPos = s.find("y=\"") + 3;
    std::string ysStr = s.substr(yPos);
    std::size_t endyPos = ysStr.find("\"");
    std::string yStr = ysStr.substr(0,endyPos);

    std::size_t tidPos = s.find("trainId=\"") + 10;      // Miss out "S" Prefix
    std::string trainIdSStr = s.substr(tidPos);
    std::size_t endtidPos = trainIdSStr.find("\"");
    std::string trainIdStr = trainIdSStr.substr(0,endtidPos);
    int gateNum;
    std::istringstream(trainIdStr) >> gateNum;
    gateNum--;
    std::ostringstream converter;
    converter << gateNum;
    std::string trainNumber = converter.str();

    double xd = 0;
    stringstream convert(xStr);
    if(!(convert >> xd)) {
        xd = 0;
    }

    double yd = 0;
    stringstream convert2(yStr);
    if(!(convert2 >> yd)) {
        yd = 0;
    }

    cModule *train = getParentModule();
    std::string mobilityStr = ".mobility";
    cModule *mobilityApp = train->getModuleByPath(mobilityStr.c_str());
    TrainMobility *trainMob = check_and_cast<TrainMobility *>(mobilityApp);
    trainMob->setPosition(xd, yd);

}

/**
 * Notify BRaVE Train that the message has made it through Omnet to the Train node.
 */
void TrainApp::notifyTrain(cMessage *msg) {
    msg->setKind(5);
    cModule *parent = getParentModule();        // This is the Train
    cModule *grandParent = parent->getParentModule();   // The network

    std::string extSimStr = "extSim";
    cModule *extSimModule = grandParent->getModuleByPath(extSimStr.c_str());
    ExtSim *extSim = check_and_cast<ExtSim *>(extSimModule);

    /*
     * Notify back to brave.
     */
    extSim->notifyBrave(msg->getFullName());
    delete msg;
}
