//
//  PhysicsLogic.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@class World;
@class Matrix2D;
@class Vector2D;
@class EnvironmentSettings;
@class WorldyObject;


@interface PhysicsLogic : NSObject

@property (readwrite) World *world;

@property (readwrite) Vector2D *gravity;


- (void) updateVelocity:(WorldyObject*)worldyObject;
// MODIFIES: velocity property of a worldly object.
// EFFECTS: updates the velocity property of a worldly object in accordance to formula provided in appendix.

- (void) updateAngularVelocity:(WorldyObject*)worldyObject;
// MODIFIES: angular velocity property of a worldly object.
// EFFECTS: updates the angular velocity property of a worldly object in accordance to formula provided in appendix.

- (Matrix2D*) rotationMatrixOf:(WorldyObject*)worldyObject;
// EFFECTS: computes the rotation matrix of worldyObject.

- (Matrix2D*) transposedRotationMatrixOf:(WorldyObject*)worldyObject;
// EFFECTS: computes the transpose of the rotation matrix of worldyObject.

- (Vector2D*) hVectorOf:(WorldyObject*)worldyObject;
// EFFECTS: computes the h vector of worldyObject.

- (Vector2D*) unitDirectionalVectorNormalToE1Of:(WorldyObject*)worldyObject;
// EFFECTS: computes unit directional vector normal to E1 side of worldyObject.

- (Vector2D*) unitDirectionalVectorNormalToE2Of:(WorldyObject*)worldyObject;
// EFFECTS: computes unit directional vector normal to E2 side of worldyObject.

- (Vector2D*) unitDirectionalVectorNormalToE3Of:(WorldyObject*)worldyObject;
// EFFECTS: computes unit directional vector normal to E3 side of worldyObject.

- (Vector2D*) unitDirectionalVectorNormalToE4Of:(WorldyObject*)worldyObject;
// EFFECTS: computes unit directional vector normal to E4 side of worldyObject.

- (Vector2D*) directionalVectorFrom:(WorldyObject*)worldyObjectA To:(WorldyObject*)worldyObjectB;
// EFFECTS: computes direction vector pointing from the origin of worldyObjectA to the origin of worldyObjectB.

- (Matrix2D*) transformationMatrixToMapACoordinateInSystem:(WorldyObject*)worldyObjectB ToACoordinateInSystem:(WorldyObject*)worldyObjectA;
// EFFECTS: computes a transformation matrix that transforms a coordinate in system B to a coordinate in system A.

- (Vector2D*) fVectorOf:(WorldyObject*)worldyObjectA WithRespectTo:(WorldyObject*)worldyObjectB;
// EFFECTS: computes f vector of worldyObjectA with respect to worldyObjectB;

- (BOOL) collided:(WorldyObject*)worldyObjectA :(WorldyObject*)worldyObjectB;
// EFFECTS: returns YES if worldyObjectA has collided with worldyObjectB. Returns NO otherwise.

// PAGE 7 of appendix

@end
