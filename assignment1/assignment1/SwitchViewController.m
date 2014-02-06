//
//  SwitchViewController.m
//  assignment1
//
//  Created by CONNER KNUTSON on 2/5/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "SwitchViewController.h"


@interface SwitchViewController ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIPickerView *photoPicker;
@property (strong, nonatomic) NSArray *pickerOptions;
@property (weak, nonatomic) IBOutlet UIImageView *backView;


@end

@implementation SwitchViewController
- (IBAction)switchAction:(UISwitch *)sender {
    if(sender.isOn)
        self.imageView.image = [UIImage imageNamed:@"smu pony"];
    else
        self.imageView.image = nil;
}


// returns the number of 'columns' to display.
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

// returns the # of rows in each component..
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent: (NSInteger)component
{
    return 3;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.photoPicker.delegate = self;
    self.pickerOptions  = [[NSArray alloc]         initWithObjects:@"Blue",@"Red",@"None", nil];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row   forComponent:(NSInteger)component
{
    return [self.pickerOptions objectAtIndex:row];
}
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row   inComponent:(NSInteger)component
{
    
    if(row == 0)
        self.backView.image = [UIImage imageNamed:@"bluerect"];
    else if(row == 1)
        self.backView.image = [UIImage imageNamed:@"redrect"];
    else
        self.backView.image = nil;
    
    /*switch(row)
    {
        case 0:
            self.backView.image = [UIImage imageNamed:@"bluerect"];
        case 1:
            self.backView.image = nil;
    }*/
}

@end
