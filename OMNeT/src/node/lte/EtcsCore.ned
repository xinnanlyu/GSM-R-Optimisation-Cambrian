package org.uob.cbtc.node.lte;

import org.uob.cbtc.node.CbtcBase;

network EtcsCore extends CbtcBase
{
}


//
//
//import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
//import inet.networklayer.ipv4.RoutingTableRecorder;
//import inet.node.ethernet.Eth100M;
//import org.uob.cbtc.node.lte.Router;
//import org.uob.cbtc.node.lte.BS;
//import org.uob.cbtc.node.lte.EVC;
//import org.uob.cbtc.node.lte.RBC;
////import lte.corenetwork.binder.LteBinder;
////import lte.world.radio.ChannelControl;
//
//
//network EtcsCore
//{
//    parameters:
//        int numRBC = default(1);
//        int numTrains = default(1);
//        int numBS = default(1);
//
//    submodules:
//        channelControl: ChannelControl {
//            @display("p=50,25");
//        }
//        routingRecorder: RoutingTableRecorder {
//            @display("p=50,75");
//        }
//        configurator: IPv4NetworkConfigurator {
//            @display("p=50,125");
//            config = xml("<config><interface hosts='*' address='10.x.x.x' netmask='255.x.x.x'/></config>");
//            //config = xmldoc("multi.xml");
//            dumpTopology = true;
//        }
//        binder: LteBinder {
//            @display("p=50,175");
//        }
//        RBC[numRBC]: RBC {
//            @display("p=150,50");
//        }
//        router[numRBC]: Router {
//            @display("p=300,50");
//        }
//        Train[numTrains]: EVC {
//            @display("p=150,150");
//        }
//    connections:
//        for i=0..numRBC-1 {
//            RBC[i].pppg++ <--> Eth100M <--> router[i].pppg++;
//        }
//
//}
