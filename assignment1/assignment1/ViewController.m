//
//  HELLOWORLD ViewController.m
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
    
    
	_blueButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_blueButton addTarget:self
                    action:@selector(changeBackgroundColorToBlue:)
          forControlEvents:UIControlEventTouchDown];
    [_blueButton setTitle:@"Blue" forState:UIControlStateNormal];
    //blueButton.frame = CGRectMake(80.0, 210.0, 160.0, 40.0);
    //blueButton.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    [_blueButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [_blueButton sizeToFit];
    [_blueButton setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:_blueButton];
    
    _greenButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [_greenButton addTarget:self
                    action:@selector(changeBackgroundColorToGreen:)
          forControlEvents:UIControlEventTouchDown];
    [_greenButton setTitle:@"Green" forState:UIControlStateNormal];
    //greenButton.frame = CGRectMake(80.0, 240.0, 160.0, 40.0);
    [_greenButton setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
    [self.view addSubview:_greenButton];
    
    UIButton *redButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [redButton addTarget:self
                    action:@selector(changeBackgroundColorToRed:)
          forControlEvents:UIControlEventTouchDown];
    [redButton setTitle:@"Red" forState:UIControlStateNormal];
    //redButton.frame = CGRectMake(80.0, 270.0, 160.0, 40.0);
    [redButton setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [self.view addSubview:redButton];
    
    
    NSLayoutConstraint *constraint =
        [NSLayoutConstraint constraintWithItem:_blueButton
                                     attribute:NSLayoutAttributeLeft
                                     relatedBy:NSLayoutRelationEqual
                                        toItem:_changeLabel
                                     attribute:NSLayoutAttributeLeft
                                    multiplier:1.0f
                                      constant:0.f];
    
    [self.view addConstraint:constraint];
    
    constraint =
    [NSLayoutConstraint constraintWithItem:_blueButton
                                 attribute:NSLayoutAttributeRight
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_changeLabel
                                 attribute:NSLayoutAttributeRight
                                multiplier:1.0f
                                  constant:0.f];
    
    [self.view addConstraint:constraint];
    
    constraint =
    [NSLayoutConstraint constraintWithItem:_blueButton
                                 attribute:NSLayoutAttributeTop
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_changeLabel
                                 attribute:NSLayoutAttributeTop
                                multiplier:1.0f
                                  constant:80.f];
    
    [self.view addConstraint:constraint];
    
    constraint =
    [NSLayoutConstraint constraintWithItem:_blueButton
                                 attribute:NSLayoutAttributeBottom
                                 relatedBy:NSLayoutRelationEqual
                                    toItem:_changeLabel
                                 attribute:NSLayoutAttributeBottom
                                multiplier:1.0f
                                  constant:80.f];
    
    [self.view addConstraint:constraint];
    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:_greenButton
//                                 attribute:NSLayoutAttributeLeft
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self.view
//                                 attribute:NSLayoutAttributeLeft
//                                multiplier:1.0f
//                                  constant:50.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:_greenButton
//                                 attribute:NSLayoutAttributeRight
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self.view
//                                 attribute:NSLayoutAttributeRight
//                                multiplier:1.0f
//                                  constant:50.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:_greenButton
//                                 attribute:NSLayoutAttributeTop
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self.view
//                                 attribute:NSLayoutAttributeTop
//                                multiplier:1.0f
//                                  constant:50.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:_greenButton
//                                 attribute:NSLayoutAttributeBottom
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:self.view
//                                 attribute:NSLayoutAttributeBottom
//                                multiplier:1.0f
//                                  constant:50.f];
//    
//    [self.view addConstraint:constraint];
    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:redButton
//                                 attribute:NSLayoutAttributeLeft
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:greenButton
//                                 attribute:NSLayoutAttributeLeft
//                                multiplier:1.0f
//                                  constant:0.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:redButton
//                                 attribute:NSLayoutAttributeRight
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:greenButton
//                                 attribute:NSLayoutAttributeRight
//                                multiplier:1.0f
//                                  constant:0.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:redButton
//                                 attribute:NSLayoutAttributeTop
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:greenButton
//                                 attribute:NSLayoutAttributeTop
//                                multiplier:1.0f
//                                  constant:80.f];
//    
//    [self.view addConstraint:constraint];
//    
//    constraint =
//    [NSLayoutConstraint constraintWithItem:redButton
//                                 attribute:NSLayoutAttributeBottom
//                                 relatedBy:NSLayoutRelationEqual
//                                    toItem:greenButton
//                                 attribute:NSLayoutAttributeBottom
//                                multiplier:1.0f
//                                  constant:80.f];
//    
//    [self.view addConstraint:constraint];

    
//    NSLayoutConstraint *constraint =
//        [NSLayoutConstraint constraintWithItem:_blueButton
//                                     attribute:NSLayoutAttributeTop
//                                     relatedBy:NSLayoutRelationEqual
//                                        toItem:self.view
//                                     attribute:NSLayoutAttributeTop
//                                    multiplier:1.0f
//                                      constant:30.f];
//    
//    [self.view addConstraint:constraint];
    
    
//    [self.view addConstraints:
//     [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-100-[blueButton]-[greenButton]"
//                                             options:0
//                                             metrics:nil
//                                               views:NSDictionaryOfVariableBindings(blueButton, greenButton)]];
//    
//    for (id obj in @[blueButton,greenButton]){
//        [self.view addConstraints:
//         [NSLayoutConstraint constraintsWithVisualFormat:@"[obj]-|"
//                                                 options:0
//                                                 metrics:nil
//                                                   views:NSDictionaryOfVariableBindings(obj)]];
//    }
    
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
