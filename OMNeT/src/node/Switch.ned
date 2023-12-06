package org.uob.cbtc.node;

import inet.node.ethernet.EtherSwitch;
import inet.mobility.contract.IMobility;

module Switch extends EtherSwitch
{
    parameters:
        string mobilityType = default(numRadios > 0 ? "StationaryMobility" : "");
        *.mobilityModule = default(mobilityType != "" ? absPath(".mobility") : "");
        @display("i=device/switch");

    submodules:
        mobility: <mobilityType> like IMobility if mobilityType != "" {
            parameters:
                @display("p=73,158");
        }
}
