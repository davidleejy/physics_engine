//
//  PhysicsLogicTests.m
//  PhysicsLogicTests
//
//  Created by Lee Jian Yi David on 2/15/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "PhysicsLogicTests.h"



@implementation PhysicsLogicTests

- (void)setUp
{
    [super setUp];
    
    worldyObjectVanilla = [WorldyObject worldyObjectWithMass:75.63 AndWidth:50.12 AndHeight:12.34 AndPosition:[Vector2D vectorWith:23.45 y:34.56]];
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}


- (void)testBlah {
    Vector2D* g1 = [Vector2D vectorWith:23 y:67];
    Vector2D* g2 = g1;
    g1 = [Vector2D vectorWith:1234 y:1234];
    NSLog(@"%f,%f g1",[g1 x],[g1 y]);
    NSLog(@"%f,%f g2",[g2 x],[g2 y]);
}

@end
