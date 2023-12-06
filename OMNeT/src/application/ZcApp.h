/*
 * TrainApp.h
 *
 *  Created on: 19 May 2015
 *      Author: dave
 */
#ifndef ZCAPP_H
#define ZCAPP_H

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
class INET_API ZcApp : public inet::ApplicationBase
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
//      virtual int numInitStages() const override { return inet::NUM_INIT_STAGES; }
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

      bool handleNodeStart(inet::IDoneCallback *doneCallback) override;
      bool handleNodeShutdown(inet::IDoneCallback *doneCallback) override;
      void handleNodeCrash() override;

    public:
      ZcApp() {}
      ~ZcApp();
      void notifyZc(cMessage *msg);
      void handleIncomingMessage(cMessage *msg);
};

#endif
