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


/******* KEYS FOR DICTIONARY **********/
NSString *const KEY_c1_vector = @"c1";
NSString *const KEY_c2_vector = @"c2";
NSString *const KEY_n_vector = @"n";
NSString *const KEY_t_vector = @"t";

NSString *const KEY_collision_truth_value = @"collided?";
NSString *const KEY_computed_impluse_truth_value = @"impulsed?";
/***************************************/

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
    double resultX = [[worldyObjectB position]x] - [[worldyObjectA position]x];
    double resultY = [[worldyObjectB position]y] - [[worldyObjectA position]y];
    return [Vector2D vectorWith:resultX y:resultY];
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
    
    Vector2D* result = [absolute_d_subscript_A subtract:h_subscript_A];
    result = [result subtract:crossPdt];
    
    return result;
    
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
    
    Vector2D* result = [absolute_d_subscript_B subtract:h_subscript_B];
    result = [result subtract:crossPdt];
    
    return result;
}



- (BOOL)hasCollidedCheck1:(Vector2D*)f_subscript_A :(Vector2D*)f_subscript_B {
    
    return ([f_subscript_A x] < 0.0) &&
            ([f_subscript_A y] < 0.0) &&
            ([f_subscript_B x] < 0.0) &&
            ([f_subscript_B y] < 0.0);
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
    
    double tempArray [4] = {
        [f_subscript_A x],
        [f_subscript_A y],
        [f_subscript_B x],
        [f_subscript_B y]};
    
    double min = tempArray[0];
    unsigned short int indexOfMin = 0;
    for(int i=1;i<4;i++) {
        NSLog(@"tempArray[%d] == %.9f", i, tempArray[i]); //DEBUG
        
        if (tempArray[i] < min) {
            min = tempArray[i];
            indexOfMin = i;
        }
    }
    // min and indexOfMin should now contain the value and index (respectively) of the smallest
    // component in f_subscript_A and f_subscript_B.
    
    
    // 3. Now depending on which indexOfMin belongs to smallest component, we do the following:
    
    Vector2D *n_subscript_f;
    Vector2D *n_subscript_s;
    Vector2D *n_vector;
    double D_subscript_f;
    double D_subscript_s;
    double D_subscript_neg;
    double D_subscript_pos;
    
    switch (indexOfMin)
    {
        case 0: {// [f_subscript_A x] is smallest
            
            Matrix2D *R_subscript_A = [self rotationMatrixOf:worldyObjectA];
            
            if ( [[self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA To:worldyObjectB] x]
                > 0)
            {
                n_vector = [R_subscript_A col1];
                n_subscript_f = n_vector; // (5)
            }
            else {
                n_vector = [[R_subscript_A col1] negate];
                n_subscript_f = n_vector; // (5)
            }
            
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
                n_subscript_f = n_vector; // (11)
            }
            else {
                n_vector = [[R_subscript_A col2] negate];
                n_subscript_f = n_vector; // (11)
            }
            
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
                n_subscript_f = [n_vector negate]; // (17)
            }
            else {
                n_vector = [[R_subscript_B col1] negate];
                n_subscript_f = [n_vector negate]; // (17)
            }
            
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
                n_subscript_f = [n_vector negate]; // (23)
            }
            else {
                n_vector = [[R_subscript_B col2] negate];
                n_subscript_f = [n_vector negate]; // (23)
            }
            
            Vector2D *h_subscript_B = [self hVectorOf:worldyObjectB];
            
            D_subscript_f = [[worldyObjectB position] dot:n_subscript_f] + [h_subscript_B y]; //(24)
            n_subscript_s = [R_subscript_B col1]; // (25)
            D_subscript_s = [[worldyObjectB position] dot:n_subscript_s]; // (26)
            D_subscript_neg = [h_subscript_B x] - D_subscript_s; // (27)
            D_subscript_pos = [h_subscript_B x] + D_subscript_s; // (28)
            
            break;
        }
        default:
            [NSException raise:@"collisionResolution function, step 3. indexOfMin is invalid." format:@"indexOfMin == %d",indexOfMin];
            break;
    }
    
    
    // 4. Now that we’ve got the reference edge, we need to find the incident edge.
    //    Denote by v1_vector and v2_vector, the position vectors of the end points of the incident edge.
    
    Vector2D *n_subscript_i;
    Vector2D *p_vector;
    Matrix2D *R_matrix;
    Vector2D *h_vector;
    
    switch (indexOfMin) {
        case 0: case 1: {
            n_subscript_i = [[[self transposedRotationMatrixOf:worldyObjectB]
                              multiplyVector:n_subscript_f]
                             negate];
            p_vector = [self directionalVectorInWorldyObjectBCoordSystemFrom:worldyObjectA
                                                                          To:worldyObjectB];
            R_matrix = [self rotationMatrixOf:worldyObjectB];
            h_vector = [self hVectorOf:worldyObjectB];
            
            break;
        }
        case 2: case 3: {
            n_subscript_i = [[[self transposedRotationMatrixOf:worldyObjectA]
                              multiplyVector:n_subscript_f]
                             negate];
            p_vector = [self directionalVectorInWorldyObjectACoordSystemFrom:worldyObjectA
                                                                          To:worldyObjectB];
            R_matrix = [self rotationMatrixOf:worldyObjectA];
            h_vector = [self hVectorOf:worldyObjectA];
            
            break;
        }
        default:
            [NSException raise:@"collisionResolution function, step 3. indexOfMin is invalid." format:@"indexOfMin == %d",indexOfMin];
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
    
    if (dist1<0 && dist2<0) {
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
    
    if (dist1<0 && dist2<0) {
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
    
    Vector2D *t_vector = [n_vector crossZ:1];
    
    // Fill argument returnDict
    NSArray *keys = [NSArray arrayWithObjects:
                     KEY_c1_vector,
                     KEY_c2_vector,
                     KEY_n_vector,
                     KEY_t_vector,nil];
    NSArray *objects = [NSArray arrayWithObjects:
                        c1,
                        c2,
                        n_vector,
                        t_vector, nil];
    *returnDict = [NSDictionary dictionaryWithObjects:objects forKeys:keys];
    
    return YES;
}


- (NSDictionary*) impulsesOfCollisionBetween:(WorldyObject*)worldyObjectA
                                         And:(WorldyObject*)worldyObjectB
            WithValuesFromResolvingCollision:(NSDictionary*)dictFromResolvingCollision {
    
}

- (void) moveWorldyObjects:(WorldyObject*)worldyObjectA
                          :(WorldyObject*)worldyObjectB
WithValuesFromComputingImpulse:(NSDictionary*)dictFromComputingImpulse {
    
}


@end
