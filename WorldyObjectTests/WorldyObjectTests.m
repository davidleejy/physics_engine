//
//  WorldyObjectTests.m
//  WorldyObjectTests
//
//  Created by Lee Jian Yi David on 2/15/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "WorldyObjectTests.h"

#import "WorldyObject.h"
#import "Matrix2D.h"
#import "Vector2D.h"
#import "WorldyObjectTestSettings.h"

@implementation WorldyObjectTests

WorldyObject* wObj1 (double mass, double width, double height, double posX, double posY, double velX, double velY, double angVel, double rotAng) {
    
    return [[WorldyObject alloc] initWithMass:mass
                                     AndWidth:width
                                    AndHeight:height
                                  AndPosition: [Vector2D vectorWith:posX y:posY]
                                  AndVelocity: [Vector2D vectorWith:velX y:velY]
                           AndAngularVelocity:angVel
                             AndRotationAngle:rotAng];
}


WorldyObject* wObj2 (double mass, double width, double height, double posX, double posY) {
    
    return [WorldyObject worldyObjectWithMass:mass AndWidth:width AndHeight:height AndPosition:[Vector2D vectorWith:posX y:posY]];
}


double randNum (int n, int nonZeroDecimalPlaces) {
    // REQUIRES: non-negative n. non-negative nonZeroDecimalPlaces.
    // EFFECTS: Returns a random floating point number in the range -n to n, inclusive of end points.
    //          Floating point number will also have a certain non zero decimal places as dictated
    //          by parameters.
    
    double result;
    
    // generate magnitude
    result = rand() % (n+1);
    int scaleDown = 10; // initialising for the loop below.
    for (int i = 0; i < nonZeroDecimalPlaces; i++, scaleDown*=10) {
        result += (rand()%10) / (double)scaleDown;
    }
    
    // generate negation randomly
    BOOL isNegative = rand()%2;
    if (isNegative) {
        result *= -1;
    }
    
    return result;
}


-(BOOL)approxEq:(double)d1 :(double)d2{
	//STAssertTrue(fabs(d1 - d2) < FLOATING_POINT_COMPARISON_ACCURACY, @"", @"");
    
    return fabs(d1 - d2) < FLOATING_POINT_COMPARISON_ACCURACY;
}

-(void)assertApproxEq:(double)d1 :(double)d2{
	STAssertTrue(fabs(d1 - d2) < FLOATING_POINT_COMPARISON_ACCURACY, @"", @"");
}


- (void)setUp
{
    [super setUp];
    
    zeroVector = [Vector2D vectorWith:0 y:0];
    
    srand(time(NULL));
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void) testRandNum {
    
    for (int i=0; i<100; i++) {
        
        // generate random number using function written
        int nonZeroDP = rand()%(MAX_NUMBER_OF_NONZERO_DECIMAL_PLACES_TO_TEST+1);
        int wholeNumberPart = rand()%(MAX_MAGNITUDE_TO_TEST+1);
        double x = randNum(wholeNumberPart, nonZeroDP);
        
        // take absolute value
        x = fabs(x);
        //NSLog(@"x == %lf",x );
        
        /* WARNING:
         * When I wrote this, only God and I understood what I was doing.
         * Now, only God knows.
        */
        
        //test bounds of random number
        STAssertTrue(((int)x) <= wholeNumberPart, @"", @"");
        
        double temp;
        
        if ( [self approxEq:x-((int)(x)) :1] ) {
            temp = x - ((int)(x+0.5));
        }
        else
            temp = x - ((int)x);
        //NSLog(@"ini temp %.9f",temp );
        // temp should now be 0.abcdef... where a,b,c,d,e,f are possibly digits.
        
        temp = temp * pow(10, nonZeroDP);
        // temp should now be abcdef.0000...
        // but as temp is a double type, it could be xxxxx.99999999 ... instead
        
        //NSLog(@"after pow %.9f",temp );
        
        if ([self approxEq:temp - ((int)temp) :1]) {
            temp = temp - ((int)(temp+0.5));
        }
        else
            temp = temp - ((int)temp);
        
        //NSLog(@"fin %.9f",temp);
        // temp should now be 0.00000...
        [self approxEq:temp :0]; //STAssertTrue
    }
}


- (void)testCtor{
    
    // local variables to be used for testing
    WorldyObject* Object1; // TODO: i wanted to rename this but XCode won't allow me.
    WorldyObject* Object2;
    
    for (int repetitions = 0; repetitions < 50; repetitions++) {
        
        // Testing designated ctor
        double mass = randNum(100, 6);
        double width = randNum(100, 6);
        double height = randNum(100, 6);
        double posX = randNum(100, 6);
        double posY = randNum(100, 6);
        double velX = randNum(100, 6);
        double velY = randNum(100, 6);
        double angVel = randNum(100, 6);
        double rotAng = randNum(100, 6);
        
        Object1 = [[WorldyObject alloc] initWithMass:mass AndWidth:width AndHeight:height AndPosition:[Vector2D vectorWith:posX y:posY] AndVelocity:[Vector2D vectorWith:velX y:velY] AndAngularVelocity:angVel AndRotationAngle:rotAng];
        
        double momentOfInertia = ((powf(height, 2.0) + powf(width, 2.0)) / 12.0) * mass;
        
        [self assertApproxEq:mass :[Object1 mass]];
        [self assertApproxEq:width :[Object1 width]];
        [self assertApproxEq:height :[Object1 height]];
        [self assertApproxEq:momentOfInertia :[Object1 momentOfInertia]];
        [self assertApproxEq:posX :[[Object1 position]x]];
        [self assertApproxEq:posY :[[Object1 position]y]];
        [self assertApproxEq:velX :[[Object1 velocity]x]];
        [self assertApproxEq:velY :[[Object1 velocity]y]];
        [self assertApproxEq:angVel :[Object1 angularVelocity]];
        [self assertApproxEq:rotAng :[Object1 rotationAngle]];
        
        
        // Testing lazy ctor
        Object2 = [WorldyObject worldyObjectWithMass:mass AndWidth:width AndHeight:height AndPosition:[Vector2D vectorWith:posX y:posY]];
        
        [self assertApproxEq:mass :[Object2 mass]];
        [self assertApproxEq:width :[Object2 width]];
        [self assertApproxEq:height :[Object2 height]];
        [self assertApproxEq:momentOfInertia :[Object2 momentOfInertia]];
        [self assertApproxEq:posX :[[Object2 position]x]];
        [self assertApproxEq:posY :[[Object2 position]y]];
        [self assertApproxEq:0 :[[Object2 velocity]x]];
        [self assertApproxEq:0 :[[Object2 velocity]y]];
        [self assertApproxEq:0 :[Object2 angularVelocity]];
        [self assertApproxEq:0 :[Object2 rotationAngle]];
        
    }
    
   
}


@end
