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
@property (weak, nonatomic) IBOutlet UILabel *goalReachedLabel;

@property (weak, nonatomic) IBOutlet UISlider *stepCountSlider;
@property (weak, nonatomic) IBOutlet UILabel *labelForSteps;
//@property (weak, nonatomic) IBOutlet UILabel *labelForStepsToday;
@property (weak, nonatomic) IBOutlet UILabel *labelForStepsY;
@property (weak, nonatomic) IBOutlet UILabel *dotProductLabel;
@property (weak, nonatomic) IBOutlet UILabel *labelStairs;
@property (weak, nonatomic) IBOutlet UITextField *dailyGoalTextField;
@property (weak, nonatomic) IBOutlet UIButton *resetSliderButton;
@property NSInteger totalSteps;
@property NSMutableArray *dotProductArray;
@end

@implementation StepViewController
- (IBAction)resetSliderAction:(id)sender {
    self.stepCountSlider.value = 0;
    self.goalReachedLabel.text = [NSString stringWithString:@("Keep Walking!")];
    self.resetSliderButton.hidden = YES;

}

- (IBAction)tapGesture:(id)sender {
    [_dailyGoalTextField resignFirstResponder];
    //set dailyStepGoal here
    _dailyStepGoal = [NSNumber numberWithInt:[_dailyGoalTextField. text intValue]];
    _stepCountSlider.maximumValue = [ _dailyStepGoal floatValue];
    self.stepCountSlider.value = _totalSteps;
    
    //NSLog(@"Stepcountslider: %f",self.stepCountSlider.value);
    //NSLog(@"total steps: %ld",(long)_totalSteps);

    self.stepCountSlider.value = _totalSteps;
    
    if (self.stepCountSlider.value >= [_dailyStepGoal floatValue]) {
        //NSLog(@"GOAL REACHED");
        self.goalReachedLabel.text = [NSString stringWithString:@("Goal reached!")];
        //self.resetSliderButton.hidden = NO;
    } else {
        self.goalReachedLabel.text = [NSString stringWithString:@("Keep Walking!")];
        self.resetSliderButton.hidden = YES;

    }

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
        _dailyStepGoal = @(5000);
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
    self.resetSliderButton.hidden = YES;
 
    //_totalSteps = 0;
    
    
    NSDate *date = [NSDate date];
    NSDateComponents *components = [[NSCalendar currentCalendar]components:NSIntegerMax fromDate:date];
    [components setHour:0];
    [components setMinute:0];
    [components setSecond:0];
    NSDate *midnight = [[NSCalendar currentCalendar] dateFromComponents:components];
    NSDateComponents *diff = [[NSCalendar currentCalendar] components:NSHourCalendarUnit fromDate:midnight toDate:date options:0];
    
    NSInteger numberOfHoursPastMidnight = [diff hour];
    
    NSDate *now = [NSDate date];
    NSDate *yesterday = [NSDate dateWithTimeInterval:(-(numberOfHoursPastMidnight+24*60*60)) sinceDate:now];
    
    NSDate *sinceMidnight = [NSDate dateWithTimeInterval:(-numberOfHoursPastMidnight*60*60) sinceDate:now];
    self.stepCountSlider.maximumValue = [self.dailyStepGoal floatValue];

    [self.cmStepCounter queryStepCountStartingFrom:sinceMidnight to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        //self.labelForStepsToday.text = [NSString stringWithFormat:@"Steps Today: %ld",(long)numberOfSteps];
        _totalSteps = numberOfSteps;
        self.labelForSteps.text = [NSString stringWithFormat:@"Steps Today Live: %ld",_totalSteps];
        
        self.stepCountSlider.value = _totalSteps;
        if (self.stepCountSlider.value >= self.stepCountSlider.maximumValue) {
            //NSLog(@"GOAL REACHED");
            self.goalReachedLabel.text = [NSString stringWithString:@("Goal reached!")];
            //self.resetSliderButton.hidden = NO;

        } else {
            self.goalReachedLabel.text = [NSString stringWithString:@("Keep Walking!")];
            self.resetSliderButton.hidden = YES;
        }
    }];
    
    [self.cmStepCounter queryStepCountStartingFrom:yesterday to:now toQueue:[NSOperationQueue mainQueue] withHandler:^(NSInteger numberOfSteps, NSError *error) {
        self.labelForStepsY.text = [NSString stringWithFormat:@"Steps Since Yesterday: %ld",(long)numberOfSteps];
    }];
    
    
    [self.cmStepCounter startStepCountingUpdatesToQueue:[NSOperationQueue mainQueue]
                                               updateOn:1
                                            withHandler:^(NSInteger numberOfSteps, NSDate *timestamp, NSError *error) {
                                                if(!error){
                                                    self.stepCountSlider.value = numberOfSteps;
                                                    if (self.stepCountSlider.value >= self.stepCountSlider.maximumValue) {
                                                        //NSLog(@"GOAL REACHED");
                                                        self.goalReachedLabel.text = [NSString stringWithString:@("Goal reached!")];
                                                        //self.resetSliderButton.hidden = NO;


                                                    } else {
                                                        self.goalReachedLabel.text = [NSString stringWithString:@("Keep Walking!")];
                                                        self.resetSliderButton.hidden = YES;

                                                    }
                                                    
                                                    self.labelForSteps.text = [NSString stringWithFormat:@"Steps Today Live: %ld",(long)numberOfSteps+_totalSteps];
                                                }
                                            }];
    [self startMotionUpdates];
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
             
             //NSLog(@"grav x %f",motion.gravity.x);
             //NSLog(@"grav y %f",motion.gravity.y);
             //NSLog(@"grav z %f",motion.gravity.z);
             
             
             float denom = sqrt(motion.gravity.x*motion.gravity.x + motion.gravity.y*motion.gravity.y + motion.gravity.z*motion.gravity.z);
             
             float normDotProd = dotProduct / denom;
             NSLog(@"dotProduct: %f",dotProduct);
             
             //NSLog(@"Denom: %f",denom);
             //NSLog(@"finalDP %f",normDotProd);
             
             
             dotProduct /= motion.gravity.x*motion.gravity.x +
             motion.gravity.y*motion.gravity.y +
             motion.gravity.z*motion.gravity.z;
             
             self.dotProductLabel.text = [NSString stringWithFormat:@"Dot Product: %0.5f", normDotProd];
             
             for (int i = 0; i < 100; i++)
             {
                 self.dotProductArray[i] = normDotProd;
             }
             //if (normDotProd < -.3 || normDotProd > .3) {
             if (abs(normDotProd) < .001 || abs(normDotProd) > .3) {
                 self.labelStairs.text = [NSString stringWithFormat:@"YES, STAIRS!"];
             }
             
         }];
    }
//    if ([CMMotionActivityManager isActivityAvailable] == YES )
//        [self.cmActivityManager stopActivityUpdates];
}

@end
