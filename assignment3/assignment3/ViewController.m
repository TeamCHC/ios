//
//  ViewController.m
//  assignment3
//
//  Created by Hunter Houston on 2/24/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface ViewController ()
@property (nonatomic,strong) CMMotionManager *mManager;

@end

@implementation ViewController

- (void)viewDidLoad
{
//    
//    CMMotionManager *motionManager = [[CMMotionManager alloc] init];
//    if (!motionManager.isDeviceMotionAvailable) {
//        
//        [motionManager startDeviceMotionUpdates];
//        CMDeviceMotion *motion = motionManager.deviceMotion;
//    }
    
    self.mManager = [[CMMotionManager alloc] init];
    
    if([self.mManager isDeviceMotionAvailable])
    {
        
        [self.mManager setDeviceMotionUpdateInterval:1.0/100.0];
        [self.mManager startDeviceMotionUpdatesToQueue:[NSOperationQueue mainQueue]
                                           withHandler:^(CMDeviceMotion *deviceMotion, NSError *error) {
                                               
                                               //Access to all the data…
                                               NSLog(@"attitude: %@ rotationRate: %d gravity: %f useracceleration: %f %f"
                                                    ,deviceMotion.attitude,
                                               deviceMotion.rotationRate, 
                                               deviceMotion.gravity, 
                                               deviceMotion.userAcceleration, 
                                               deviceMotion.magneticField);
                                               
                                               
                                           }]; 
    }
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
