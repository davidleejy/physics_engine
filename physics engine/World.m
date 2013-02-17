//
//  World.m
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "World.h"
#import "WorldyObject.h"

@implementation World

@synthesize stuffInWorld = _stuffInWorld;

- (World*) init {
// EFFECTS: ctor
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _stuffInWorld = [[NSMutableArray alloc]init];
    
    return self;
}


- (void) addWorldyObject:(WorldyObject*)worldyObjectToAdd {
// MODIFIES: stuffInWorld property
// EFFECTS: adds worldyObjectToAdd to stuffInWorld property
    
    [_stuffInWorld addObject:worldyObjectToAdd];
    NSLog(@"%@", _stuffInWorld);
}
    
@end
