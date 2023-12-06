package org.uob.cbtc.application;


import inet.applications.contract.IUDPApp;


simple TrainApp like IUDPApp
{
    parameters:
        string interfaceTableModule;   // The path to the InterfaceTable module
        int localPort = default(1001);
        int destPort = default(1000);
		string localAddress = default("");
		int timeToLive = default(-1); // if not -1, set the TTL (IPv4) or Hop Limit (IPv6) field of sent packets to this value
		int typeOfService = default(-1); // if not -1, set the ToS (IPv4) or Traffic Class (IPv6) field of sent packets to this value
        string multicastInterface = default("");  // if not empty, set the multicast output interface option on the socket (interface name expected)
        bool receiveBroadcast = default(false); // if true, makes the socket receive broadcast packets
        bool joinLocalMulticastGroups = default(false); // if true, makes the socket receive packets from all multicast groups set on local interfaces
        string destAddresses = default(""); // list of IP addresses, separated by spaces ("": don't send)
        @display("i=block/app");
        @signal[sentPk](type=cPacket);
        @statistic[echoedPk](title="packets echoed"; source=pk; record=count,"sum(packetBytes)","vector(packetBytes)"; interpolationmode=none);
    gates:
        input udpIn @labels(UDPControlInfo/up);
        output udpOut @labels(UDPControlInfo/down);
}