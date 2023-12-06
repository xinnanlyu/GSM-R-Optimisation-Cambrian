package org.uob.simulations.networks.cbtc;

import org.uob.cbtc.node.CbtcBase;
import org.uob.cbtc.node.AP;
import inet.node.ethernet.Eth100M;

network TaoGSM extends CbtcBase
{
    
    parameters:
        @display("bgb=10000,4000;bgi=background/TaoV2.jpg");

    submodules:       
        ap[numAP]: AP;

    connections:
        for i=0..numAP-1 {
            switch[0].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }    
    
}
