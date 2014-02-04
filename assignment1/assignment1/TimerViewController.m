//
//  TimerViewController.m
//  assignment1
//
//  Created by Hunter Houston on 2/3/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "TimerViewController.h"

@interface TimerViewController ()

@end

@implementation TimerViewController

@synthesize timerLabel;
@synthesize minuteStepper;
@synthesize secondStepper;

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender{
    self.timerLabel.text = [NSString stringWithFormat:@"%02d:%02d",(int)minuteStepper.value, (int)secondStepper.value];
    minutes = (int)minuteStepper.value;
    seconds = (int)secondStepper.value;
}


- (IBAction)startTimer:(id)sender {
    [self startTimerMethod];
}

- (IBAction)stopTimer:(id)sender {
    [timer invalidate];
}

- (void)startTimerMethod {
    if (seconds > 0 || minutes > 0)
    {
        timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(ticker:) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
        //NSRunLoopCommonModes
    } else {
        timerLabel.text = @"Set Timer!";
    }
}

- (void)ticker:(NSTimer *)timer {
    seconds--;
    
    if (seconds == 0 && minutes ==0)
    {
        [self transition];
    }
    else if (seconds == 0)
    {
        seconds = 60;
        minutes--;
    }
    
    NSString* currentTime = [NSString stringWithFormat:@"%02d:%02d",minutes,seconds];
    timerLabel.text = currentTime;
}

- (void)transition {
    [self performSegueWithIdentifier:@"secondScreen" sender:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
