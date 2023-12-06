package org.uob.cbtc.node.lte;
//
//import inet.networklayer.configurator.ipv4.IPv4NetworkConfigurator;
//import inet.networklayer.ipv4.RoutingTableRecorder;
//import inet.node.ethernet.Eth10G;
//import inet.node.inet.Router;
//import inet.node.inet.StandardHost;
//import lte.corenetwork.binder.LteBinder;
//import lte.corenetwork.nodes.Ue;
//import lte.corenetwork.nodes.eNodeB;
////import lte.corenetwork.nodes.ExtCell;
//import lte.world.radio.ChannelControl;
//import org.uob.cbtc.node.lte.BS;
//import org.uob.cbtc.node.lte.EVC;
//import org.uob.cbtc.node.lte.RBC;
//
//network EtcsCoreTest1
//{
//    parameters:
//        int numRBC = default(1);
//        int numBS;
//        int numTrains = default(1);
//    //        @display("i=block/network2;bgb=991,558;bgi=background/budapest");
//    submodules:
//        channelControl: ChannelControl {
//            @display("p=50,25;is=s");
//        }
//        routingRecorder: RoutingTableRecorder {
//            @display("p=50,75;is=s");
//        }
//        configurator: IPv4NetworkConfigurator {
//            @display("p=50,125");
//            config = xml("<config><interface hosts='*' address='10.x.x.x' netmask='255.x.x.x'/></config>");
//            //config = xmldoc("multi.xml");
//            dumpTopology = true;
//        }
//        binder: LteBinder {
//            @display("p=50,175;is=s");
//        }
//        RBC: RBC {
//            @display("p=200,100;is=n;i=device/server");
//        }
//        router: Router {
//            @display("p=400,100;i=device/smallrouter");
//        }
//        eNodeB[numBS]: BS {
//            @display("p=400,400;is=vl");
//        }
//        train[numTrains]: EVC {
//            @display("p=200,300");
//        }
//
//    connections:
//        RBC.pppg++ <--> Eth10G <--> router.pppg++;
//
//        for i=0..numBS-1 {
//            router.pppg++ <--> Eth10G <--> eNodeB[i].ppp;
//        }
//}
