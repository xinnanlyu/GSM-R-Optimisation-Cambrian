//
// Author: Dave
//


#ifndef Train_MOBILITY_H
#define Train_MOBILITY_H


#include "inet/common/INETDefs.h"

#include "inet/mobility/base/MovingMobilityBase.h"


class INET_API TrainMobility : public inet::MovingMobilityBase
{
  protected:
    double speed;    ///< speed of the host
    double angle;    ///< angle of linear motion
    double acceleration;    ///< acceleration of linear motion

  protected:
    virtual int numInitStages() const override { return inet::NUM_INIT_STAGES; }

    /** @brief Initializes mobility model parameters.*/
    virtual void initialize(int stage) override;

    /** @brief Move the host*/
    virtual void move() override;

  public:
    virtual double getMaxSpeed() const override { return speed; }
    TrainMobility();
    void setPosition(double x, double y);
};


#endif

