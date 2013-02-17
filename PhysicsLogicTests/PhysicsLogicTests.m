//
//  PhysicsLogicTests.m
//  PhysicsLogicTests
//
//  Created by Lee Jian Yi David on 2/15/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PhysicsLogicTests.h"
#import "WorldyObject.h"
#import "Matrix2D.h"
#import "Vector2D.h"

#define FLOATING_POINT_COMPARISON_ACCURACY 0.0000001

@implementation PhysicsLogicTests

-(BOOL)approxEq:(double)d1 :(double)d2{
    
    return fabs(d1 - d2) < FLOATING_POINT_COMPARISON_ACCURACY;
}

-(void)assertApproxEq:(double)d1 :(double)d2{
	STAssertTrue(fabs(d1 - d2) < FLOATING_POINT_COMPARISON_ACCURACY, @"", @"");
}


- (void)setUp
{
    [super setUp];
    
    worldyObjectVanilla = [WorldyObject worldyObjectWithMass:75.63 Width:50.12 Height:12.34 Position:[Vector2D vectorWith:23.45 y:34.56]];
    
    physicsLogic = [[PhysicsLogic alloc]initWithoutNotificationCenterUsage];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void) testRotationMatrixOf {
    
    Matrix2D* expected;
    Matrix2D* result;
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:1 Width:100 Height:200 Position:[Vector2D vectorWith:23.45 y:34.56]];
    
    [o1 setRotationAngle:(M_PI / 3.0)];
    
    expected = [Matrix2D matrixWithValues:0.5 and:(sqrt(3)/2.0) and:-(sqrt(3)/2.0) and:0.5];
    result = [physicsLogic rotationMatrixOf:o1];
    [self assertApproxEq:[[expected col1]x] :[[result col1]x]];
    [self assertApproxEq:[[expected col1]y] :[[result col1]y]];
    [self assertApproxEq:[[expected col2]x] :[[result col2]x]];
    [self assertApproxEq:[[expected col2]y] :[[result col2]y]];
    
}

- (void) testTransposedRotationMatrixOf{
    
    Matrix2D* expected;
    Matrix2D* result;
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:1 Width:100 Height:200 Position:[Vector2D vectorWith:23.45 y:34.56]];
    
    [o1 setRotationAngle:(M_PI / 3.2)];
    
    expected = [Matrix2D matrixWithValues:0.555570233 and:-0.831469612 and:0.831469612 and:0.555570233];
    result = [physicsLogic transposedRotationMatrixOf:o1];
    [self assertApproxEq:[[expected col1]x] :[[result col1]x]];
    [self assertApproxEq:[[expected col1]y] :[[result col1]y]];
    [self assertApproxEq:[[expected col2]x] :[[result col2]x]];
    [self assertApproxEq:[[expected col2]y] :[[result col2]y]];
    
}


-(void)testhVectorOf{
    
    Vector2D* expected;
    Vector2D* result;
    
    double width = 99.234524; double height = 89576.2354;
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:1 Width:width Height:height Position:[Vector2D vectorWith:23.45 y:34.56]];
    
    expected = [Vector2D vectorWith:width/2.0 y:height/2.0];
    
    result = [physicsLogic hVectorOf:o1];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
}


-(void)test_d_vector {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:23.45 y:34.56];
    Vector2D* o2Pos = [Vector2D vectorWith:320.1 y:478.5];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:120 Height:250 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:90 Height:11 Position:o2Pos];
    
    expected = [o2Pos subtract:o1Pos];
    result = [physicsLogic directionalVectorInWorldCoordSystemFrom:o1 To:o2];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
}

-(void)test_d_vector_subscript_A {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:23.45 y:34.56];
    Vector2D* o2Pos = [Vector2D vectorWith:320.1 y:478.5];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:120 Height:250 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:90 Height:11 Position:o2Pos];
    
    // Both o1 and o2 are unrotated.
    
    expected = [o2Pos subtract:o1Pos];
    result = [physicsLogic directionalVectorInWorldyObjectACoordSystemFrom:o1 To:o2];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
    // Rotate o1 only.
    
    [o1 setRotationAngle:M_PI/3.0];
    
    expected = [[physicsLogic transposedRotationMatrixOf:o1]multiplyVector:[physicsLogic directionalVectorInWorldCoordSystemFrom:o1 To:o2]];
    result = [physicsLogic directionalVectorInWorldyObjectACoordSystemFrom:o1 To:o2];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
    // Rotate o2. Leave o1 rotated.
    // d_vector_subscript_A should not have changed.
    [o2 setRotationAngle:M_PI/2.45];
    result = [physicsLogic directionalVectorInWorldyObjectACoordSystemFrom:o1 To:o2];
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
}

-(void)test_d_vector_subscript_B {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:11.45 y:39.56];
    Vector2D* o2Pos = [Vector2D vectorWith:178.96 y:234.51];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:120 Height:250 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:90 Height:11 Position:o2Pos];
    
    // Both o1 and o2 are unrotated.
    
    expected = [o2Pos subtract:o1Pos];
    result = [physicsLogic directionalVectorInWorldyObjectBCoordSystemFrom:o1 To:o2];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
    // Rotate o1 only.
    // d_vector_subscript_B should not have changed.
    [o1 setRotationAngle:M_PI/3.0];
    
    result = [physicsLogic directionalVectorInWorldyObjectBCoordSystemFrom:o1 To:o2];
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    
    // Rotate o2. Leave o1 rotated.
    // d_vector_subscript_B should now change.
    [o2 setRotationAngle:M_PI/2.45];
    
    expected = [[physicsLogic transposedRotationMatrixOf:o2]multiplyVector:[physicsLogic directionalVectorInWorldCoordSystemFrom:o1 To:o2]];
    result = [physicsLogic directionalVectorInWorldyObjectBCoordSystemFrom:o1 To:o2];
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
}

-(void)testTransformationMatrix {
    
}

-(void)test_f_vector_subscript_A_collision {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:1 y:2];
    Vector2D* o2Pos = [Vector2D vectorWith:2 y:1];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:5 Height:10 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:20 Height:3 Position:o2Pos];
    
    result = [physicsLogic fBVectorWith:o1 And:o2];
    
    // HPR
    Vector2D* ha = [Vector2D vectorWith:[o1 width]/2.0 y:[o1 height]/2.0];
	Vector2D* hb = [Vector2D vectorWith:[o2 width]/2.0 y:[o2 height]/2.0];
    
    Vector2D*  d = [[o2 position] subtract:[o1 position]];
    Vector2D*  da = [[[physicsLogic rotationMatrixOf:o1]transpose] multiplyVector:d];
    
    Matrix2D* c = [[[physicsLogic rotationMatrixOf:o1]transpose] multiply:[physicsLogic rotationMatrixOf:o2]];
    
	Vector2D* hab = [[[c transpose] abs] multiplyVector:hb];
	
	Vector2D* fa = [[[da abs] subtract:ha] subtract:hab];
    
    expected = fa;
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    STAssertTrue([result x]<0, @"", @"");
    STAssertTrue([result y]<0, @"", @"");
}


-(void)test_f_vector_subscript_B_collision {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:1 y:2];
    Vector2D* o2Pos = [Vector2D vectorWith:2 y:1];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:5 Height:10 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:20 Height:3 Position:o2Pos];
    
//    [o2 setRotationAngle:M_PI/2.45];
//    [o1 setRotationAngle:M_PI/1.22];
    
    result = [physicsLogic fBVectorWith:o1 And:o2];
    
    
    // HPR
    Vector2D* ha = [Vector2D vectorWith:[o1 width]/2.0 y:[o1 height]/2.0];
	Vector2D* hb = [Vector2D vectorWith:[o2 width]/2.0 y:[o2 height]/2.0];
    
    Vector2D*  d = [[o2 position] subtract:[o1 position]];
    Vector2D*  db = [[[physicsLogic rotationMatrixOf:o2]transpose] multiplyVector:d];
    
    Matrix2D* c = [[[physicsLogic rotationMatrixOf:o1]transpose] multiply:[physicsLogic rotationMatrixOf:o2]];
    
	Vector2D* hba = [[[c transpose] abs] multiplyVector:ha];
	
	Vector2D* fb = [[[db abs] subtract:hb] subtract:hba];
    
    expected = fb;
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    STAssertTrue([result x]<0, @"", @"");
    STAssertTrue([result y]<0, @"", @"");
}

-(void)test_f_vector_subscript_B_no_collision {
    
    Vector2D* expected;
    Vector2D* result;
    
    Vector2D* o1Pos = [Vector2D vectorWith:1 y:2];
    Vector2D* o2Pos = [Vector2D vectorWith:6.1 y:1];
    
    WorldyObject* o1 = [WorldyObject worldyObjectWithMass:12 Width:5 Height:10 Position:o1Pos];
    WorldyObject* o2 = [WorldyObject worldyObjectWithMass:24 Width:20 Height:3 Position:o2Pos];
    
//    [o2 setRotationAngle:M_PI/2.45];
//    [o1 setRotationAngle:M_PI/1.22];
    
    result = [physicsLogic fBVectorWith:o1 And:o2];
    
    
    // HPR
    Vector2D* ha = [Vector2D vectorWith:[o1 width]/2.0 y:[o1 height]/2.0];
	Vector2D* hb = [Vector2D vectorWith:[o2 width]/2.0 y:[o2 height]/2.0];
    
    Vector2D*  d = [[o2 position] subtract:[o1 position]];
    Vector2D*  db = [[[physicsLogic rotationMatrixOf:o2]transpose] multiplyVector:d];

    Matrix2D* c = [[[physicsLogic rotationMatrixOf:o1]transpose] multiply:[physicsLogic rotationMatrixOf:o2]];

	Vector2D* hba = [[[c transpose] abs] multiplyVector:ha];

	Vector2D* fb = [[[db abs] subtract:hb] subtract:hba];
    
    expected = fb;
    
    [self assertApproxEq:[expected x] :[result x]];
    [self assertApproxEq:[expected y] :[result y]];
    NSLog(@"test_f_vector_subscript_B_no_collision fb == (%.9f, %.9f)",[result x],[result y]);
}

-(void)testCollisionResolution {
    
    WorldyObject* o1; WorldyObject* o2;
    Vector2D* fa; Vector2D* fb;
    UIView* rectangleViewO1; // to help figue out centre
    UIView* rectangleViewO2; // to help figue out centre
    NSDictionary* returnDict;
    
    // No collision case ------------------------------
    rectangleViewO1 = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 5, 10)];
    rectangleViewO2 = [[UIView alloc] initWithFrame:CGRectMake(6.1, 1, 20, 3)];
    
    o1 = [WorldyObject worldyObjectWithMass:12
                                      Width:rectangleViewO1.bounds.size.width
                                     Height:rectangleViewO1.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO1.center.x
                                                               y:rectangleViewO1.center.y]];
    
    o2 = [WorldyObject worldyObjectWithMass:24
                                      Width:rectangleViewO2.bounds.size.width
                                     Height:rectangleViewO2.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO2.center.x
                                                               y:rectangleViewO2.center.y]];
        // no rotation
    fa = [physicsLogic fAVectorWith:o1 And:o2];
    fb = [physicsLogic fBVectorWith:o1 And:o1];
    STAssertTrue(![physicsLogic collisionResolution:o1 :o2
                               ReturnValues:&returnDict], @"", @"");
    
    
    
    
    // Got collision case ------------------------------
    rectangleViewO1 = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 5, 10)];
    rectangleViewO2 = [[UIView alloc] initWithFrame:CGRectMake(5.5, 1, 20, 3)];
    
    o1 = [WorldyObject worldyObjectWithMass:12
                                      Width:rectangleViewO1.bounds.size.width
                                     Height:rectangleViewO1.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO1.center.x
                                                               y:rectangleViewO1.center.y]];
    
    o2 = [WorldyObject worldyObjectWithMass:24
                                      Width:rectangleViewO2.bounds.size.width
                                     Height:rectangleViewO2.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO2.center.x
                                                               y:rectangleViewO2.center.y]];
    // no rotation
    fa = [physicsLogic fAVectorWith:o1 And:o2];
    fb = [physicsLogic fBVectorWith:o1 And:o1];
    STAssertTrue([physicsLogic collisionResolution:o1 :o2
                                       ReturnValues:&returnDict], @"", @"");
    
    
    
    // Rectangles "share" an edge case ------------------------------
    rectangleViewO1 = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 5, 10)];
    rectangleViewO2 = [[UIView alloc] initWithFrame:CGRectMake(1.2, 12, 20, 3)];
    
    o1 = [WorldyObject worldyObjectWithMass:12
                                      Width:rectangleViewO1.bounds.size.width
                                     Height:rectangleViewO1.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO1.center.x
                                                               y:rectangleViewO1.center.y]];
    
    o2 = [WorldyObject worldyObjectWithMass:24
                                      Width:rectangleViewO2.bounds.size.width
                                     Height:rectangleViewO2.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO2.center.x
                                                               y:rectangleViewO2.center.y]];
    // no rotation
    fa = [physicsLogic fAVectorWith:o1 And:o2];
    fb = [physicsLogic fBVectorWith:o1 And:o1];
    STAssertTrue(![physicsLogic collisionResolution:o1 :o2
                                      ReturnValues:&returnDict], @"", @"");
    
    // rotated rectangles collide case ------------------------------
    rectangleViewO1 = [[UIView alloc] initWithFrame:CGRectMake(1, 2, 5, 10)];
    rectangleViewO2 = [[UIView alloc] initWithFrame:CGRectMake(1.2, 12, 20, 3)];
    
    o1 = [WorldyObject worldyObjectWithMass:12
                                      Width:rectangleViewO1.bounds.size.width
                                     Height:rectangleViewO1.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO1.center.x
                                                               y:rectangleViewO1.center.y]];
    
    o2 = [WorldyObject worldyObjectWithMass:24
                                      Width:rectangleViewO2.bounds.size.width
                                     Height:rectangleViewO2.bounds.size.height
                                   Position:[Vector2D vectorWith:rectangleViewO2.center.x
                                                               y:rectangleViewO2.center.y]];
    // rotation yes
    [o2 setRotationAngle:M_PI/4];
    
    fa = [physicsLogic fAVectorWith:o1 And:o2];
    fb = [physicsLogic fBVectorWith:o1 And:o1];
    STAssertTrue([physicsLogic collisionResolution:o1 :o2
                                       ReturnValues:&returnDict], @"", @"");
    
}


@end
