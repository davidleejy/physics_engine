//
//  PhysicsLogic.m
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//


/*************************************************************************************
 *              SUPER IMPORTANT NOTE !!!!
 *
 *   MODIFIES, EFFECTS, and REQUIRES are written together with method prototypes.
 *   Method prototypes are in @interface portions.
 *
 *
 *************************************************************************************
 */


#import "PhysicsLogic.h"
#import "WorldyObject.h"
#import "World.h"
#import "Matrix2D.h"
#import "Vector2D.h"
#import "EnvironmentSettings.h"



@implementation PhysicsLogic


// *** SYNTHESIS ***
@synthesize world = _world;
@synthesize gravity = _gravity;



- (void) updateVelocity:(WorldyObject*)worldyObject {
    
    // vel' = vel + dt*(grav + (netForce / mass))
    
    [worldyObject setVelocity:
    
    [
    [worldyObject velocity]
    add:
        [
        (
            [_gravity
             add:
            [[worldyObject netForce]multiply: (1.0/[worldyObject mass])]
            ]
        )
        multiply:
        DELTA_TIME
        ]
    ]
     
    ];
}


- (void) updateAngularVelocity:(WorldyObject*)worldyObject {
    
    // w' = w + dt*(torque / momentOfInertia)
    
    [worldyObject setAngularVelocity:
    
        [worldyObject angularVelocity]
        +
        DELTA_TIME*([worldyObject netTorque] / [worldyObject momentOfInertia])
     
    ];
}


- (Matrix2D*) rotationMatrixOf:(WorldyObject*)worldyObject {
    return [Matrix2D matrixWithValues:cos([worldyObject rotationAngle])
                                  and:sin([worldyObject rotationAngle])
                                  and:-sin([worldyObject rotationAngle])
                                  and:cos([worldyObject rotationAngle])];
}


- (Matrix2D*) transposedRotationMatrixOf:(WorldyObject*)worldyObject {
    return [Matrix2D matrixWithValues:cos(-[worldyObject rotationAngle])
                                  and:sin(-[worldyObject rotationAngle])
                                  and:-sin(-[worldyObject rotationAngle])
                                  and:cos(-[worldyObject rotationAngle])];
}





@end
