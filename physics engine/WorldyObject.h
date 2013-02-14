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

@property (readonly) CGFloat mass;
@property (readonly) CGFloat momentOfInertia;
@property (readonly) Vector2D *position;
@property (readwrite) Vector2D *velocity;
@property (readwrite) Vector2D *angularVelocity;
@property (readonly) CGFloat width;
@property (readonly) CGFloat height;
@property (readwrite) Vector2D *netForce;
@property (readwrite) Vector2D *netTorque;
@property (readwrite) CGFloat rotationAngle;

@end
