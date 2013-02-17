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
@property (readwrite) double restitutionCoeff;
@property (readwrite) double frictionCoeff;

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
@synthesize restitutionCoeff = _restitutionCoeff;
@synthesize frictionCoeff = _frictionCoeff;
@synthesize isUnmoveable = _isUnmoveable;

/******* COSNTANTS **********/
double const DEFAULT_RESTITUTION_COEFFICIENT = 0.5;
double const DEFAULT_FRICTION_COEFFICIENT = 0.5;
/****************************/

- (WorldyObject*) initWithMass:(double)m Width:(double)w Height:(double)h Position:(Vector2D*)pos Velocity:(Vector2D*)vel AngularVelocity:(double)angVel RotationAngle:(double)rot RestitutionCoeff:(double)e FrictionCoeff:(double)frictionCoeff IsUnmoveable:(BOOL) isUnmoveable {
    
    if(self = [super init]){
        _mass = m;
        _momentOfInertia = (((w*w) + (h*h)) / 12.0 ) * m;
        _width = w;
        _height = h;
        _position = [Vector2D vectorWith:[pos x] y:[pos y]];
        _velocity = [Vector2D vectorWith:[vel x] y:[vel y]];
        _angularVelocity = angVel;
        _netForce = [Vector2D vectorWith:0 y:0];
        _netTorque = 0;
        _rotationAngle = rot;
        _restitutionCoeff = e;
        _frictionCoeff = frictionCoeff;
        _isUnmoveable = isUnmoveable;
    }
    return self;
}


+ (WorldyObject*) worldyObjectWithMass:(double)m Width:(double)w Height:(double)h Position:(Vector2D*)pos {
    
    Vector2D *zeroVector = [Vector2D vectorWith:0 y:0];
    
    return [[WorldyObject alloc] initWithMass:m Width:w Height:h Position:pos Velocity:zeroVector AngularVelocity:0.0 RotationAngle:0.0 RestitutionCoeff:DEFAULT_RESTITUTION_COEFFICIENT FrictionCoeff:DEFAULT_FRICTION_COEFFICIENT IsUnmoveable:NO];
}

+ (WorldyObject*) worldyObjectUnmoveableWithWidth:(double)w AndHeight:(double)h AndPosition:(Vector2D*)pos {
    
    Vector2D *zeroVector = [Vector2D vectorWith:0 y:0];
    
    return [[WorldyObject alloc] initWithMass:INFINITY Width:w Height:h Position:pos Velocity:zeroVector AngularVelocity:0.0 RotationAngle:0.0 RestitutionCoeff:DEFAULT_RESTITUTION_COEFFICIENT FrictionCoeff:DEFAULT_FRICTION_COEFFICIENT IsUnmoveable:YES];
}


+ (double) DEFAULT_RESTITUTION_COEFFICIENT {return DEFAULT_RESTITUTION_COEFFICIENT;}

+ (double) DEFAULT_FRICTION_COEFFICIENT {return DEFAULT_FRICTION_COEFFICIENT;}

@end
