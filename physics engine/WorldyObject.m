//
//  BlockModel.m
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



#import "WorldyObject.h"
#import "Matrix2D.h"
#import "Vector2D.h"

@interface WorldyObject ()

@property (readwrite) double mass;
@property (readwrite) double momentOfInertia;
@property (readwrite) double width;
@property (readwrite) double height;

@end



@implementation WorldyObject

// **** SYNTHESIS ****
@synthesize mass = _mass;
@synthesize momentOfInertia = _momentOfInertia;
@synthesize width = _width;
@synthesize height = _height;
@synthesize position = _position;
@synthesize velocity = _velocity;
@synthesize angularVelocity = _angularVelocity;
@synthesize netForce = _netForce;
@synthesize netTorque = _netTorque;
@synthesize rotationAngle = _rotationAngle;


- (WorldyObject*) initWithMass:(double)m AndWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos AndVelocity:(Vector2D*)vel AndAngularVelocity:(double)angVel AndRotationAngle:(double)rot {
    
    if(self = [super init]){
        _mass = m;
        _momentOfInertia = ((powf(w, 2.0) + powf(h, 2.0)) / 12.0 ) * m;
        _width = w;
        _height = h;
        _position = [Vector2D vectorWith:[pos x] y:[pos y]];
        _velocity = [Vector2D vectorWith:[vel x] y:[vel y]];
        _angularVelocity = angVel;
        _netForce = [Vector2D vectorWith:0 y:0];
        _netTorque = 0;
        _rotationAngle = rot;
    }
    return self;
}


+ (WorldyObject*) worldyObjectWithMass:(double)m AndWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos {
    
    Vector2D *zeroVector = [Vector2D vectorWith:0 y:0];
    
    return [[WorldyObject alloc] initWithMass:m AndWidth:w AndHeight:h AndPosition:pos AndVelocity:zeroVector AndAngularVelocity:0.0 AndRotationAngle:0.0];
}


@end
