//
//  StepViewController.m
//  assignment3
//
//  Created by Hunter Houston on 3/2/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "StepViewController.h"
#import <CoreMotion/CoreMotion.h>

@interface StepViewController ()
@property (strong,nonatomic) CMStepCounter *cmStepCounter;
@property (strong,nonatomic) NSNumber *dailyStepGoal;

@property (weak, nonatomic) IBOutlet UISlider *stepCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelForSteps;
@property (weak, nonatomic) IBOutlet UILabel *labelForStepsToday;
@property (weak, nonatomic) IBOutlet UILabel *labelForStepsY;
@property (weak, nonatomic) IBOutlet UILabel *dotProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelStairs;
@property (weak, nonatomic) IBOutlet UITextField *dailyGoalTextField;

@property NSInteger totalSteps;
@end

@implementation StepViewController

- (IBAction)tapGesture:(id)sender {
    [_dailyGoalTextField resignFirstResponder];
    //set dailyStepGoal here
    _dailyStepGoal = [NSNumber numberWithInt:[_dailyGoalTextField. text intValue]];
    
}

- (CMMotionManager *)motionManager
{
    CMMotionManager *motionManager = nil;
    
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if ([appDelegate respondsToSelector:@selector(motionManager)]) {
        motionManager = [appDelegate motionManager];
    }
    
    return motionManager;
}

-(CMMotionActivityManager*)activityManager
{
    CMMotionActivityManager *activityManager = nil;
    id appDelegate = [UIApplication sharedApplication].delegate;
    
    if([appDelegate respondsToSelector:@selector(activityManager)]) {
        activityManager = [appDelegate activityManager];
    }

    return activityManager;
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

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    _totalSteps = 0;
    
    CMAcceleration gravity, userAccel;
    
    NSDate *now = [NSDate date];
    NSDate *then = [NSDate dateWithTimeInterval:(-60*60*24*2) sinceDate:now];
    
    NSDate *thenT = [NSDate dateWithTimeInterval:(-60*60*24) sinceDate:now];
    
    [self.cmStepCounter queryStepCountStartingFrom:thenT to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        self.labelForStepsToday.text = [NSString stringWithFormat:@"Steps Today: %ld",(long)numberOfSteps];
        _totalSteps = numberOfSteps;
        
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
                                                    self.labelForSteps.text = [NSString stringWithFormat:@"Steps: %ld",(long)numberOfSteps+_totalSteps];
                                                }
                                            }];

	// Do any additional setup after loading the view.
}
-(void) startMotionUpdates{
    if(self.motionManager){
        NSOperationQueue *myQueue = [[NSOperationQueue alloc] init];
        myQueue.maxConcurrentOperationCount = 1;
        [self.motionManager setDeviceMotionUpdateInterval:1.0/100.0];
        [self.motionManager
         startDeviceMotionUpdatesToQueue:myQueue
         withHandler:^(CMDeviceMotion *motion, NSError *error) {
             
             float dotProduct =
             motion.gravity.x*motion.userAcceleration.x +
             motion.gravity.y*motion.userAcceleration.y +
             motion.gravity.z*motion.userAcceleration.z;
             
             NSLog(@"grav x %f",motion.gravity.x);
             NSLog(@"grav y %f",motion.gravity.y);
             NSLog(@"grav z %f",motion.gravity.z);
             
             
             float denom = sqrt(motion.gravity.x*motion.gravity.x + motion.gravity.y*motion.gravity.y + motion.gravity.z*motion.gravity.z);
             
             float normDotProd = dotProduct / denom;
             NSLog(@"dotProduct: %f",dotProduct);
             
             NSLog(@"Denom: %f",denom);
             NSLog(@"finalDP %f",normDotProd);
             
             
             dotProduct /= motion.gravity.x*motion.gravity.x +
             motion.gravity.y*motion.gravity.y +
             motion.gravity.z*motion.gravity.z;
             
             self.dotProductLabel.text = [NSString stringWithFormat:@"Dot Product: %0.2f", normDotProd];
             
             if (normDotProd >= -2.0 && normDotProd < -1.0) {
                 self.labelStairs.text = [NSString stringWithFormat:@"Stairs: UP"];
                 
             } else if (normDotProd > 0 && normDotProd <= 2.0)
             {
                 self.labelStairs.text = [NSString stringWithFormat:@"Stairs: Down"];
             }
             
         }];
    }
//    if ([CMMotionActivityManager isActivityAvailable] == YES )
//        [self.cmActivityManager stopActivityUpdates];
}

@end
