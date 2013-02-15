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

- (Vector2D*) directionalVectorInWorldCoordSystemFrom:(WorldyObject*)worldyObjectA To:(WorldyObject*)worldyObjectB;
// EFFECTS: computes direction vector pointing from the origin of worldyObjectA to the origin of worldyObjectB.
//          This is w.r.t to the world coordinate system.
//          Symbol: d with arrow on top. No subscripts.

- (Vector2D*) directionalVectorInWorldyObjectACoordSystemFrom:(WorldyObject*)worldyObjectA To:(WorldyObject*)worldyObjectB;
// EFFECTS: computes direction vector pointing from the origin of worldyObjectA to the origin of worldyObjectB.
//          This is w.r.t to the worldyObject A's coordinate system.
//          Symbol: d with arrow on top. Subscript A.

- (Vector2D*) directionalVectorInWorldyObjectBCoordSystemFrom:(WorldyObject*)worldyObjectA To:(WorldyObject*)worldyObjectB;
// EFFECTS: computes direction vector pointing from the origin of worldyObjectA to the origin of worldyObjectB.
//          This is w.r.t to the worldyObject B's coordinate system.
//          Symbol: d with arrow on top. Subscript B.

- (Matrix2D*) transformationMatrixToMapACoordinateInSystem:(WorldyObject*)worldyObjectB ToACoordinateInSystem:(WorldyObject*)worldyObjectA;
// EFFECTS: computes a transformation matrix that transforms a coordinate in system B to a coordinate in system A.
//          Symbol: C matrix

- (Vector2D*) fAVectorWith:(WorldyObject*)worldyObjectA And:(WorldyObject*)worldyObjectB;
// EFFECTS: computes (f subscript A) vector with worldyObjectA and worldyObjectB.
//          Symbol: f with arrow on top. Subscript A.

- (Vector2D*) fBVectorWith:(WorldyObject*)worldyObjectA And:(WorldyObject*)worldyObjectB;
// EFFECTS: computes (f subscript B) vector with worldyObjectA and worldyObjectB.
//          Symbol: f with arrow on top. Subscript B.

- (BOOL)hasCollidedCheck1:(Vector2D*)f_subscript_A :(Vector2D*)f_subscript_B;
// EFFECTS: returns YES if all components of f_subscript_A and f_subscript_B are negative.


- (BOOL) collisionResolution:(WorldyObject*)worldyObjectA :(WorldyObject*)worldyObjectB
         ReturnContactPoint1Ptr:(Vector2D**)c1 ReturnContactPoint2Ptr:(Vector2D**)c2;
// MODIFIES: c1, c2
// EFFECTS: Resolves the collision between these worldyObjectA, worldyObjectB.
//          Additionally, returns YES if collision was detected.
// note that this is Step 2 of Appendix.



@end
