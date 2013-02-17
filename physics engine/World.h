//
//  World.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <Foundation/Foundation.h>
@class WorldyObject;

@interface World : NSObject

@property (readwrite) NSMutableArray *stuffInWorld;

- (World*) init;
// EFFECTS: ctor

- (void) addWorldyObject:(WorldyObject*)worldyObjectToAdd;
// MODIFIES: stuffInWorld property
// EFFECTS: adds worldyObjectToAdd to stuffInWorld property

@end
