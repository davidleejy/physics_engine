//
//  EnvironmentSettings.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EnvironmentSettings : NSObject


FOUNDATION_EXPORT CGFloat ACCELERATION_OF_GRAVITY;

// Delta Time (also known as "dt")
// Infinitesmally small period of time.
FOUNDATION_EXPORT CGFloat DELTA_TIME;

// How many iterations impulse calculation takes.
FOUNDATION_EXPORT int ITERATIONS_IN_IMPULSE_CALCULATION;

@end
