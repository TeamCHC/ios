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
    
    radius = 100.0;
    self.center = [CIVector vectorWithX:self.view.bounds.size.height/2.0 - radius/2.0 Y:self.view.bounds.size.width/2.0+radius/2.0];
    
    __weak typeof(self) weakSelf = self;
    //NSString *accuracy = self.useHighAccuracy ? CIDetectorAccuracyHigh : CIDetectorAccuracyLow;// 1
    __block CIFilter *filter = [CIFilter filterWithName:@"CIRadialGradient"];
    __block CIFilter *filter2 = [CIFilter filterWithName:@"CIRadialGradient"];

    [filter setValue:@"100f" forKey:@"inputRadius0"];
    [filter setValue:@"300f" forKey:@"inputRadius1"];

    [filter2 setValue:@"10f" forKey:@"inputRadius0"];
    [filter2 setValue:@"150f" forKey:@"inputRadius1"];
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:weakSelf.videoManager.ciContext options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    __block NSDictionary *options = @{CIDetectorSmile: @(YES), CIDetectorEyeBlink: @(YES), CIDetectorImageOrientation :
                                                                   [VideoAnalgesic ciOrientationFromDeviceOrientation:[UIApplication sharedApplication].statusBarOrientation]};

    [self.videoManager setProcessBlock:^(CIImage *cameraImage){
        

        NSArray *features = [detector featuresInImage:cameraImage options:options];
        
        for (CIFaceFeature *face in features)
        {

            //NSLog(@"Bounds: %@", NSStringFromCGRect(face.bounds));
            
            CGRect modifiedFaceBounds = face.bounds;
            float xx = face.bounds.origin.x + face.bounds.size.height/2;
            float yy = face.bounds.origin.y + face.bounds.size.width/2;
            
            
//            float xx2 = face.leftEyePosition.x + face.bounds.size.height/2;
//            float yy2 = face.leftEyePosition.y + face.bounds.size.width/2;
            
            CIVector *vect = [CIVector vectorWithX:xx Y:yy];

            //CIVector *vect2 = [CIVector vectorWithX:xx2 Y:yy2];
            
            //NSLog(@"vect: %@",vect);
            [filter setValue:vect forKey:@"inputCenter"];
            //[filter setValue:vect2 forKey:@"inputCenter"];

            //[filter setValue:cameraImage forKey:kCIInputImageKey];
            cameraImage = filter.outputImage;
            
            NSString *hasSmile = face.hasSmile ? @"Yes" : @"No";
            NSString *hasLeftEye = face.hasLeftEyePosition ? @"Yes" : @"No";
            NSString *hasRightEye = face.hasRightEyePosition ? @"Yes" : @"No";
            NSString *hasLeftEyeBlink = face.leftEyeClosed ? @"Yes" : @"No";
            NSString *hasRightEyeBlink = face.rightEyeClosed ? @"Yes" : @"No";
            NSString *string = [NSString stringWithFormat:@" SMILING: %@\n LEFT EYE: %@\n LEFT EYE BLINKING: %@\n RIGHT EYE: %@\n RIGHT EYE BLINKING: %@",
                   hasSmile, hasLeftEye, hasLeftEyeBlink, hasRightEye, hasRightEyeBlink];
            
            //NSLog(@"string: %@",string);
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
//- (void)drawRect:(CGRect)rect {
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetLineWidth(context, 2.0);
//    CGColorSpaceRef colorspace = CGColorSpaceCreateDeviceRGB();
//    CGFloat components[] = {0.0, 0.0, 1.0, 1.0};
//    CGColorRef color = CGColorCreate(colorspace, components);
//    CGContextSetStrokeColorWithColor(context, color);
//    CGContextMoveToPoint(context, 30, 30);
//    CGContextAddLineToPoint(context, 300, 400);
//    CGContextStrokePath(context);
//    CGColorSpaceRelease(colorspace);
//    CGColorRelease(color);
//}

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
