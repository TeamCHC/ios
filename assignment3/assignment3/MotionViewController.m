//
//  MotionViewController.m
//  MotionDemoSMU
//
//  Created by Eric Larson on 2/19/14.
//  Copyright (c) 2014 Eric Larson. All rights reserved.
//

#import "MotionViewController.h"
#import "APLGraphView.h"
#import <CoreMotion/CoreMotion.h>

@interface MotionViewController ()
@property (weak, nonatomic) IBOutlet UISlider *stepCountSlider;
@property (weak, nonatomic) IBOutlet APLGraphView *graphView;

@property (strong,nonatomic) CMStepCounter *cmStepCounter;
@property (strong,nonatomic) NSNumber *dailyStepGoal;
@property (weak, nonatomic) IBOutlet UILabel *labelForSteps;
@property (weak, nonatomic) IBOutlet UILabel *labelForStepsToday;
@property (weak, nonatomic) IBOutlet UILabel *labelForStepsY;

@property (strong,nonatomic) CMMotionActivityManager *cmActivityManager;
@property (weak, nonatomic) IBOutlet UILabel *labelIsRunning;
@property (weak, nonatomic) IBOutlet UILabel *labelIsWalking;
@property (weak, nonatomic) IBOutlet UILabel *labelIsDriving;
@property (weak, nonatomic) IBOutlet UILabel *labelIsStill;

@property (strong,nonatomic) CMMotionManager *cmDeviceMotionManager;

@end

@implementation MotionViewController

-(CMMotionManager*)cmDeviceMotionManager{
    if(!_cmDeviceMotionManager){
        _cmDeviceMotionManager = [[CMMotionManager alloc] init];
        
        if(![_cmDeviceMotionManager isDeviceMotionAvailable]){
            _cmDeviceMotionManager = nil;
        }
    }
    return _cmDeviceMotionManager;
    
}

-(CMMotionActivityManager*)cmActivityManager{
    if(!_cmActivityManager){
        if([CMMotionActivityManager isActivityAvailable])
            _cmActivityManager = [[CMMotionActivityManager alloc]init];
    }
    return _cmActivityManager;
}

-(CMStepCounter*)cmStepCounter{
    if(!_cmStepCounter){
        if([CMStepCounter isStepCountingAvailable]){
            _cmStepCounter = [[CMStepCounter alloc ] init];
        }
    }
    return _cmStepCounter;
}


-(NSNumber*)dailyStepGoal{
    if(!_dailyStepGoal){
        _dailyStepGoal = @(100);
    }
    return _dailyStepGoal;
}



- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    NSDate *now = [NSDate date];
    NSDate *then = [NSDate dateWithTimeInterval:(-60*60*24*2) sinceDate:now];
    
    NSDate *thenT = [NSDate dateWithTimeInterval:(-60*60*24) sinceDate:now];
    
    [self.cmStepCounter queryStepCountStartingFrom:thenT to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        self.labelForStepsToday.text = [NSString stringWithFormat:@"Steps Today: %ld",(long)numberOfSteps];
        
    }];
    
    [self.cmStepCounter queryStepCountStartingFrom:then to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        self.labelForStepsY.text = [NSString stringWithFormat:@"Steps Last 2 Days: %ld",(long)numberOfSteps];
        
    }];
    
    self.stepCountSlider.maximumValue = [self.dailyStepGoal floatValue];
    
    
    [self.cmStepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                               updateOn:1
        withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
            if(!error){
                self.stepCountSlider.value = numberOfSteps;
                self.labelForSteps.text = [NSString stringWithFormat:@"Steps: %ld",(long)numberOfSteps];
            }
        }];
    
    [self.cmActivityManager startActivityUpdatesToQueue:[NSOperationQueue mainQueue]
            withHandler:^(CMMotionActivity *activity) {
                self.labelIsRunning.text = [NSString stringWithFormat:@"Running: %d",activity.running];
                self.labelIsWalking.text = [NSString stringWithFormat:@"Walking: %d", activity.walking];
                self.labelIsDriving.text = [NSString stringWithFormat:@"Driving: %d", activity.automotive];
                self.labelIsStill.text = [NSString stringWithFormat:@"Is Still : %d",activity.stationary];
            }];
    [self startMotionUpdates];
}

-(void) startMotionUpdates{
    if(self.cmDeviceMotionManager){
        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
        myQueue.maxConcurrentOperationCount = 1;
        [self.cmDeviceMotionManager setDeviceMotionUpdateInterval:1.0/100.0];
        [self.cmDeviceMotionManager
         startDeviceMotionUpdatesToQueue:myQueue
            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                
                float dotProduct =
                motion.gravity.x*motion.userAcceleration.x +
                motion.gravity.y*motion.userAcceleration.y +
                motion.gravity.z*motion.userAcceleration.z;
                
                dotProduct /= motion.gravity.x*motion.gravity.x +
                motion.gravity.y*motion.gravity.y +
                motion.gravity.z*motion.gravity.z;
                
                if(abs(dotProduct) > 0.8){
                    dispatch_async(dispatch_get_main_queue(),^{
                        [self.graphView addX:motion.userAcceleration.x
                                           y:motion.userAcceleration.y
                                           z:motion.userAcceleration.z];
                    });
                }
            }];
    }
}


















@end
