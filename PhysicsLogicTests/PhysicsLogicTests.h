//
//  PhysicsLogicTests.h
//  PhysicsLogicTests
//
//  Created by Lee Jian Yi David on 2/15/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <SenTestingKit/SenTestingKit.h>

#import "PhysicsLogic.h"
#import "WorldyObject.h"
#import "Matrix2D.h"
#import "Vector2D.h"

@interface PhysicsLogicTests : SenTestCase {

    WorldyObject *worldyObjectVanilla;
    WorldyObject *worldyObjectB;
    WorldyObject *worldyObjectC;
    WorldyObject *worldyObjectD;
    PhysicsLogic *physicsLogic;
}

@end
