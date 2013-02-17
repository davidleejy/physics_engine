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


@interface PhysicsLogic ()
@property (readwrite) BOOL isUsingNotificationCenter;
@end


@implementation PhysicsLogic


// *** SYNTHESIS ***
@synthesize world = _world;
@synthesize gravity = _gravity;
@synthesize postNotificationName = _postNotificationName;
@synthesize isUsingNotificationCenter = _isUsingNotificationCenter;


/******* KEYS FOR DICTIONARY **********/
NSString *const KEY_c1_vector = @"c1";
NSString *const KEY_c2_vector = @"c2";
NSString *const KEY_c1_separation = @"c1 sep";
NSString *const KEY_c2_separation = @"c2 sep";
NSString *const KEY_n_vector = @"n";
NSString *const KEY_t_vector = @"t";
NSString *const KEY_velocity_vector_A = @"velA";
NSString *const KEY_velocity_vector_B = @"velB";
NSString *const KEY_angular_velocity_vector_A = @"angVelA";
NSString *const KEY_angular_velocity_vector_B = @"andVelB";

NSString *const KEY_collision_truth_value = @"collided?";
NSString *const KEY_computed_impluse_truth_value = @"impulsed?";
/***************************************/



- (PhysicsLogic*) initWithAlertToWorldChanges:(NSString*)myPostNotificationName {
    
    self = [super init];
    
    if (!self) return nil;
    
    _world = [[World alloc]init];
    _gravity = [Vector2D vectorWith:0 y:0];
    _postNotificationName = myPostNotificationName;
    _isUsingNotificationCenter = YES;
    
    //Accelerometer for iPad device
    if([[[UIDevice currentDevice]model] rangeOfString:@"Simulator"].location == NSNotFound)
    {
        iPadAccelerometer = [UIAccelerometer sharedAccelerometer];
        iPadAccelerometer.delegate = self;
        iPadAccelerometer.updateInterval = 0.01;
    }
    else
    {
        iPadAccelerometer = nil;
    }

    
    return self;
}

- (PhysicsLogic*) initWithoutNotificationCenterUsage {
    self = [super init];
    
    if (!self) return nil;
    
    _world = [[World alloc]init];
    _gravity = [Vector2D vectorWith:0 y:0];
    _isUsingNotificationCenter = NO;
    
    //Accelerometer for iPad device
    if([[[UIDevice currentDevice]model] rangeOfString:@"Simulator"].location == NSNotFound)
    {
        iPadAccelerometer = [UIAccelerometer sharedAccelerometer];
        iPadAccelerometer.delegate = self;
        iPadAccelerometer.updateInterval = 0.01;
    }
    else
    {
        iPadAccelerometer = nil;
    }
    
    return self;
}


- (void) updateVelocity:(WorldyObject*)worldyObject {
    
    // If worldyObject cannot be moved, do not update its velocity.
    if ([worldyObject isUnmoveable]) {
        return;
    }
    
    // vel' = vel + dt*(grav + (netForce / mass))
    
//    [worldyObject setVelocity:
//    
//    [
//    [worldyObject velocity]
//    add:
//        [
//        (
//            [_gravity
//             add:
//            [[worldyObject netForce]multiply: (1.0/[worldyObject mass])]
//            ]
//        )
//        multiply:
//        DELTA_TIME
//        ]
//    ]
//     
//    ];
    
    
    [worldyObject setVelocity:[[worldyObject velocity]add:([_gravity multiply: DELTA_TIME])]];
}


- (void) updateAngularVelocity:(WorldyObject*)worldyObject {
    
    // If worldyObject cannot be moved, do not update its velocity.
    if ([worldyObject isUnmoveable]) {
        return;
    }

    // w' = w + dt*(torque / momentOfInertia)
    
//    [worldyObject setAngularVelocity:
//    
//        [worldyObject angularVelocity]
//        +
//        DELTA_TIME*([worldyObject netTorque] / [worldyObject momentOfInertia])
//     
//    ];
    
}


- (Matrix2D*) rotationMatrixOf:(WorldyObject*)worldyObject {
    return [Matrix2D initRotationMatrix:[worldyObject rotationAngle]];//matrixWithValues:cos([worldyObject rotationAngle])
//                                  and:sin([worldyObject rotationAngle])
//                                  and:-sin([worldyObject rotationAngle])
//                                  and:cos([worldyObject rotationAngle])];
}


- (Matrix2D*) transposedRotationMatrixOf:(WorldyObject*)worldyObject {
    
    Matrix2D* result = [Matrix2D initRotationMatrix:[worldyObject rotationAngle]];
    return [result transpose];
    
//    return [Matrix2D matrixWithValues:cos(-[worldyObject rotationAngle])
//                                  and:sin(-[worldyObject rotationAngle])
//                                  and:-sin(-[worldyObject rotationAngle])
//                                  and:cos(-[worldyObject rotationAngle])];
}


- (Vector2D*) hVectorOf:(WorldyObject*)worldyObject {
    return [Vector2D vectorWith:[worldyObject width]/2.0
                              y:[worldyObject height]/2.0];
}

- (Vector2D*) unitDirectionalVectorNormalToE1Of:(WorldyObject*)worldyObject {
    Matrix2D *rotationMat = [self rotationMatrixOf:worldyObject];
    return [rotationMat col1];
}

- (Vector2D*) unitDirectionalVectorNormalToE2Of:(WorldyObject*)worldyObject {
    Matrix2D *rotationMat = [self rotationMatrixOf:worldyObject];
    return [Vector2D vectorWith:-[[rotationMat col2]x]
                              y:-[[rotationMat col2]y]];
}

- (Vector2D*) unitDirectionalVectorNormalToE3Of:(WorldyObject*)worldyObject {
    Matrix2D *rotationMat = [self rotationMatrixOf:worldyObject];
    return [Vector2D vectorWith:-[[rotationMat col1]x]
                              y:-[[rotationMat col1]y]];
}

- (Vector2D*) unitDirectionalVectorNormalToE4Of:(WorldyObject*)worldyObject{
    Matrix2D *rotationMat = [self rotationMatrixOf:worldyObject];
    return [rotationMat col2];
}

- (Vector2D*) directionalVectorInWorldCoordSystemFrom:(WorldyObject*)worldyObjectA
                                                   To:(WorldyObject*)worldyObjectB
{
    return [[worldyObjectB position] subtract:[worldyObjectA position]];
}


- (Vector2D*) directionalVectorInWorldyObjectACoordSystemFrom:(WorldyObject*)worldyObjectA
                                                           To:(WorldyObject*)worldyObjectB
{
    return (
        [
            [self transposedRotationMatrixOf:worldyObjectA]
            multiplyVector:
            [self directionalVectorInWorldCoordSystemFrom:worldyObjectA To:worldyObjectB]
        ]
    );
}


- (Vector2D*) directionalVectorInWorldyObjectBCoordSystemFrom:(WorldyObject*)worldyObjectA
                                                           To:(WorldyObject*)worldyObjectB
{
    return (
        [
             [self transposedRotationMatrixOf:worldyObjectB]
             multiplyVector:
             [self directionalVectorInWorldCoordSystemFrom:worldyObjectA To:worldyObjectB]
         ]
    );
}


- (Matrix2D*) transformationMatrixToMapACoordinateInSystem:(WorldyObject*)worldyObjectB
                                     ToACoordinateInSystem:(WorldyObject*)worldyObjectA
{
    Matrix2D* matRTA = [self transposedRotationMatrixOf:worldyObjectA];
    Matrix2D* matRB = [self rotationMatrixOf:worldyObjectB];
    return [matRTA multiply:matRB];
}


- (Vector2D*) fAVectorWith:(WorldyObject*)worldyObjectA And:(WorldyObject*)worldyObjectB {
    
    // f_subscript_A = absolute_d_subscript_A - h_subscript_A - crossPdt(absolute_C, h_subscript_B)
    
    Vector2D* absolute_d_subscript_A =
    [[self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA
                                                        To:worldyObjectB] abs];
    Vector2D* h_subscript_A =
    [self hVectorOf:worldyObjectA];
    
    Matrix2D* absolute_C =
    [[self transformationMatrixToMapACoordinateInSystem:worldyObjectB
                                  ToACoordinateInSystem:worldyObjectA] abs];
    
    Vector2D* h_subscript_B =
    [self hVectorOf:worldyObjectB];
    
    Vector2D* crossPdt = [absolute_C multiplyVector:h_subscript_B];
    
    return [[absolute_d_subscript_A subtract:h_subscript_A]subtract:crossPdt];
    
}


- (Vector2D*) fBVectorWith:(WorldyObject*)worldyObjectA And:(WorldyObject*)worldyObjectB {
    
    // f_subscript_B = absolute_d_subscript_B - h_subscript_B - crossPdt(absolute_C_transposed, h_subscript_A)
    
    Vector2D* absolute_d_subscript_B =
    [[self directionalVectorInWorldyObjectBCoordSystemFrom:worldyObjectA
                                                        To:worldyObjectB] abs];
    
    Vector2D* h_subscript_B =
    [self hVectorOf:worldyObjectB];
    
    Matrix2D* absolute_C_transposed =
    [[[self transformationMatrixToMapACoordinateInSystem:worldyObjectB
                                  ToACoordinateInSystem:worldyObjectA] transpose] abs];
    
    Vector2D* h_subscript_A =
    [self hVectorOf:worldyObjectA];
    
    Vector2D* crossPdt = [absolute_C_transposed multiplyVector:h_subscript_A];
    
    return [[absolute_d_subscript_B subtract:h_subscript_B]subtract:crossPdt];
}



- (BOOL)hasCollidedCheck1:(Vector2D*)f_subscript_A :(Vector2D*)f_subscript_B {
    
    return ([f_subscript_A x] < 0) &&
            ([f_subscript_A y] < 0) &&
            ([f_subscript_B x] < 0) &&
            ([f_subscript_B y] < 0);
}


- (BOOL)collisionResolution:(WorldyObject*)worldyObjectA :(WorldyObject*)worldyObjectB
        ReturnValues:(NSDictionary**)returnDict {
    
    // 1. Check whether worldyObjects A and B in the midst of a collision.
    Vector2D* f_subscript_A = [self fAVectorWith:worldyObjectA And:worldyObjectB];
    Vector2D* f_subscript_B = [self fBVectorWith:worldyObjectA And:worldyObjectB];
    
    BOOL hasCollided = [self hasCollidedCheck1:f_subscript_A :f_subscript_B];
    
    if (!hasCollided) {
        // no additional computations required if worldyObjects A and B are not in the midst of a collision.
        return NO;
    }
    
    
    // 2. Pick the smallest component out of f_subscript_A and f_subscript_B.
    //      note that at this stage, all f components are negative!
    double tempArray [4] = {
        [f_subscript_A x],
        [f_subscript_A y],
        [f_subscript_B x],
        [f_subscript_B y]};
    
    double max = tempArray[0];
    unsigned short int indexOfMax = 0;
//    NSLog(@"tempArray[%d] == %.9f", 0, tempArray[0]); //DEBUG
    for(int i=1;i<4;i++) {
//        NSLog(@"tempArray[%d] == %.9f", i, tempArray[i]); //DEBUG
        
        if (tempArray[i] > max) {
            max = tempArray[i];
            indexOfMax = i;
        }
    }
    // max and indexOfMax should now contain the value and index (respectively) of the largest
    // component in f_subscript_A and f_subscript_B.
    
    
    // 3. Now depending on which indexOfMax, we do the following:
    
    Vector2D *n_subscript_f;
    Vector2D *n_subscript_s;
    Vector2D *n_vector;
    double D_subscript_f;
    double D_subscript_s;
    double D_subscript_neg;
    double D_subscript_pos;
    
    switch (indexOfMax)
    {
        case 0: {// [f_subscript_A x] is smallest
            
            Matrix2D *R_subscript_A = [self rotationMatrixOf:worldyObjectA];
            
            if ( [[self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA To:worldyObjectB] x]
                > 0)
            {
                n_vector = [R_subscript_A col1];
            }
            else {
                n_vector = [[R_subscript_A col1] negate];
            }
            
            n_subscript_f = n_vector; // (5)
            
            
            Vector2D *h_subscript_A = [self hVectorOf:worldyObjectA];
            
            D_subscript_f = [[worldyObjectA position] dot:n_subscript_f] + [h_subscript_A x]; //(6)
            n_subscript_s = [R_subscript_A col2]; // (7)
            D_subscript_s = [[worldyObjectA position] dot:n_subscript_s]; // (8)
            D_subscript_neg = [h_subscript_A y] - D_subscript_s; // (9)
            D_subscript_pos = [h_subscript_A y] + D_subscript_s; // (10)
            
            break;
        }
        case 1: {// [f_subscript_A y] is smallest
            
            Matrix2D *R_subscript_A = [self rotationMatrixOf:worldyObjectA];
            
            if ( [[self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA To:worldyObjectB] y]
                > 0)
            {
                n_vector = [R_subscript_A col2];
            }
            else {
                n_vector = [[R_subscript_A col2] negate];
            }
            
            n_subscript_f = n_vector; // (11)
            
            Vector2D *h_subscript_A = [self hVectorOf:worldyObjectA];
            
            D_subscript_f = [[worldyObjectA position] dot:n_subscript_f] + [h_subscript_A y]; //(12)
            n_subscript_s = [R_subscript_A col1]; // (13)
            D_subscript_s = [[worldyObjectA position] dot:n_subscript_s]; // (14)
            D_subscript_neg = [h_subscript_A x] - D_subscript_s; // (15)
            D_subscript_pos = [h_subscript_A x] + D_subscript_s; // (16)
            
            break;
        }
        case 2: {// [f_subscript_B x] is smallest
            
            Matrix2D *R_subscript_B = [self rotationMatrixOf:worldyObjectB];
            
            if ( [[self directionalVectorInWorldyObjectBCoordSystemFrom:worldyObjectA To:worldyObjectB] x]
                > 0)
            {
                n_vector = [R_subscript_B col1];
            }
            else {
                n_vector = [[R_subscript_B col1] negate];
            }
            
            n_subscript_f = [n_vector negate]; // (17)
            
            Vector2D *h_subscript_B = [self hVectorOf:worldyObjectB];
            
            D_subscript_f = [[worldyObjectB position] dot:n_subscript_f] + [h_subscript_B x]; //(18)
            n_subscript_s = [R_subscript_B col2]; // (19)
            D_subscript_s = [[worldyObjectB position] dot:n_subscript_s]; // (20)
            D_subscript_neg = [h_subscript_B y] - D_subscript_s; // (21)
            D_subscript_pos = [h_subscript_B y] + D_subscript_s; // (22)
            
            break;
        }
        case 3: {// [f_subscript_B y] is smallest
            
            Matrix2D *R_subscript_B = [self rotationMatrixOf:worldyObjectB];
            
            if ( [[self directionalVectorInWorldyObjectBCoordSystemFrom:worldyObjectA To:worldyObjectB] y]
                > 0)
            {
                n_vector = [R_subscript_B col2];
            }
            else {
                n_vector = [[R_subscript_B col2] negate];
            }
            
            n_subscript_f = [n_vector negate]; // (23)
            
            Vector2D *h_subscript_B = [self hVectorOf:worldyObjectB];
            
            D_subscript_f = [[worldyObjectB position] dot:n_subscript_f] + [h_subscript_B y]; //(24)
            n_subscript_s = [R_subscript_B col1]; // (25)
            D_subscript_s = [[worldyObjectB position] dot:n_subscript_s]; // (26)
            D_subscript_neg = [h_subscript_B x] - D_subscript_s; // (27)
            D_subscript_pos = [h_subscript_B x] + D_subscript_s; // (28)
            
            break;
        }
        default:
            [NSException raise:@"collisionResolution function, step 3. indexOfMin is invalid." format:@"indexOfMin == %d",indexOfMax];
            break;
    }
    
    
    // 4. Now that we’ve got the reference edge, we need to find the incident edge.
    //    Denote by v1_vector and v2_vector, the position vectors of the end points of the incident edge.
    
    Vector2D *n_subscript_i;
    Vector2D *p_vector;
    Matrix2D *R_matrix;
    Vector2D *h_vector;
    
    switch (indexOfMax) {
        case 0: case 1: {
            n_subscript_i = [[[self transposedRotationMatrixOf:worldyObjectB]
                              multiplyVector:n_subscript_f]
                             negate];
//            p_vector = [self directionalVectorInWorldyObjectBCoordSystemFrom:worldyObjectA
//                                                                          To:worldyObjectB];
            p_vector = [worldyObjectB position];
            
            R_matrix = [self rotationMatrixOf:worldyObjectB];
            h_vector = [self hVectorOf:worldyObjectB];
            
            break;
        }
        case 2: case 3: {
            n_subscript_i = [[[self transposedRotationMatrixOf:worldyObjectA]
                              multiplyVector:n_subscript_f]
                             negate];
//            p_vector = [self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA
//                                                                          To:worldyObjectB];
            
            p_vector = [worldyObjectA position];
            
            R_matrix = [self rotationMatrixOf:worldyObjectA];
            h_vector = [self hVectorOf:worldyObjectA];
            
            break;
        }
        default:
            [NSException raise:@"collisionResolution function, step 3. indexOfMin is invalid." format:@"indexOfMin == %d",indexOfMax];
            break;
    }
    
    // Then: (Appendix p 11)
    
    Vector2D *n_subscript_i_abs = [n_subscript_i abs];
    Vector2D *v1_vector;
    Vector2D *v2_vector;
    
    if ([n_subscript_i_abs x] > [n_subscript_i_abs y] &&
        [n_subscript_i x] > 0)
    {
        Vector2D *temp_vector_1 = [Vector2D vectorWith:[h_vector x] y:(-[h_vector y])];
        
        v1_vector = [p_vector add:[R_matrix multiplyVector:temp_vector_1]];
        v2_vector = [p_vector add:[R_matrix multiplyVector:h_vector]];
        
    }
    else if ([n_subscript_i_abs x] > [n_subscript_i_abs y] &&
             [n_subscript_i x] <= 0)
    {
        Vector2D *temp_vector_1 = [Vector2D vectorWith:(-[h_vector x]) y:[h_vector y]];
        
        v1_vector = [p_vector add:[R_matrix multiplyVector:temp_vector_1]];
        v2_vector = [p_vector add:[R_matrix multiplyVector:[h_vector negate]]];
        
    }
    else if ([n_subscript_i_abs x] <= [n_subscript_i_abs y] &&
             [n_subscript_i y] > 0)
    {
        v1_vector = [p_vector add:[R_matrix multiplyVector:h_vector]];
        
        Vector2D *temp_vector_2 = [Vector2D vectorWith:(-[h_vector x]) y:[h_vector y]];
        
        v2_vector = [p_vector add:[R_matrix multiplyVector:temp_vector_2]];
        
    }
    else if ([n_subscript_i_abs x] <= [n_subscript_i_abs y] &&
             [n_subscript_i y] <= 0)
    {
        v1_vector = [p_vector add:[R_matrix multiplyVector:[h_vector negate]]];
        
        Vector2D *temp_vector_2 = [Vector2D vectorWith:[h_vector x] y:(-[h_vector y])];
        
        v2_vector = [p_vector add:[R_matrix multiplyVector:temp_vector_2]];
    }
    else
    {
        [NSException raise:@"collisionResolution function, step 4. n_subscript_i vector got error." format:@""];
    }
    
    
    // 5. Clip the incident edge to make it fall within
    //    the boundaries of the edges adjacent to the reference edge.
    
    // First Clip
    
    Vector2D *v1_vector_prime;
    Vector2D *v2_vector_prime;
    double dist1 = (-[n_subscript_s dot:v1_vector]) - D_subscript_neg; // (29)
    double dist2 = (-[n_subscript_s dot:v2_vector]) - D_subscript_neg; // (30)
    
    if (dist1<=0 && dist2<=0) {
        v1_vector_prime = v1_vector; // (31)
        v2_vector_prime = v2_vector; // (32)
    }
    else if (dist1>0 && dist2>0) {
        // The rectangles A and B simply do not collide
        // with each other. We skip this pair of bodies.
        return NO;
    }
    else if (dist1<0 && dist2>0){
        // Clip v2 to fall on clipping line 1 by interpolating segment v1v2.
        
        v1_vector_prime = v1_vector;// (33)

        // (34) below
        v2_vector_prime = [v1_vector add:
                           [[v2_vector subtract:v1_vector] multiply:(dist1/(dist1-dist2))]
                           ];
    }
    else if (dist1>0 && dist2<0){
        // Clip v1 to fall on clipping line 1 by interpolating segment v1v2.
        
        v1_vector_prime = v2_vector; // (35)
        
        // (36) below
        v2_vector_prime = [v1_vector add:
                           [[v2_vector subtract:v1_vector] multiply:(dist1/(dist1-dist2))]
                           ];
    }
    else
    {
        [NSException raise:@"collisionResolution function, step 5. first clipping got error." format:@""];
    }
    
    
    // Second Clip
    
    // reusing dist1 and dist2 variables.
    dist1 = [n_subscript_s dot:v1_vector_prime] - D_subscript_pos; // (37)
    dist2 = [n_subscript_s dot:v2_vector_prime] - D_subscript_pos; // (38)
    
    Vector2D *v1_vector_primeprime;
    Vector2D *v2_vector_primeprime;
    
    if (dist1<=0 && dist2<=0) {
        v1_vector_primeprime = v1_vector_prime; // (39)
        v2_vector_primeprime = v2_vector_prime; // (40)
    }
    else if (dist1>0 && dist2>0) {
        // The rectangles A and B simply do not collide
        // with each other. We skip this pair of bodies.
        return NO;
    }
    else if (dist1<0 && dist2>0){
        // Clip v2' to fall on clipping line 2 by interpolating segment v1'v2'.
        
        v1_vector_primeprime = v1_vector_prime;// (41)
        
        // (42) below
        v2_vector_primeprime = [v1_vector_prime add:
                                [[v2_vector_prime subtract:v1_vector_prime] multiply:(dist1/(dist1-dist2))]
                                ];
    }
    else if (dist1>0 && dist2<0){
        // Clip v1' to fall on clipping line 2 by interpolating segment v1'v2'.
        
        v1_vector_primeprime = v2_vector_prime; // (43)
        
        // (44) below
        v2_vector_primeprime = [v1_vector_prime add:
                                [[v2_vector_prime subtract:v1_vector_prime] multiply:(dist1/(dist1-dist2))]
                                ];
    }
    else
    {
        [NSException raise:@"collisionResolution function, step 5. second clipping got error." format:@""];
    }
    
    // Finished clippings.

    // TODO p 14 appendix unsure.
    
    double s1 = [n_subscript_f dot:v1_vector_primeprime] - D_subscript_f; // (45)
    Vector2D *c1 = [v1_vector_primeprime subtract:[n_subscript_f multiply:s1]]; // (46)
    double s2 = [n_subscript_f dot:v2_vector_primeprime] - D_subscript_f; // (47)
    Vector2D *c2 = [v2_vector_primeprime subtract:[n_subscript_f multiply:s2]]; // (48)
    
    Vector2D *t_vector = [n_vector crossZ:1.0];
    
    // Fill argument returnDict
    NSArray *keys = [NSArray arrayWithObjects:
                     KEY_c1_vector,
                     KEY_c1_separation,
                     KEY_c2_vector,
                     KEY_c2_separation,
                     KEY_n_vector,
                     KEY_t_vector,nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        c1,
                        [NSNumber numberWithDouble:s1],
                        c2,
                        [NSNumber numberWithDouble:s2],
                        n_vector,
                        t_vector, nil];
    *returnDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
//    NSLog(@"collisionResolution");
//    NSLog(@"c1(%.7f,%.7f) c1sep %.7f c2(%.7f,%.7f) c2sep %.7f",[c1 x],[c1 y],s1,[c2 x],[c2 y],s2);
//    NSLog(@"n(%.7f,%.7f) t(%.7f,%.7f)",[n_vector x],[n_vector y],[t_vector x],[t_vector y]);
    
    return YES;
}


- (NSDictionary*) impulsesOfCollisionBetween:(WorldyObject*)worldyObjectA
                                         And:(WorldyObject*)worldyObjectB
            WithValuesFromResolvingCollision:(NSDictionary*)dictFromResolvingCollision {
    
    // To know what dictFromResolvingCollision contains, see the end of the collisionResolution
    // function.
    
    // Grab variables from the dictFromResolvingCollision
    Vector2D *c1 = [dictFromResolvingCollision objectForKey:KEY_c1_vector];
    Vector2D *c2 = [dictFromResolvingCollision objectForKey:KEY_c2_vector];
    NSNumber *c1_separation_NSNumber = [dictFromResolvingCollision objectForKey:KEY_c1_separation];
    NSNumber *c2_separation_NSNumber = [dictFromResolvingCollision objectForKey:KEY_c2_separation];
    double c1_separation = [c1_separation_NSNumber doubleValue];
    double c2_separation = [c2_separation_NSNumber doubleValue];
    Vector2D *n_vector = [dictFromResolvingCollision objectForKey:KEY_n_vector];
    Vector2D *t_vector = [dictFromResolvingCollision objectForKey:KEY_t_vector];
    
//    NSLog(@"impulseCalculation");
//    NSLog(@"c1(%.7f,%.7f) c1sep %.7f c2(%.7f,%.7f) c2sep %.7f",[c1 x],[c1 y],c1_separation,[c2 x],[c2 y],c2_separation);
//    NSLog(@"n(%.7f,%.7f) t(%.7f,%.7f)",[n_vector x],[n_vector y],[t_vector x],[t_vector y]);
    
    
    // Values that are needed in computations
    Vector2D* p_subscript_A = [worldyObjectA position];
    Vector2D* p_subscript_B = [worldyObjectB position];
    Vector2D* v_subscript_A = [worldyObjectA velocity];
    Vector2D* v_subscript_B = [worldyObjectB velocity];
    double w_subscript_A = [worldyObjectA angularVelocity];
    double w_subscript_B = [worldyObjectB angularVelocity];
    double I_A = [worldyObjectA momentOfInertia];
    double I_B = [worldyObjectB momentOfInertia];
    double m_A = [worldyObjectA mass];
    double m_B = [worldyObjectB mass];
    double coeffOfRestitution = sqrt([worldyObjectA restitutionCoeff]*[worldyObjectB restitutionCoeff]);
    double coeffOfFriction_A = [worldyObjectA frictionCoeff];
    double coeffOfFriction_B = [worldyObjectB frictionCoeff];
        // For c1
    Vector2D* r_subscript_A_c1 = [c1 subtract:p_subscript_A]; // (49)
    Vector2D* r_subscript_B_c1 = [c1 subtract:p_subscript_B]; // (50)
        // For c2
    Vector2D* r_subscript_A_c2 = [c2 subtract:p_subscript_A]; // (49)
    Vector2D* r_subscript_B_c2 = [c2 subtract:p_subscript_B]; // (50)
    
    // Declare variables for computation.
    Vector2D* u_subscript_A;
    Vector2D* u_subscript_B;
    Vector2D* u_vector;
    double u_subscript_n;
    double u_subscript_t;
    double mass_n;
    double mass_t;
    Vector2D* P_subscript_n;
    double delta_P_subscript_t;
//    double temp;
    double P_subscript_tmax;
    Vector2D* P_subscript_t;
//    double min_of_dPt_and_Ptmax;
    
    
    
    if (c1_separation < 0) {
        
        /////////////////////////////
        // ----- work with c1 ----- //
        /////////////////////////////
        
        for (int iter=0; iter<ITERATIONS_IN_IMPULSE_CALCULATION; iter++) {
            u_subscript_A = [v_subscript_A add:[r_subscript_A_c1 crossZ:w_subscript_A]]; // (51) //TODO should be -wA
            u_subscript_B = [v_subscript_B add:[r_subscript_B_c1 crossZ:w_subscript_B]]; // (52) //TODO should be -wB
            u_vector = [u_subscript_B subtract:u_subscript_A]; // (53)
            u_subscript_n = [u_vector dot:n_vector]; // (54)
            u_subscript_t = [u_vector dot:t_vector]; // (55)
            
            mass_n = [self normalMassUsingMassA:m_A
                                          MassB:m_B
                                       InertiaA:I_A
                                       InertiaB:I_B
                                         r_of_A:r_subscript_A_c1
                                         r_of_B:r_subscript_B_c1
                                       n_vector:n_vector];              // (56)
            
            mass_t = [self tangentialMassUsingMassA:m_A
                                              MassB:m_B
                                           InertiaA:I_A
                                           InertiaB:I_B
                                             r_of_A:r_subscript_A_c1
                                             r_of_B:r_subscript_B_c1
                                           t_vector:t_vector];          // (57)
            
            // (58) start
            
//            temp = mass_n*(1.0+coeffOfRestitution)*u_subscript_n;
//            
//            if (temp >= 0) {
//                P_subscript_n = [Vector2D vectorWith:0 y:0];
//            }
//            else {
//                P_subscript_n = [n_vector multiply:temp];
//            }
            
            P_subscript_n = [n_vector multiply:MIN(0,(mass_n*(1.0+coeffOfRestitution)*u_subscript_n))];
            // (58) end
            
            
            delta_P_subscript_t = mass_t*u_subscript_t; // (59)
            
            
            // (60) start
            P_subscript_tmax = coeffOfFriction_A*coeffOfFriction_B*[P_subscript_n length];
            delta_P_subscript_t = MAX(-P_subscript_tmax, MIN(delta_P_subscript_t, P_subscript_tmax));
            //        if (delta_P_subscript_t <= P_subscript_tmax) {
            //            min_of_dPt_and_Ptmax = delta_P_subscript_t;
            //        } else {
            //            min_of_dPt_and_Ptmax = P_subscript_tmax;
            //        }
            //
            //        if ((-(P_subscript_tmax)) >= min_of_dPt_and_Ptmax) {
            //            delta_P_subscript_t = (-(P_subscript_tmax));
            //        }
            //        else {
            //            delta_P_subscript_t = min_of_dPt_and_Ptmax;
            //        }
            // (60) end
            
            P_subscript_t = [t_vector multiply:delta_P_subscript_t]; // Calculate tangential impulse
            
            v_subscript_A = [v_subscript_A add: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_A)]]; // (61)
            v_subscript_B = [v_subscript_B subtract: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_B)]]; // (62)
//            w_subscript_A = w_subscript_A +
//            ([[r_subscript_A_c1 multiply:(1.0/I_A)] cross:[P_subscript_n add:P_subscript_t]]); // (63)
//            
//            w_subscript_B = w_subscript_B -
//            ([[r_subscript_B_c1 multiply:(1.0/I_B)] cross:[P_subscript_n add:P_subscript_t]]); // (64)
            
            w_subscript_A = w_subscript_A +
            ([r_subscript_A_c1 cross:[P_subscript_n add:P_subscript_t]] / I_A); // (63)
            
            w_subscript_B = w_subscript_B -
            ([r_subscript_B_c1 cross:[P_subscript_n add:P_subscript_t]] / I_B); // (64)
        }
    }
    
//    NSLog(@"IMPULSE CAL inbetween c1 and c2");
//    [v_subscript_A printWithPrefix:@"vA"];
//    [v_subscript_B printWithPrefix:@"vB"];
//    NSLog(@"wA %.7f wB %.7f",w_subscript_A,w_subscript_B);
    
    
    
    
    if (c2_separation < 0) {
        
        /////////////////////////////
        // ----- work with c2 ----- //
        /////////////////////////////
        
        for (int iter=0; iter<ITERATIONS_IN_IMPULSE_CALCULATION; iter++) {
            u_subscript_A = [v_subscript_A add:[r_subscript_A_c2 crossZ:w_subscript_A]]; // (51) // TODO should be -w_subscript_A
            u_subscript_B = [v_subscript_B add:[r_subscript_B_c2 crossZ:w_subscript_B]]; // (52) // TODO should be -ve wB
            u_vector = [u_subscript_B subtract:u_subscript_A]; // (53)
            u_subscript_n = [u_vector dot:n_vector]; // (54)
            u_subscript_t = [u_vector dot:t_vector]; // (55)
            
            mass_n = [self normalMassUsingMassA:m_A
                                          MassB:m_B
                                       InertiaA:I_A
                                       InertiaB:I_B
                                         r_of_A:r_subscript_A_c2
                                         r_of_B:r_subscript_B_c2
                                       n_vector:n_vector];              // (56)
            
            mass_t = [self tangentialMassUsingMassA:m_A
                                              MassB:m_B
                                           InertiaA:I_A
                                           InertiaB:I_B
                                             r_of_A:r_subscript_A_c2
                                             r_of_B:r_subscript_B_c2
                                           t_vector:t_vector];          // (57)
            
            // (58) start
            
//            temp = mass_n*(1.0+coeffOfRestitution)*u_subscript_n;
//            
//            if (temp >= 0) {
//                P_subscript_n = [Vector2D vectorWith:0 y:0];
//            }
//            else {
//                P_subscript_n = [n_vector multiply:temp];
//            }
            
            P_subscript_n = [n_vector multiply:MIN(0,(mass_n*(1.0+coeffOfRestitution)*u_subscript_n))];
            
            // (58) end
            
            
            delta_P_subscript_t = mass_t*u_subscript_t; // (59)
            
            // (60) start
            P_subscript_tmax = coeffOfFriction_A*coeffOfFriction_B*[P_subscript_n length];
            delta_P_subscript_t = MAX(-P_subscript_tmax, MIN(delta_P_subscript_t, P_subscript_tmax));
            //        if (delta_P_subscript_t <= P_subscript_tmax) {
            //            min_of_dPt_and_Ptmax = delta_P_subscript_t;
            //        } else {
            //            min_of_dPt_and_Ptmax = P_subscript_tmax;
            //        }
            //
            //        if ((-(P_subscript_tmax)) >= min_of_dPt_and_Ptmax) {
            //            delta_P_subscript_t = (-(P_subscript_tmax));
            //        }
            //        else {
            //            delta_P_subscript_t = min_of_dPt_and_Ptmax;
            //        }
            // (60) end
            
            P_subscript_t = [t_vector multiply:delta_P_subscript_t]; // Calculate tangential impulse
            
            v_subscript_A = [v_subscript_A add: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_A)]]; // (61)
            v_subscript_B = [v_subscript_B subtract: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_B)]]; // (62)
//            w_subscript_A = w_subscript_A +
//            ([[r_subscript_A_c2 multiply:(1.0/I_A)] cross:[P_subscript_n add:P_subscript_t]]); // (63)
//            w_subscript_B = w_subscript_B -
//            ([[r_subscript_B_c2 multiply:(1.0/I_B)] cross:[P_subscript_n add:P_subscript_t]]); // (64)
            
            w_subscript_A = w_subscript_A +
            ([r_subscript_A_c2 cross:[P_subscript_n add:P_subscript_t]] / I_A); // (63)
            
            w_subscript_B = w_subscript_B -
            ([r_subscript_B_c2 cross:[P_subscript_n add:P_subscript_t]] / I_B); // (64)
            
        }
        
    }
    
/*
    for (int iter=0; iter<ITERATIONS_IN_IMPULSE_CALCULATION; iter++) {
        
        /////////////////////////////
        // ----- work with c1 ----- //
        /////////////////////////////
        
        u_subscript_A = [v_subscript_A add:[r_subscript_A_c1 crossZ:-w_subscript_A]]; // (51)
        u_subscript_B = [v_subscript_B add:[r_subscript_B_c1 crossZ:-w_subscript_B]]; // (52)
        u_vector = [u_subscript_B subtract:u_subscript_A]; // (53)
        u_subscript_n = [u_vector dot:n_vector]; // (54)
        u_subscript_t = [u_vector dot:t_vector]; // (55)
        
        mass_n = [self normalMassUsingMassA:m_A
                                      MassB:m_B
                                   InertiaA:I_A
                                   InertiaB:I_B
                                     r_of_A:r_subscript_A_c1
                                     r_of_B:r_subscript_B_c1
                                   n_vector:n_vector];              // (56)
        
        mass_t = [self tangentialMassUsingMassA:m_A
                                          MassB:m_B
                                       InertiaA:I_A
                                       InertiaB:I_B
                                         r_of_A:r_subscript_A_c1
                                         r_of_B:r_subscript_B_c1
                                       t_vector:t_vector];          // (57)
        
        // (58) start
        
        temp = mass_n*(1.0+coeffOfRestitution)*u_subscript_n;
        
        if (temp >= 0) {
            P_subscript_n = [Vector2D vectorWith:0 y:0];
        }
        else {
            P_subscript_n = [n_vector multiply:temp];
        }
        // (58) end
        
        
        delta_P_subscript_t = mass_t*u_subscript_t; // (59)
        
        
        // (60) start
        P_subscript_tmax = coeffOfFriction_A*coeffOfFriction_B*[P_subscript_n length];
        delta_P_subscript_t = MAX(-P_subscript_tmax, MIN(delta_P_subscript_t, P_subscript_tmax));
//        if (delta_P_subscript_t <= P_subscript_tmax) {
//            min_of_dPt_and_Ptmax = delta_P_subscript_t;
//        } else {
//            min_of_dPt_and_Ptmax = P_subscript_tmax;
//        }
//        
//        if ((-(P_subscript_tmax)) >= min_of_dPt_and_Ptmax) {
//            delta_P_subscript_t = (-(P_subscript_tmax));
//        }
//        else {
//            delta_P_subscript_t = min_of_dPt_and_Ptmax;
//        }
        // (60) end
        
        P_subscript_t = [t_vector multiply:delta_P_subscript_t]; // Calculate tangential impulse
        
        v_subscript_A = [v_subscript_A add: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_A)]]; // (61)
        v_subscript_B = [v_subscript_B subtract: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_B)]]; // (62)
        w_subscript_A = w_subscript_A +
                        ([[r_subscript_A_c1 multiply:(1.0/I_A)] cross:[P_subscript_n add:P_subscript_t]]); // (63)
        w_subscript_B = w_subscript_B -
                        ([[r_subscript_B_c1 multiply:(1.0/I_B)] cross:[P_subscript_n add:P_subscript_t]]); // (64)
        
        
        /////////////////////////////
        // ----- work with c2 ----- //
        /////////////////////////////
        
        u_subscript_A = [v_subscript_A add:[r_subscript_A_c2 crossZ:-w_subscript_A]]; // (51)
        u_subscript_B = [v_subscript_B add:[r_subscript_B_c2 crossZ:-w_subscript_B]]; // (52)
        u_vector = [u_subscript_B subtract:u_subscript_A]; // (53)
        u_subscript_n = [u_vector dot:n_vector]; // (54)
        u_subscript_t = [u_vector dot:t_vector]; // (55)
        
        mass_n = [self normalMassUsingMassA:m_A
                                      MassB:m_B
                                   InertiaA:I_A
                                   InertiaB:I_B
                                     r_of_A:r_subscript_A_c2
                                     r_of_B:r_subscript_B_c2
                                   n_vector:n_vector];              // (56)
        
        mass_t = [self tangentialMassUsingMassA:m_A
                                          MassB:m_B
                                       InertiaA:I_A
                                       InertiaB:I_B
                                         r_of_A:r_subscript_A_c2
                                         r_of_B:r_subscript_B_c2
                                       t_vector:t_vector];          // (57)
        
        // (58) start
        
        temp = mass_n*(1.0+coeffOfRestitution)*u_subscript_n;
        
        if (temp >= 0) {
            P_subscript_n = [Vector2D vectorWith:0 y:0];
        }
        else {
            P_subscript_n = [n_vector multiply:temp];
        }
        // (58) end
        
        
        delta_P_subscript_t = mass_t*u_subscript_t; // (59)
     
        // (60) start
        P_subscript_tmax = coeffOfFriction_A*coeffOfFriction_B*[P_subscript_n length];
        delta_P_subscript_t = MAX(-P_subscript_tmax, MIN(delta_P_subscript_t, P_subscript_tmax));
//        if (delta_P_subscript_t <= P_subscript_tmax) {
//            min_of_dPt_and_Ptmax = delta_P_subscript_t;
//        } else {
//            min_of_dPt_and_Ptmax = P_subscript_tmax;
//        }
//        
//        if ((-(P_subscript_tmax)) >= min_of_dPt_and_Ptmax) {
//            delta_P_subscript_t = (-(P_subscript_tmax));
//        }
//        else {
//            delta_P_subscript_t = min_of_dPt_and_Ptmax;
//        }
        // (60) end
        
        P_subscript_t = [t_vector multiply:delta_P_subscript_t]; // Calculate tangential impulse
        
        v_subscript_A = [v_subscript_A add: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_A)]]; // (61)
        v_subscript_B = [v_subscript_B subtract: [[P_subscript_n add:P_subscript_t] multiply:(1.0/m_B)]]; // (62)
        w_subscript_A = w_subscript_A +
        ([[r_subscript_A_c2 multiply:(1.0/I_A)] cross:[P_subscript_n add:P_subscript_t]]); // (63)
        w_subscript_B = w_subscript_B -
        ([[r_subscript_B_c2 multiply:(1.0/I_B)] cross:[P_subscript_n add:P_subscript_t]]); // (64)
    
    } // end of iterations
*/
    
    // Hack
//    if(fabs(worldyObjectA.velocity.x - v_subscript_A.x) < MAX(fabs(worldyObjectA.velocity.x),fabs(v_subscript_A.x)))
//        v_subscript_A = [Vector2D vectorWith:-(v_subscript_A.x) y:v_subscript_A.y];
//    if(fabs(worldyObjectA.velocity.y - v_subscript_A.y) < MAX(fabs(worldyObjectA.velocity.y),fabs(v_subscript_A.y)))
//        v_subscript_A = [Vector2D vectorWith:(v_subscript_A.x) y:-(v_subscript_A.y)];
    
    
    
    // Return a NSdictionary of values that are needed to move the bodies.
    NSArray *keys = [NSArray arrayWithObjects:
                     KEY_velocity_vector_A,
                     KEY_velocity_vector_B,
                     KEY_angular_velocity_vector_A,
                     KEY_angular_velocity_vector_B,nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        v_subscript_A,
                        v_subscript_B,
                        [NSNumber numberWithDouble:w_subscript_A],
                        [NSNumber numberWithDouble:w_subscript_B], nil];
    
    //TODO
//    [v_subscript_A printWithPrefix:@"vA"];
//    [v_subscript_B printWithPrefix:@"vB"];
//    NSLog(@"wA %.7f wB %.7f",w_subscript_A,w_subscript_B);
    
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
        
}



// Helper function for equation (56)
- (double) normalMassUsingMassA:(double)m_A
                         MassB:(double)m_B
                      InertiaA:(double)I_A
                      InertiaB:(double)I_B
                        r_of_A:(Vector2D*)r_A
                        r_of_B:(Vector2D*)r_B
                      n_vector:(Vector2D*)n
{
    double thirdTermInDenom = ([r_A dot:r_A] - ([r_A dot:n]*[r_A dot:n])) / I_A;
    double fourthTermInDenom = ([r_B dot:r_B] - ([r_B dot:n]*[r_B dot:n])) / I_B;
    
    /*
    double mn_dominator = (1/m_A) + (1/m_B) + (([r_A dot:r_A] - ([r_A dot:n]*[r_A dot:n]))/I_A) + (([r_B dot:r_B] - ([r_B dot:n]*[r_B dot:n]))/I_B);
	double mn = 1.0/mn_dominator;
    
    double myRes = (1.0 /
                    ((1.0/m_A) + (1.0/m_B) + thirdTermInDenom + fourthTermInDenom)
                    );
    
    NSLog(@"mn == %.9f, my res == %.9f", mn, myRes);
    
     */
    
    return (1.0 /
            ((1.0/m_A) + (1.0/m_B) + thirdTermInDenom + fourthTermInDenom)
            );
}

// Helper function for equation (57)
- (double) tangentialMassUsingMassA:(double)m_A
                          MassB:(double)m_B
                       InertiaA:(double)I_A
                       InertiaB:(double)I_B
                         r_of_A:(Vector2D*)r_A
                         r_of_B:(Vector2D*)r_B
                       t_vector:(Vector2D*)t
{
    double thirdTermInDenom = ([r_A dot:r_A] - ([r_A dot:t]*[r_A dot:t])) / I_A;
    double fourthTermInDenom = ([r_B dot:r_B] - ([r_B dot:t]*[r_B dot:t])) / I_B;
    
    /*
    double mt_dominator = (1/m_A) + (1/m_B) + (([r_A dot:r_A] - ([r_A dot:t]*[r_A dot:t]))/I_A) + (([r_B dot:r_B] - ([r_B dot:t]*[r_B dot:t]))/I_B);
    
    
    double mt = 1.0/mt_dominator;
    
    double myRes = (1.0 /
                    ((1.0/m_A) + (1.0/m_B) + thirdTermInDenom + fourthTermInDenom)
                    );
    
    NSLog(@"mt== %.9f, my res == %.9f", mt, myRes);
    */
    return (1.0 /
            ((1.0/m_A) + (1.0/m_B) + thirdTermInDenom + fourthTermInDenom)
            );
}



- (void) moveWorldyObjects:(WorldyObject*)worldyObjectA
                          :(WorldyObject*)worldyObjectB
                WithValues:(NSDictionary*)dictContainer {
    
    //TODO
//    NSLog(@"MOVE WORLDYOBJECTS CALCULATION");
    
    if (![worldyObjectA isUnmoveable]) {
        Vector2D *v_A = [dictContainer objectForKey:KEY_velocity_vector_A];
        NSNumber* av_A = [dictContainer objectForKey:KEY_angular_velocity_vector_A];
        
        worldyObjectA.position = [[worldyObjectA position] add:[v_A multiply:DELTA_TIME]];
        worldyObjectA.rotationAngle = (worldyObjectA.rotationAngle) + (DELTA_TIME*[av_A doubleValue]);
        
//        [v_A printWithPrefix:@"vA"];
//        NSLog(@"wA %@",av_A);
    }
    
    if (![worldyObjectB isUnmoveable]) {
        Vector2D *v_B = [dictContainer objectForKey:KEY_velocity_vector_B];
        NSNumber* av_B = [dictContainer objectForKey:KEY_angular_velocity_vector_B];
        
        worldyObjectB.position = [[worldyObjectB position] add:[v_B multiply:DELTA_TIME]];
        worldyObjectB.rotationAngle = (worldyObjectB.rotationAngle) + (DELTA_TIME*[av_B doubleValue]);
        
//         [v_B printWithPrefix:@"vB"];
//        NSLog(@"wA %@",av_B);
    }
    
}


- (void) simulateInteractionsInWorldOccurringInOneDeltaTime {
    
    // 1. Perfrom step 1 on each object in world property.
    // 2. Perform steps 2 to 4 of appendix on all unique pairs stored in world property.
    // 3. Post notification in notification center if isUsingNotificationCenter == YES.
    
    // appendix step 1
    for (int i=0; i<[[_world stuffInWorld] count]; i++) {
        [self updateVelocity:[[_world stuffInWorld]objectAtIndex:i]];
        [self updateAngularVelocity:[[_world stuffInWorld]objectAtIndex:i]];
    }
    
    // These nested for loops perform appendix steps 2,3,4.
    // NOTE THAT THESE NESTED FOR LOOPS ARE SKIPPED IF THERE ARE ZERO OR ONE BODY IN THE WORLD.
    // ACCOUNT FOR THE CASE OF ONE BODY IN THE WORLD.
    for (int i=0; i<[[_world stuffInWorld] count]; i++) {
        for (int j=i+1; j<[[_world stuffInWorld] count]; j++) {
            
            // appendix step 2
            NSDictionary* returnValuesFromCollisionResolution;
            BOOL collided;
            collided = [self collisionResolution:[[_world stuffInWorld]objectAtIndex:i]
                                                :[[_world stuffInWorld]objectAtIndex:j]
                                    ReturnValues:&returnValuesFromCollisionResolution];
            
            
            NSDictionary* returnValuesFromCalculatingImpulses; // for appendix step 3
            
            if (collided) {
                
//                NSLog(@"COLLIDED!");
                
                // appendix step 3 with collision
                returnValuesFromCalculatingImpulses =
                [self impulsesOfCollisionBetween:[[_world stuffInWorld]objectAtIndex:i]
                                             And:[[_world stuffInWorld]objectAtIndex:j]
                WithValuesFromResolvingCollision:returnValuesFromCollisionResolution];
                
                // appendix step 4 with collision
                [self moveWorldyObjects:[[_world stuffInWorld]objectAtIndex:i]
                                       :[[_world stuffInWorld]objectAtIndex:j]
                             WithValues:returnValuesFromCalculatingImpulses];
            }
            else {
                // appendix step 3 without collision
                // omit appendix step 3
//                NSLog(@"NOT COLLIDED!");
                
                // appendix step 4 without collision
                // STILL MUST INPUT dictContainer FOR moveWorldyObjects method to work.
                NSArray *keys_Appendix_4 = [NSArray arrayWithObjects:
                                 KEY_velocity_vector_A,
                                 KEY_velocity_vector_B,
                                 KEY_angular_velocity_vector_A,
                                 KEY_angular_velocity_vector_B,nil];
                NSArray *objects_Appendix_4 = [NSArray arrayWithObjects:
                                    ((WorldyObject*)[[_world stuffInWorld]objectAtIndex:i]).velocity,
                                    ((WorldyObject*)[[_world stuffInWorld]objectAtIndex:j]).velocity,
                                    [NSNumber numberWithDouble:((WorldyObject*)[[_world stuffInWorld]objectAtIndex:i]).angularVelocity],
                                    [NSNumber numberWithDouble:((WorldyObject*)[[_world stuffInWorld]objectAtIndex:j]).angularVelocity], nil];
                NSDictionary* dictContainerForNoCollision = [NSDictionary dictionaryWithObjects:objects_Appendix_4 forKeys:keys_Appendix_4];
                
                [self moveWorldyObjects:[[_world stuffInWorld]objectAtIndex:i]
                                       :[[_world stuffInWorld]objectAtIndex:j]
                             WithValues:dictContainerForNoCollision];
            }
            
            
        } // end of inner for loop
    }// end of outer for loop
    
    
    // ACCOUNT FOR THE CASE OF ONE BODY IN THE WORLD.
    if ([[_world stuffInWorld] count] == 1) {
        WorldyObject* target = [[_world stuffInWorld]objectAtIndex:0];
        target.position = [[target position] add:[(target.velocity) multiply:DELTA_TIME]];
        target.rotationAngle = (target.rotationAngle) + (DELTA_TIME*(target.angularVelocity));
    }
    
    // After updating the world (appendix step 4), one stepping of the physics engine is complete.
    
    // If isUsingNotificationCenter==YES, post notification.
    if (_isUsingNotificationCenter) {
        [[NSNotificationCenter defaultCenter]
         postNotificationName:_postNotificationName
         object:self];
    }
}

- (void) simulateInteractionsWithNoCollisionResolutionInOnedt {
    // appendix step 1
    
    for (int i=0; i<[[_world stuffInWorld] count]; i++) {
        
        //make code easier to read
        WorldyObject* target = [[_world stuffInWorld]objectAtIndex:i];
        
        // STep 1 in appendix
        [self updateVelocity:target];
        [self updateAngularVelocity:target];
        
        //step 4 in appendix
        
        target.position = [[target position] add:[(target.velocity) multiply:DELTA_TIME]];
        target.rotationAngle = (target.rotationAngle) + (DELTA_TIME*(target.angularVelocity));
        
    }
}

- (double) getDeltaTime {
    return DELTA_TIME;
}


- (void) addWorldyObject:(WorldyObject*)worldyObjectToAdd {
    [_world addWorldyObject:worldyObjectToAdd];
}


- (void)accelerometer:(UIAccelerometer *)acel didAccelerate:(UIAcceleration *)aceler
{
	_gravity = [Vector2D vectorWith:aceler.x*100 y:-aceler.y*100];
}


// TODO delete blah1 and blah2 methods
- (NSDictionary*) blah1 {
    // Fill returnDict
    NSArray *keys = [NSArray arrayWithObjects:
                     KEY_c1_vector,
                     KEY_c2_vector,
                     KEY_n_vector,
                     KEY_t_vector,
                     KEY_angular_velocity_vector_A, nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        @"abc",
                        @"ark",
                        @"crucible",
                        @"prae",
                        [NSNumber numberWithDouble:123.456789] ,nil];
    return [NSDictionary dictionaryWithObjects:objects forKeys:keys];
}

- (void) blah2:(NSDictionary*)input {
    NSString* c1 = [input objectForKey:KEY_c1_vector];
    NSString* c2 = [input objectForKey:KEY_c2_vector];
    NSString* n = [input objectForKey:KEY_n_vector];
    NSString* t = [input objectForKey:KEY_t_vector];
    NSNumber* av_A = [input objectForKey:KEY_angular_velocity_vector_A];
    
    NSLog(@"%@ %@ %@ %@ %@",c1,c2,n,t, av_A);
    
    
}


@end
