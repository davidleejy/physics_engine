//
//  ViewController.m
//  physics engine
//
//  Created by Lee Jian Yi David on 2/14/13.
//  Copyright (c) 2013 nus.cs3217. All rights reserved.
//

#import "ViewController.h"
#import "WorldyObject.h"
#import "Vector2D.h"
#import "PhysicsLogic.h"
#include "PhysicsLogic.h"
#import "World.h"

@interface ViewController ()

@property (readwrite) NSTimer* timeSteppingForPhysicsEngine;
@property (readwrite) PhysicsLogic* physicsEngine;

// moveable blocks
@property (readwrite) UIView* blue;
@property (readwrite) UIView* green;
@property (readwrite) UIView* red;
@property (readwrite) UIView* yellow;
@property (readwrite) UIView* purple;
@property (readwrite) UIView* orange;

// unmoveable walls
@property (readwrite) UIView* btmWall;
@property (readwrite) UIView* topWall;
@property (readwrite) UIView* leftWall;
@property (readwrite) UIView* rightWall;

@end

@implementation ViewController

@synthesize timeSteppingForPhysicsEngine = _timeSteppingForPhysicsEngine;
@synthesize physicsEngine = _physicsEngine;

// moveable blocks
@synthesize blue = _blue;
@synthesize green = _green;
@synthesize red = _red;
@synthesize yellow = _yellow;
@synthesize purple = _purple;
@synthesize orange = _orange;


// unmoveable walls
@synthesize btmWall = _btmWall;
@synthesize topWall = _topWall;
@synthesize leftWall = _leftWall;
@synthesize rightWall = _rightWall;

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    // Initialize physicsEngine
    _physicsEngine = [[PhysicsLogic alloc]initWithoutNotificationCenterUsage];
    
    

    // Initialize rectangles. Remember to insert their information into physicsEngine.
    
    double x,y,wd,ht; // will be used to facilitate the initializing of rectangles
    double density = 0.01; // used in calculating mass blocks
    WorldyObject *newWorldyObject;
    
    
    // *** blue rectangle ***
    x = 100; y=700; wd=250; ht=80;
    _blue = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _blue.backgroundColor = [UIColor blueColor];
    _blue.transform = CGAffineTransformMakeRotation(M_PI/3.0);
    [self.view addSubview:_blue];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_blue.center.x y:_blue.center.y]];
    [newWorldyObject setRotationAngle:M_PI/3.0];
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    // *** green rectangle ***
    x = 120; y=0; wd=120; ht=40;
    _green = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _green.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_green];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_green.center.x y:_green.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    // *** red rectangle ***
    x = 250; y=200; wd=180; ht=50;
    _red = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _red.backgroundColor = [UIColor redColor];
    [self.view addSubview:_red];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_red.center.x y:_red.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    // *** yellow rectangle ***
    x = 200; y=167; wd=40; ht=200;
    _yellow = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _yellow.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:_yellow];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_yellow.center.x y:_yellow.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    // *** purple rectangle ***
    x = 200; y=167; wd=40; ht=200;
    _purple = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _purple.backgroundColor = [UIColor purpleColor];
    [self.view addSubview:_purple];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_purple.center.x y:_purple.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    // *** orange rectangle ***
    x = 500; y=400; wd=100; ht=100;
    _orange = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _orange.backgroundColor = [UIColor orangeColor];
    [self.view addSubview:_orange];
    
    newWorldyObject = [WorldyObject worldyObjectWithMass:(wd*ht)*density
                                                   Width:wd Height:ht
                                                Position:[Vector2D vectorWith:_orange.center.x y:_orange.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    
    
    // *** btm wall ***
    x = -10; y=1000; wd=1200; ht=1000;
    _btmWall = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _btmWall.backgroundColor = [UIColor redColor];
    [self.view addSubview:_btmWall];
    
    newWorldyObject = [WorldyObject worldyObjectUnmoveableWithWidth:wd AndHeight:ht AndPosition:[Vector2D vectorWith:_btmWall.center.x y:_btmWall.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    // *** top wall ***
    x = -10; y=-1000; wd=1200; ht=1000;
    _topWall = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _topWall.backgroundColor = [UIColor redColor];
    [self.view addSubview:_topWall];
    
    newWorldyObject = [WorldyObject worldyObjectUnmoveableWithWidth:wd AndHeight:ht AndPosition:[Vector2D vectorWith:_topWall.center.x y:_topWall.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    // *** left wall ***
    x = -1000; y=0; wd=1000; ht=1024;
    _leftWall = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _leftWall.backgroundColor = [UIColor redColor];
    [self.view addSubview:_leftWall];
    
    newWorldyObject = [WorldyObject worldyObjectUnmoveableWithWidth:wd AndHeight:ht AndPosition:[Vector2D vectorWith:_leftWall.center.x y:_leftWall.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    // *** right wall ***
    x = 768; y=0; wd=1000; ht=1024;
    _rightWall = [[UIView alloc] initWithFrame:CGRectMake(x, y, wd, ht)];
    _rightWall.backgroundColor = [UIColor redColor];
    [self.view addSubview:_rightWall];
    
    newWorldyObject = [WorldyObject worldyObjectUnmoveableWithWidth:wd AndHeight:ht AndPosition:[Vector2D vectorWith:_rightWall.center.x y:_rightWall.center.y]];
    
    [_physicsEngine addWorldyObject:newWorldyObject];
    
    
    // Set up timeSteppingForPhysicsEngine
    double dt = [_physicsEngine getDeltaTime];
    _timeSteppingForPhysicsEngine = [NSTimer scheduledTimerWithTimeInterval:dt
                                                                     target:self
                                                                   selector:@selector(updateForOneDeltaTime)
                                                                   userInfo:nil
                                                                    repeats:YES];
    
  
//	
//	//Walls
//	frame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y-1000,768.0, 1000);
//	top = [[UIView alloc] initWithFrame:frame];
//	top.backgroundColor = [UIColor blackColor];
//    top.tag = tagNumberCount;
//    tagNumberCount++;
//	[self.view addSubview:top];
//    [self.engineController addUIView:top WithMass:INFINITY Velocity:[Vector2D vectorWith:0.0 y:0.0] AngularVelocity:0 RotationAngle:(double)0.0 objectType:Wall frictionCoefficient:0.01 restitutionCoefficient:0.1];
//	
//	frame = CGRectMake(self.view.frame.origin.x + self.view.frame.size.width, self.view.frame.origin.y - 1000, 1000, self.view.frame.size.height + 2000);
//	right = [[UIView alloc] initWithFrame:frame];
//	right.backgroundColor = [UIColor blackColor];
//    right.tag = tagNumberCount;
//    tagNumberCount++;
//	[self.view addSubview:right];
//    [self.engineController addUIView:right WithMass:INFINITY Velocity:[Vector2D vectorWith:0.0 y:0.0] AngularVelocity:0 RotationAngle:(double)0.0 objectType:Wall frictionCoefficient:0.01 restitutionCoefficient:0.1];
//	
//	frame = CGRectMake(self.view.frame.origin.x,self.view.frame.origin.y + self.view.frame.size.height, self.view.frame.size.width, 1000);
//	bottom = [[UIView alloc] initWithFrame:frame];
//	bottom.backgroundColor = [UIColor blackColor];
//    bottom.tag = tagNumberCount;
//    tagNumberCount++;
//	[self.view addSubview:bottom];
//    [self.engineController addUIView:bottom WithMass:INFINITY Velocity:[Vector2D vectorWith:0.0 y:0.0] AngularVelocity:0 RotationAngle:(double)0.0 objectType:Wall frictionCoefficient:0.01 restitutionCoefficient:0.1];
//	
//	frame = CGRectMake(self.view.frame.origin.x - 1000, self.view.frame.origin.y - 1000, 1000, self.view.frame.size.height + 2000);
//	left = [[UIView alloc] initWithFrame:frame];
//	left.backgroundColor = [UIColor blackColor];
//    left.tag = tagNumberCount;
//    tagNumberCount++;
//	[self.view addSubview:left];
//    [self.engineController addUIView:left WithMass:INFINITY Velocity:[Vector2D vectorWith:0.0 y:0.0] AngularVelocity:0 RotationAngle:(double)0.0 objectType:Wall frictionCoefficient:0.01 restitutionCoefficient:0.1];
    
}


-(void)updateForOneDeltaTime{
    
    // physics engine goes through the work required in 1 stepping.
    [ _physicsEngine simulateInteractionsInWorldOccurringInOneDeltaTime];
//    [_physicsEngine simulateInteractionsWithNoCollisionResolutionInOnedt];
    
    
    // world in physics engine has to be reflected in UIViews here.
    [self updateUIView:_blue ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:0]];
    [self updateUIView:_green ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:1]];
    [self updateUIView:_red ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:2]];
    [self updateUIView:_yellow ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:3]];
    [self updateUIView:_purple ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:4]];
    [self updateUIView:_orange ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:5]];
    [self updateUIView:_btmWall ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:6]];
    [self updateUIView:_topWall ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:7]];
    [self updateUIView:_leftWall ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:8]];
    [self updateUIView:_rightWall ToReflect:[[[_physicsEngine world]stuffInWorld]objectAtIndex:9]];
    
}

-(void)updateUIView:(UIView*)v ToReflect:(WorldyObject*)w {
    
//    NSLog(@"%@ center: %.9f,%.9f",v,v.center.x,v.center.y);
//    NSLog(@"rot %.9f",[w rotationAngle]);
//    NSLog(@"x %.9f",[[w position] x]);
//    NSLog(@"y %.9f",[[w position] y]);
//    NSLog(@"vel %.9f,%0.9f",[[w velocity] x],[[w velocity] y]);
    
    CGAffineTransform newTransform = CGAffineTransformMakeRotation([w rotationAngle]);
    [v setCenter:CGPointMake((CGFloat)[[w position] x], (CGFloat)([[w position] y]))];
    [v setTransform: newTransform];
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
