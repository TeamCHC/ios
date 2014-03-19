//
//  LookingLiveViewController.m
//  LookinLive
//
//  Created by Eric Larson on 2/26/14.
//  Copyright (c) 2014 Eric Larson. All rights reserved.
//

#import "LookingLiveViewController.h"
#import "VideoAnalgesic.h"

@interface LookingLiveViewController ()

@property (strong,nonatomic) VideoAnalgesic *videoManager;
@property (strong,nonatomic) CIVector *center;

@end

@implementation LookingLiveViewController

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
    
    
    // remove the view's background color
    self.view.backgroundColor = nil;
    
    
    radius = 100.0;
    self.center = [CIVector vectorWithX:self.view.bounds.size.height/2.0 - radius/2.0 Y:self.view.bounds.size.width/2.0+radius/2.0];
    
    
//    __weak typeof(self) weakSelf = self;
    __block CIFilter *filter = [CIFilter filterWithName:@"CIPinchDistortion"];
    
    __block NSDictionary *opts = @{CIDetectorAccuracy: CIDetectorAccuracyLow};
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeFace context:self.videoManager.ciContext options:opts];
    
    [filter setValue:@(radius) forKey:@"inputRadius"];
    [self.videoManager setProcessBlock:^(CIImage *cameraImage){
        
        opts = @{CIDetectorImageOrientation:
                     [VideoAnalgesic ciOrientationFromDeviceOrientation:[UIApplication sharedApplication].statusBarOrientation]};
        
        NSArray *faceFeatures = [detector featuresInImage: cameraImage];
        
        for(CIFaceFeature *face in faceFeatures ){
            float xx = face.bounds.origin.x + face.bounds.size.height/2;
            float yy = face.bounds.origin.y + face.bounds.size.width/2;
            
            CIVector *vect = [CIVector vectorWithX:xx Y:yy];
            
            [filter setValue:vect forKey:@"inputCenter"];
            [filter setValue:cameraImage forKey:kCIInputImageKey];
            cameraImage = filter.outputImage;
        }
        
        return cameraImage;
    }];
	
    [self changeColorMatching];
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
