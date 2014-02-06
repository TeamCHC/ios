//
//  SwitchViewController.m
//  assignment1
//
//  Created by CONNER KNUTSON on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "SwitchViewController.h"


@interface SwitchViewController ()<UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *photoPicker;
@property (strong, nonatomic) NSArray *pickerOptions;


@end

@implementation SwitchViewController
- (IBAction)switchAction:(UISwitch *)sender {
    if(sender.isOn)
        self.imageView.image = [UIImage imageNamed:@"smu pony"];
    else
        self.imageView.image = nil;
}

- (IBAction)pickerAction:(UIPickerView *)sender2 {
    
}

#pragma mark -
#pragma mark PickerView DataSource

- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)photoPicker
{
    return 1;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoPicker.delegate = self;
    _pickerOptions = @[@"Pony",@"SMU"];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
