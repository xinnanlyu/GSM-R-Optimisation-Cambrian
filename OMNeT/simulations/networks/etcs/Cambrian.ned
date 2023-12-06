package org.uob.simulations.networks.etcs;

import org.uob.cbtc.node.CbtcBase;
import org.uob.cbtc.node.AP;
import inet.node.ethernet.Eth100M;
import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
import inet.physicallayer.ieee80211.packetlevel.Ieee80211ScalarRadioMedium;
import org.uob.cbtc.node.ZC;
import org.uob.cbtc.node.Train;
import org.uob.cbtc.node.Switch;
import org.uob.cbtc.brave.ExtSim;

network Cambrian 
{
    parameters:
        @display("bgb=113000,59000;bgi=background/Cambrian,s;bgs=1,m");       
        int numAntennas;
        int numTrains;        
        
    submodules:
        antenna[numAntennas]:AP{
            @display("i=antenna");
        }
        ETCS: ZC {
            @display("p=400,100");
        }
        node[numTrains]: Train {
            @display("p=200,100");
        }
        router: Switch {
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
        for i=0..numAntennas-1 {
            router.ethg++ <--> Eth100M <--> antenna[i].ethg++;
        } 
        router.ethg++ <--> Eth100M <--> ETCS.ethg++;
        
}
