//
//  ViewController.m
//  CoreImageApp
//
//  Created by Hunter Houston on 3/23/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ViewController.h"
#import "VideoAnalgesic.h"
#import <QuartzCore/QuartzCore.h>
#import <CoreImage/CoreImage.h>
#import <opencv2/highgui/cap_ios.h>


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
    
    self.window = [[UIWindow alloc]initWithFrame:self.window.frame];
    radius = 100.0;
    self.center = [CIVector vectorWithX:self.view.bounds.size.height/2.0 - radius/2.0 Y:self.view.bounds.size.width/2.0+radius/2.0];
    
    __weak typeof(self) weakSelf = self;
    //NSString *accuracy = self.useHighAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow;// 1


    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:weakSelf.videoManager.ciContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    __block NSDictionary *options = @{CIDetectorSmile: @(YES), CIDetectorEyeBlink: @(YES), CIDetectorImageOrientation :
                                                                   [VideoAnalgesic ciOrientationFromDeviceOrientation:[UIApplication sharedApplication].statusBarOrientation]};

    [self.videoManager setProcessBlock:^(CIImage *cameraImage){
        

        NSArray *features = [detector featuresInImage:cameraImage options:options];
        
        //[weakSelf drawOnFace:cameraImage :features];
//        NSString *fileName = @"haarcascade_frontalface_default";
//        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
//        
//        weakSelf.classifier = cv::CascadeClassifier([filePath UTF8String]);
        for (CIFaceFeature *face in features)
        {
            
            float xx = face.bounds.origin.x + face.bounds.size.height/2;
            float yy = face.bounds.origin.y + face.bounds.size.width/2;
            CIVector *vect = [CIVector vectorWithX:xx Y:yy];
            
            CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
            
            [filter setValue:@"10f" forKey:@"inputRadius0"];
            [filter setValue:@"150f" forKey:@"inputRadius1"];
            //NSLog(@"vect: %@",vect);
            [filter setValue:vect forKey:@"inputCenter"];
            cameraImage = filter.outputImage;
            
            NSString *hasSmile = face.hasSmile ? @"Yes" : @"No";
            NSString *hasLeftEye = face.hasLeftEyePosition ? @"Yes" : @"No";
            NSString *hasRightEye = face.hasRightEyePosition ? @"Yes" : @"No";
            NSString *hasLeftEyeBlink = face.leftEyeClosed ? @"Yes" : @"No";
            NSString *hasRightEyeBlink = face.rightEyeClosed ? @"Yes" : @"No";
            NSString *string = [NSString stringWithFormat:@" SMILING: %@\n LEFT EYE: %@\n LEFT EYE BLINKING: %@\n RIGHT EYE: %@\n RIGHT EYE BLINKING: %@",
                                hasSmile, hasLeftEye, hasLeftEyeBlink, hasRightEye, hasRightEyeBlink];
            
            NSLog(@"string: %@",string);
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
