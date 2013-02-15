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

@property (readwrite) Vector2D *position;
@property (readwrite) Vector2D *velocity;
@property (readwrite) double angularVelocity;
@property (readwrite) Vector2D *netForce;
@property (readwrite) double netTorque;
@property (readwrite) double rotationAngle;


- (WorldyObject*) initWithMass:(double)m AndWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos AndVelocity:(Vector2D*)vel AndAngularVelocity:(double)angvel AndRotationAngle:(double)rot;
    // EFFECTS: Ctor. Initializes a worldy object

+ (WorldyObject*) worldyObjectWithMass:(double)m AndWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos;
   // EFFECTS: Lazy Ctor. Initializes a worldy object with 0 velocity, 0 angular velocity, 0 rotation angle.



@end
