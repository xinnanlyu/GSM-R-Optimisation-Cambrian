package org.uob.simulations.networks.cbtc;

import org.uob.cbtc.node.CbtcBase;
import org.uob.cbtc.node.AP;
import inet.node.ethernet.Eth100M;

network CBTCHefeiMain extends CbtcBase
{
    parameters:
        @display("bgb=9776,24537;bgi=background/Hefei_Omnet,s;bgs=1,m");
    submodules:       
        ap[numAP]: AP;
    connections:
        for i=0..14 {
            switch[0].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
        for i=15..32 {
            switch[1].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
        for i=33..52 {
            switch[2].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
        for i=53..75 {
            switch[3].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
        for i=76..98 {
            switch[4].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
        for i=99..115 {
            switch[5].ethg++ <--> Eth100M <--> ap[i].ethg++;
        }
}
