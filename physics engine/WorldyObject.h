//
//  BlockModel.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class Matrix2D;
@class Vector2D;


@interface WorldyObject : NSObject

@property (readonly) double mass;
@property (readonly) double momentOfInertia;
@property (readonly) double width;
@property (readonly) double height;
@property (readonly) double restitutionCoeff;
@property (readonly) double frictionCoeff;


@property (readwrite) Vector2D *position;
@property (readwrite) Vector2D *velocity;
@property (readwrite) double angularVelocity;
@property (readwrite) Vector2D *netForce;
@property (readwrite) double netTorque;
@property (readwrite) double rotationAngle;
@property (readwrite) BOOL isUnmoveable;

/******* CONSTANTS **********/
extern double const DEFAULT_RESTITUTION_COEFFICIENT;
extern double const DEFAULT_FRICTION_COEFFICIENT;
/****************************/


- (WorldyObject*) initWithMass:(double)m Width:(double)w Height:(double)h Position:(Vector2D*)pos Velocity:(Vector2D*)vel AngularVelocity:(double)angvel RotationAngle:(double)rot RestitutionCoeff:(double)e FrictionCoeff:(double)frictionCoeff IsUnmoveable:(BOOL) isUnmoveable;
    // EFFECTS: Ctor. Initializes a worldy object

+ (WorldyObject*) worldyObjectWithMass:(double)m Width:(double)w Height:(double)h Position:(Vector2D*)pos;
   // EFFECTS: Lazy Ctor. Initializes a worldy object with 0 velocity, 0 angular velocity,
    //          0 rotation angle, default restitution coefficient, default friction coefficient,
    //          isUnmoveable == NO

+ (WorldyObject*) worldyObjectUnmoveableWithWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos;
// EFFECTS: Lazy Ctor. Initializes an unmoveable worldyObject. Mass is INFINITY.

+ (double) DEFAULT_RESTITUTION_COEFFICIENT;
// EFFECTS: returns DEFAULT_RESTITUTION_COEFFICIENT

+ (double) DEFAULT_FRICTION_COEFFICIENT;
// EFFECTS: returns DEFAULT_FRICTION_COEFFICIENT

@end
