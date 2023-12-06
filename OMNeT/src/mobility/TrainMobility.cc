

#include <TrainMobility.h>

Define_Module(TrainMobility);

TrainMobility::TrainMobility()
{
    speed = 0;
    angle = 0;
    acceleration = 0;
}

void TrainMobility::initialize(int stage)
{
    MovingMobilityBase::initialize(stage);

    EV_TRACE << "initializing TrainMobility stage " << stage << endl;
    if (stage == inet::INITSTAGE_LOCAL) {
        speed = par("speed");
        angle = fmod((double)par("angle"), 360);
        acceleration = par("acceleration");
        stationary = (speed == 0) && (acceleration == 0.0);
    }
}

void TrainMobility::move()
{
    double rad = 3.14159265359 * angle / 180;
    inet::Coord direction(cos(rad), sin(rad));
    lastSpeed = direction * speed;
    double elapsedTime = (simTime() - lastUpdate).dbl();
    lastPosition += lastSpeed * elapsedTime;

    // do something if we reach the wall
    inet::Coord dummy;
    handleIfOutside(REFLECT, dummy, dummy, angle);

    // accelerate
    speed += acceleration * elapsedTime;
    if (speed <= 0) {
        speed = 0;
        stationary = true;
    }
}



void TrainMobility::setPosition(double x, double y)
{
    lastPosition.x = x;
    lastPosition.y = y;
    updateVisualRepresentation();
}

