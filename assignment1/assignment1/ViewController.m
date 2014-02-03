//
//  ViewController.m
//  assignment1
//
//  Created by Hunter Houston on 1/27/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *myLabelFromStoryboard;
@end

@implementation ViewController

- (IBAction)changeLabelToHelloWorld:(UIButton *)sender {
    self.myLabelFromStoryboard.text = @"Hello World!";
    [_changeLabel setHidden:YES];
}

- (IBAction)changeBackgroundColorToBlue:(UIButton*)sender {
    self.view.backgroundColor = [UIColor blueColor];
}

- (IBAction)changeBackgroundColorToGreen:(UIButton*)sender {
    self.view.backgroundColor = [UIColor greenColor];
    
}

- (IBAction)changeBackgroundColorToRed:(UIButton*)sender {
    self.view.backgroundColor = [UIColor redColor];
    
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
	UIButton *blueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [blueButton addTarget:self
               action:@selector(changeBackgroundColorToBlue:)
     forControlEvents:UIControlEventTouchDown];
    [blueButton setTitle:@"Blue" forState:UIControlStateNormal];
    blueButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //blueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [blueButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [self.view addSubview:blueButton];
    
    UIButton *greenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [greenButton addTarget:self
                    action:@selector(changeBackgroundColorToGreen:)
          forControlEvents:UIControlEventTouchDown];
    [greenButton setTitle:@"Green" forState:UIControlStateNormal];
    greenButton.frame = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [greenButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:greenButton];
    
    UIButton *redButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [redButton addTarget:self
                    action:@selector(changeBackgroundColorToRed:)
          forControlEvents:UIControlEventTouchDown];
    [redButton setTitle:@"Red" forState:UIControlStateNormal];
    redButton.frame = CGRectMake(80.0, 270.0, 160.0, 40.0);
    [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:redButton];
    
//    [self.view addConstraint:
//    [NSLayoutConstraint contraintsWithVisualFormat:@"|-[greenButton]-[blueButton]-[redButton]-|"
//                                           options:0
//                                           metrics:nil
//                                             views:NSDictionaryOfVariableBindings(greenButton,blueButton,redButton)]];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
