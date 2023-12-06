package org.uob.cbtc.mobility;

import inet.mobility.base.MovingMobilityBase;

//
// This is a linear mobility model with speed, angle and acceleration parameters.
// Angle only changes when the mobile node hits a wall: then it reflects
// off the wall at the same angle.
//
// TODO - Modify this to react to train position from BRAVE simulator.
//
// @author Dave Kirkwood
//
simple TrainMobility extends MovingMobilityBase
{
    parameters:
        double initialX @unit(m) = default(uniform(this.constraintAreaMinX, this.constraintAreaMaxX));
        double initialY @unit(m) = default(uniform(this.constraintAreaMinY, this.constraintAreaMaxY));
        double initialZ @unit(m) = default(uniform(this.constraintAreaMinZ, this.constraintAreaMaxZ));
        bool initFromDisplayString = default(true);
        double speed @unit(mps) = default(0mps); // speed of the host
        double angle @unit(deg) = default(uniform(0deg, 360deg)); // angle of linear motion
        double acceleration = default(0); // acceleration of linear motion (m/s2)
        @signal[mobilityStateChanged](type=TrainMobility);
        @class(TrainMobility);
}

