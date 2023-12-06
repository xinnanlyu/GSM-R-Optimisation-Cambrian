/*
 * ZcApp.cc
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
#include <ZcApp.h>
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


Define_Module(ZcApp);
simsignal_t ZcApp::sentPkSignal = registerSignal("sentPk");
simsignal_t ZcApp::rcvdPkSignal = registerSignal("rcvdPk");


ZcApp::~ZcApp()
{
    cancelAndDelete(selfMsg);
}

void ZcApp::initialize(int stage)
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

void ZcApp::finish()
{
    recordScalar("packets sent", numSent);
    recordScalar("packets received", numReceived);
    ApplicationBase::finish();
}

void ZcApp::setSocketOptions()
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

inet::L3Address ZcApp::chooseDestAddr()
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

void ZcApp::sendPacket()
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

void ZcApp::processStart()
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

void ZcApp::processSend()
{

}

void ZcApp::processStop()
{
    socket.close();
}

void ZcApp::handleMessageWhenUp(cMessage *msg)
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
        notifyZc(msg);
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

void ZcApp::processPacket(cPacket *pk)
{
    emit(rcvdPkSignal, pk);
    EV_INFO << "Received packet: " << inet::UDPSocket::getReceivedPacketInfo(pk) << endl;
    delete pk;
    numReceived++;
}

bool ZcApp::handleNodeStart(inet::IDoneCallback *doneCallback)
{
    selfMsg->setKind(START);
    scheduleAt(0, selfMsg);
    return true;
}

bool ZcApp::handleNodeShutdown(inet::IDoneCallback *doneCallback)
{
    if (selfMsg)
        cancelEvent(selfMsg);
    //TODO if(socket.isOpened()) socket.close();
    return true;
}

void ZcApp::handleNodeCrash()
{
    if (selfMsg)
        cancelEvent(selfMsg);
}


/**
 * Notify BRaVE ZC component that the message has made it through Omnet to the ZC node.
 */
void ZcApp::notifyZc(cMessage *msg) {
    msg->setKind(5);
    cModule *parent = getParentModule();        // This is the ZC
    cModule *grandParent = parent->getParentModule();   // The network

    std::string extSimStr = "extSim";
    cModule *extSimModule = grandParent->getModuleByPath(extSimStr.c_str());
    ExtSim *extSim = check_and_cast<ExtSim *>(extSimModule);

    /*
     * Append ZC name field into message.
     */
    std::string message(msg->getFullName());
    std::size_t pasPos = message.find("posnAdvisory ") + 13;
    std::string prePasStr = message.substr(0,pasPos);
    std::string postPasStr = message.substr(pasPos);
    std::stringstream sstm;
    sstm << prePasStr << "zcId=\"" << parent->getFullName() << "\" " << postPasStr;

    /*
     * Notify back to brave.
     */
    extSim->notifyBrave(sstm.str());
    delete msg;
}

/**
 * Handle message from BRaVE.
 */
void ZcApp::handleIncomingMessage(cMessage *msg)
{
    Enter_Method("ZC sending");

    char msgName[32];
    sprintf(msgName, "UDPBasicAppData-%d", numSent);
    cPacket *payload = new cPacket(msg->getFullName());
    payload->setByteLength(strlen(msg->getFullName()));

    /*
     * Get Train ID from XML string.
     */
    std::string message(msg->getFullName());
    std::size_t tidPos = message.find("trainId=\"") + 10;      // Miss out "S" Prefix
    std::string trainIdSStr = message.substr(tidPos);
    std::size_t endtidPos = trainIdSStr.find("\"");
    std::string trainIdStr = trainIdSStr.substr(0,endtidPos);
    int gateNum;
    istringstream(trainIdStr) >> gateNum;
    gateNum--;
    std::stringstream sstm;
    sstm << "node[" << gateNum << "]";
    std::string nodeId = sstm.str();

    inet::L3Address destAddr = inet::L3AddressResolver().resolve(nodeId.c_str());

//    inet::L3Address destAddr = chooseDestAddr();

    /*
     * Send message to train
     */
    emit(sentPkSignal, payload);
    socket.sendTo(payload, destAddr, destPort);
    numSent++;
}
