/*
 * TrainApp.h
 *
 *  Created on: 19 May 2015
 *      Author: dave
 */

#ifndef TRAINAPP_H_
#define TRAINAPP_H_

#include <ApplicationBase.h>
#include <InitStages.h>
#include <INETDefs.h>
#include <L3Address.h>
#include <omnetpp/clistener.h>
#include <omnetpp/platdep/platdefs.h>
#include <UDPSocket.h>
#include <vector>




/**
 * Consumes and prints packets received from the UDP module. See NED for more info.
 */
class INET_API TrainApp : public inet::ApplicationBase
{

    protected:
      enum SelfMsgKinds { START = 1, SEND, STOP };

      // parameters
      std::vector<inet::L3Address> destAddresses;
      int localPort = -1, destPort = -1;

      // state
      inet::UDPSocket socket;
      cMessage *selfMsg = nullptr;

      // statistics
      int numSent = 0;
      int numReceived = 0;

      static simsignal_t sentPkSignal;
      static simsignal_t rcvdPkSignal;

    protected:
      virtual int numInitStages() const override { return inet::NUM_INIT_STAGES; }
      virtual void initialize(int stage) override;
      virtual void handleMessageWhenUp(cMessage *msg) override;
      virtual void finish() override;

      // chooses random destination address
      virtual inet::L3Address chooseDestAddr();
      virtual void sendPacket();
      virtual void processPacket(cPacket *msg);
      virtual void setSocketOptions();

      virtual void processStart();
      virtual void processSend();
      virtual void processStop();

      virtual bool handleNodeStart(inet::IDoneCallback *doneCallback) override;
      virtual bool handleNodeShutdown(inet::IDoneCallback *doneCallback) override;
      virtual void handleNodeCrash() override;

    public:
      TrainApp() {}
      ~TrainApp();
      void handleIncomingMessage(cMessage *msg);
      void positionTrain(cMessage *msg);
      void notifyTrain(cMessage *msg);
};


#endif
//
//
///*
// * TrainApp.h
// *
// *  Created on: 19 May 2015
// *      Author: dave
// */
//
//#ifndef TRAINAPP_H_
//#define TRAINAPP_H_
//
//#include <ApplicationBase.h>
//#include <clistener.h>
//#include <InitStages.h>
//#include <L3Address.h>
//#include <simtime_t.h>
//#include <UDPSocket.h>
//
//#include "inet/common/INETDefs.h"
//
//#include "inet/applications/base/ApplicationBase.h"
//#include "inet/transportlayer/contract/udp/UDPSocket.h"
//#include "inet/networklayer/common/L3Address.h"
//
//
///**
// * Consumes and prints packets received from the UDP module. See NED for more info.
// */
//class TrainApp : public inet::ApplicationBase
//{
//
//  protected:
//    enum SelfMsgKinds { START = 1, STOP };
//
//    inet::UDPSocket socket;
//    int localPort = -1;
//    int destPort = -1;
//    inet::L3Address multicastGroup;
//    simtime_t startTime;
//    simtime_t stopTime;
//    cMessage *selfMsg = nullptr;
//
//    int numReceived = 0;
//
//    static simsignal_t sentPkSignal;
//    static simsignal_t rcvdPkSignal;
//
//  public:
//    TrainApp() {}
//    virtual ~TrainApp();
//
//  protected:
//    virtual void processPacket(cPacket *msg);
//    virtual void setSocketOptions();
//
//  protected:
//    virtual int numInitStages() const override { return inet::NUM_INIT_STAGES; }
//    virtual void initialize(int stage) override;
//    virtual void handleMessageWhenUp(cMessage *msg) override;
//    virtual void finish() override;
//
//    virtual void processStart();
//    virtual void processStop();
//
//    virtual bool handleNodeStart(inet::IDoneCallback *doneCallback) override;
//    virtual bool handleNodeShutdown(inet::IDoneCallback *doneCallback) override;
//    virtual void handleNodeCrash() override;
//
////    virtual inet::L3Address chooseDestAddr();
//    /**
//     * Incoming message
//     */
//  public:
//    void handleMessage(cMessage *msg);
//    void positionTrain(cMessage *msg);
//};
//
//
//#endif
