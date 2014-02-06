//
//  SwitchViewController.m
//  assignment1
//
//  Created by CONNER KNUTSON on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "SwitchViewController.h"


@interface SwitchViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *photoPicker;

@end

@implementation SwitchViewController
- (IBAction)switchAction:(UISwitch *)sender {
    if(sender.isOn)
        self.imageView.image = [UIImage imageNamed:@"smu pony"];
    else
        self.imageView.image = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
