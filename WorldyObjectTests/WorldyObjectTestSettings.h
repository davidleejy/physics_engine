//
//  WorldyObjectTestSettings.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/15/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WorldyObjectTestSettings : NSObject

FOUNDATION_EXPORT CGFloat FLOATING_POINT_COMPARISON_ACCURACY;

// Settings for testing Random Number Generator Function
FOUNDATION_EXPORT int MAX_MAGNITUDE_TO_TEST;
FOUNDATION_EXPORT int MAX_NUMBER_OF_NONZERO_DECIMAL_PLACES_TO_TEST;
//FOUNDATION_EXPORT int TOLERANCE_OF_MAX_NUMBER_OF_NONZERO_DECIMAL_PLACES_TO_TEST;

@end
