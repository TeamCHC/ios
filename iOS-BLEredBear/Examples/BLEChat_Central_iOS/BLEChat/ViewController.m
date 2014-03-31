//
//  ViewController.m
//  BLEChat
//
//  Created by Cheong on 15/8/12.
//  Modified by Eric Larson, 2014
//  Copyright (c) 2012 RedBear Lab., All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    bleShield = [[BLE alloc] init];
    [bleShield controlSetup];
    bleShield.delegate = self;
}

//setup auto rotation in code
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - RSSI timer
NSTimer *rssiTimer;
-(void) readRSSITimer:(NSTimer *)timer
{
    [bleShield readRSSI]; // be sure that the RSSI is up to date
}

#pragma mark - BLEdelegate protocol methods
-(void) bleDidUpdateRSSI:(NSNumber *)rssi
{
    self.labelRSSI.text = rssi.stringValue; // when RSSI read is complete, display it
}

// parse the received data
-(void) bleDidReceiveData:(unsigned char *)data length:(int)length
{
    NSData *d = [NSData dataWithBytes:data length:length];
    NSString *s = [[NSString alloc] initWithData:d encoding:NSUTF8StringEncoding];
    self.label.text = s;
}

// we disconnected, stop running
- (void) bleDidDisconnect
{
    [self.buttonConnect setTitle:@"Connect" forState:UIControlStateNormal];
    
    [rssiTimer invalidate];
}

// now just wait to send or receive
-(void) bleDidConnect
{
    [self.spinner stopAnimating];
    [self.buttonConnect setTitle:@"Disconnect" forState:UIControlStateNormal];
    
    // Schedule to read RSSI every 1 sec.
    rssiTimer = [NSTimer scheduledTimerWithTimeInterval:(float)1.0 target:self selector:@selector(readRSSITimer:) userInfo:nil repeats:YES];
}

#pragma mark - UI operations storyboard
- (IBAction)BLEShieldSend:(id)sender
{
    NSString *s;
    NSData *d;
    
    if (self.textField.text.length > 16)
        s = [self.textField.text substringToIndex:16];
    else
        s = self.textField.text;

    s = [NSString stringWithFormat:@"%@\r\n", s];
    d = [s dataUsingEncoding:NSUTF8StringEncoding];
    
    [bleShield write:d];
}

- (IBAction)BLEShieldScan:(id)sender
{
    // disconnect from any peripherals
    if (bleShield.activePeripheral)
        if(bleShield.activePeripheral.isConnected)
        {
            [[bleShield CM] cancelPeripheralConnection:[bleShield activePeripheral]];
            return;
        }
    
    // set peripheral to nil
    if (bleShield.peripherals)
        bleShield.peripherals = nil;
    
    //start search for peripherals with a timeout of 3 seconds
    // this is an asunchronous call and will return before search is complete
    [bleShield findBLEPeripherals:3];
    
    // after three seconds, try to connect to first peripheral
    [NSTimer scheduledTimerWithTimeInterval:(float)3.0
                                     target:self
                                   selector:@selector(connectionTimer:)
                                   userInfo:nil
                                    repeats:NO];
    
    // give connection feedback to the user
    [self.spinner startAnimating];
}


// Called when scan period is over to connect to the first found peripheral
-(void) connectionTimer:(NSTimer *)timer
{
    if(bleShield.peripherals.count > 0)
    {
        // connect to the first found peripheral
        [bleShield connectPeripheral:[bleShield.peripherals objectAtIndex:0]];
    }
    else
    {
        [self.spinner stopAnimating];
    }
}

@end
