//
//  ViewController.m
//  CoreImageApp
//
//  Created by Hunter Houston on 3/23/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"
#import "VideoAnalgesic.h"

@interface ViewController ()

@property (strong,nonatomic) VideoAnalgesic *videoManager;
@property (nonatomic, assign) BOOL useHighAccuracy;
@property (strong,nonatomic) CIVector *center;
@property (readonly, assign) CGPoint leftEyePosition;
@property (readonly, assign) CGPoint rightEyePosition;
@property (readonly, assign) CGPoint mouthPosition;
@property (nonatomic, strong) UIImageView *activeImageView;


@end

@implementation ViewController
/* The value for this key is a bool NSNumber. If true, facial expressions, such as blinking and closed eyes are extracted */
CORE_IMAGE_EXPORT NSString *const CIDetectorEyeBlink __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);


/* The value for this key is a bool NSNumber. If true, facial expressions, such as smile are extracted */
CORE_IMAGE_EXPORT NSString *const CIDetectorSmile __OSX_AVAILABLE_STARTING(__MAC_10_9, __IPHONE_7_0);

float radius;

-(VideoAnalgesic*)videoManager{
    if(!_videoManager){
        _videoManager = [VideoAnalgesic captureManager];
        _videoManager.preset = AVCaptureSessionPresetMedium;
        [_videoManager setCameraPosition:AVCaptureDevicePositionFront];
    }
    return _videoManager;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.view.backgroundColor = nil;
    
    radius = 100.0;
    self.center = [CIVector vectorWithX:self.view.bounds.size.height/2.0 - radius/2.0 Y:self.view.bounds.size.width/2.0+radius/2.0];
    
    //__weak typeof(self) weakSelf = self;
    NSString *accuracy = self.useHighAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow;// 1

    __block NSDictionary *opts = @{CIDetectorSmile: @(YES), CIDetectorEyeBlink: @(YES) };      // 2
//(
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.videoManager.ciContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
//
    //
    [self.videoManager setProcessBlock:^(CIImage *cameraImage){
        
        opts = @{ CIDetectorImageOrientation :
                      [VideoAnalgesic ciOrientationFromDeviceOrientation:[UIApplication sharedApplication].statusBarOrientation]
                  };            NSArray *features = [detector featuresInImage:cameraImage options:opts];
        
        
        //[weakSelf drawImageAnnotatedWithFeatures:features];
        
        for (CIFaceFeature *face in features)
        {
            
            float xx = face.bounds.origin.x + face.bounds.size.height/2;
            float yy = face.bounds.origin.y + face.bounds.size.width/2;
            CIVector *vect = [CIVector vectorWithX:xx Y:yy];
            CGRect bounds = face.bounds;
            NSLog(@"Left eyeblink: %@", face.leftEyeClosed ? @"YES" : @"NO");
            NSLog(@"Right eyeblink: %@", face.rightEyeClosed ? @"YES" : @"NO");
            NSLog(@"Smile %@", face.hasSmile ? @"YES" : @"NO");

            //NSLog(@"Bounds: %@", NSStringFromCGRect(f.bounds));
            
        }
        return cameraImage;
    }];
    //[self detectFacialFeatures];
}
- (IBAction)useHighAccuracy:(id)sender {
    self.useHighAccuracy = [sender isOn];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    if(![self.videoManager isRunning])
        [self.videoManager start];
}

-(void)viewWillDisappear:(BOOL)animated{
    if([self.videoManager isRunning])
        [self.videoManager stop];
    
    [super viewWillDisappear:animated];
}


-(BOOL)prefersStatusBarHidden{
    return YES;
}

- (IBAction)panFromUserWithRecognizer:(UIPanGestureRecognizer *)sender {
    CGPoint point = [sender locationInView:self.videoManager.videoPreviewView];
    self.center = [CIVector vectorWithX:point.x-radius/2 Y:self.videoManager.videoPreviewView.bounds.size.height - point.y +radius/2];
    
}

-(void)changeColorMatching{
    [self.videoManager shouldColorMatch:YES];
}


@end
