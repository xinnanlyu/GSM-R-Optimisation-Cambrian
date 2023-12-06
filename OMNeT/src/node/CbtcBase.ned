//		General Network with ZC, Train, Switch and BRaVE
//		Haven't defined antenna (or AP) and connections
//      See SO2BNS.NED and CBTCHefei.NED for details

package org.uob.cbtc.node;

import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import org.uob.cbtc.node.ZC;
import org.uob.cbtc.node.Train;
import org.uob.cbtc.node.Switch;
import org.uob.cbtc.brave.ExtSim;
import inet.node.ethernet.Eth100M;

network CbtcBase
{
    parameters:
        int numZC;
        int numAP;
        int numTrains;
    submodules:
        ZC[numZC]: ZC {
            @display("p=400,100");
        }
        node[numTrains]: Train {
            @display("p=200,100");
        }
        switch[numZC]: Switch {
            @display("p=300,100");
        }
        radioMedium: Ieee80211ScalarRadioMedium {
            @display("p=200,30");
        }
        configurator: IPv4NetworkConfigurator {
            @display("p=300,30");
        }
        extSim: ExtSim {
            @display("p=400,30");
        }
    connections:
        for i=0..numZC-1 {
            switch[i].ethg++ <--> Eth100M <--> ZC[i].ethg++;
        }
}
