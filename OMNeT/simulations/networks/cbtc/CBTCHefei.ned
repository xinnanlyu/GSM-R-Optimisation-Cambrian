package org.uob.simulations.networks.cbtc;

import org.uob.cbtc.node.CbtcBase;
import org.uob.cbtc.node.AP;
import inet.node.ethernet.Eth100M;

network CBTCHefei extends CbtcBase
{
    parameters:
        @display("bgb=9776,24537;bgi=background/Hefei_Omnet,s;bgs=1,m");

    submodules:       
        ap[numAP]: AP;

    connections:
        for i=0..numAP-1 {
            switch[0].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
}
