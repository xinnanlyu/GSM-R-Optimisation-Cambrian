//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU Lesser General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU Lesser General Public License for more details.
// 
// You should have received a copy of the GNU Lesser General Public License
// along with this program.  If not, see http://www.gnu.org/licenses/.
// 

#ifndef EXTSIM_H_
#define EXTSIM_H_

#include <omnetpp/cmessage.h>
#include <omnetpp/csimplemodule.h>
#include <string>
//#include <netinet/in.h>
//winsock2.h
#include<stdio.h>
#include<winsock2.h>
#include<mswsock.h>
#include<ws2tcpip.h>

struct ip_mreq;
//struct sockaddr_in;

class ExtSim : public omnetpp::cSimpleModule {

private:
    omnetpp::cMessage *tickMsg;
    struct sockaddr_in addr_in;
    struct sockaddr_in addr_out;
    SOCKET fd_in, fd_out;
    struct ip_mreq mreq;
    int portin;
    int portout;
    double scheduleTime;
    std::string outputBuffer;
public:
    ExtSim();
    virtual ~ExtSim();
    virtual void initialize();
    virtual void handleMessage(omnetpp::cMessage *msg);
    virtual void finish();
    void processMessage(std::string message);
    void notifyBrave(std::string message);
};
Define_Module(ExtSim);
#endif /* EXTSIM_H_ */
