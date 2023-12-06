package org.uob.simulations.networks.cbtc;

import org.uob.cbtc.node.CbtcBase;
import org.uob.cbtc.node.AP;
import inet.node.ethernet.Eth100M;

network SO2BNS extends CbtcBase
{
    parameters:
        @display("bgb=4000,5000;bgi=background/SO2BNS,s;bgs=1,m");
            
    submodules:
        antenna[numAP]: AP{
            @display("i=antennaP");
        }

    connections:
        for i=0..numAP-1 {
            switch[0].ethg++ <--> Eth100M <--> antenna[i].ethg++;
        }
        
}
