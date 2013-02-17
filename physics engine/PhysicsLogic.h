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


@interface PhysicsLogic : NSObject <UIAccelerometerDelegate>{
    UIAccelerometer* iPadAccelerometer;
}

@property (readwrite) World *world;
@property (readwrite) Vector2D *gravity;
@property (readwrite) NSString* postNotificationName; // Alert changes to world property
@property (readonly) BOOL isUsingNotificationCenter;


/******* KEYS FOR DICTIONARY **********/
extern NSString *const KEY_c1_vector;
extern NSString *const KEY_c2_vector;
extern NSString *const KEY_c1_separation;
extern NSString *const KEY_c2_separation;
extern NSString *const KEY_n_vector;
extern NSString *const KEY_t_vector;
extern NSString *const KEY_velocity_vector_A;
extern NSString *const KEY_velocity_vector_B;
extern NSString *const KEY_angular_velocity_vector_A;
extern NSString *const KEY_angular_velocity_vector_B;

extern NSString *const KEY_collision_truth_value;
extern NSString *const KEY_computed_impluse_truth_value;

/***************************************/

- (PhysicsLogic*) initWithAlertToWorldChanges:(NSString*)myPostNotificationName;
// EFFECTS: ctor
//          gravity is set to (0,0).
//          NSNotificationCenter used to alert the outside world of changes to world.


- (PhysicsLogic*) initWithoutNotificationCenterUsage;
// EFFECTS: ctor
//          gravity is set to (0,0).
//          NSNotificationCenter is not used.

- (void) updateVelocity:(WorldyObject*)worldyObject;
// MODIFIES: velocity property of a worldly object.
// EFFECTS: updates the velocity property of a worldly object in accordance to formula provided in appendix.
//          note that this is part(1/2) of step 1 in appendix.

- (void) updateAngularVelocity:(WorldyObject*)worldyObject;
// MODIFIES: angular velocity property of a worldly object.
// EFFECTS: updates the angular velocity property of a worldly object in accordance to formula provided in appendix.
//          note that this is part(2/2) of step 1 in appendix.

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
         ReturnValues:(NSDictionary**)returnDict;
// MODIFIES: returnDict
// EFFECTS: Resolves the collision between these worldyObjectA, worldyObjectB.
//          Additionally, returns YES if collision was detected.
// note that this is Step 2 of Appendix.

- (NSDictionary*) impulsesOfCollisionBetween:(WorldyObject*)worldyObjectA
                                         And:(WorldyObject*)worldyObjectB
            WithValuesFromResolvingCollision:(NSDictionary*)dictFromResolvingCollision;
// REQUIRES: worldyObjectA and worldyObjectB be in collision.
// EFFECTS: Returns a NSdictionary of values that pertain to applying impulses to the collision.
// note that this is Step 3 of Appendix.

- (void) moveWorldyObjects:(WorldyObject*)worldyObjectA
                          :(WorldyObject*)worldyObjectB
                WithValues:(NSDictionary*)dictContainer;
// REQUIRES: dictContainer must contain:
//              final velocity of worldyObjectA
//              final velocity of worldyObjectB
//              final angular velocity of worldyObjectA
//              final angular velocity of worldyObjectB
// MODIFIES: worldyObjectA, worldyObjectB
// EFFECTS: Moves the worldyObjects involved. That is, updates the status of the bodies.
// note that this is Step 4 of Appendix.

- (void) simulateInteractionsInWorldOccurringInOneDeltaTime;
// MODIFIES: world
// EFFECTS: modifies world property to simulate the interactions between objects in world.
//          This is the "main" method that a UIViewController should call.
//          If property isUsingNotificationCenter == YES, each call of this method would
//          post a notification message.


- (void) simulateInteractionsWithNoCollisionResolutionInOnedt;
// MODIFIES: world
// EFFECTS: modifies world property to simulate no collisions between objects.

- (double) getDeltaTime;
// EFFECTS: returns the delta time of this physics engine.

- (void) addWorldyObject:(WorldyObject*)worldyObjectToAdd;
// MODIFIES: world property in this class.
// EFFECTS: adds worldyObjectToAdd to world property;



- (NSDictionary*) blah1;
- (void) blah2:(NSDictionary*)input;

@end
