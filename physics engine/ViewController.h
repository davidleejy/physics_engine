//
//  ViewController.h
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PhysicsLogic;

@interface ViewController : UIViewController

@property (readonly) NSTimer* timeSteppingForPhysicsEngine;
@property (readonly) PhysicsLogic* physicsEngine;

@end
