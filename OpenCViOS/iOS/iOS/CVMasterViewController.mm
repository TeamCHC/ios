//
//  CVMasterViewController.m
//  iOS
//
//  Created by Eric Larson
//  Copyright (c) 2014 Eric Larson. All rights reserved.
//

#import "CVMasterViewController.h"
#import <opencv2/highgui/cap_ios.h>

#define kHueAdjustAmount 80.0
const int kCannyLowThreshold = 300;
const int kFilterKernelSize = 5;

using namespace cv;

@interface CVMasterViewController ()<CvVideoCameraDelegate,UIPickerViewDelegate, UIPickerViewDataSource>
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) CvVideoCamera* videoCamera;
@property (nonatomic) BOOL torchIsOn;
@property (strong,nonatomic) NSArray *cvExampleTypes;
@property (atomic) NSInteger currentRow;
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (atomic) cv::CascadeClassifier classifier;
@property (weak, nonatomic) IBOutlet UILabel *fpsLabel;

@end

@implementation CVMasterViewController

#pragma mark - Lazy Instantiation
-(NSArray*)cvExampleTypes{
    if(!_cvExampleTypes){
        // display these in the picker
        _cvExampleTypes = @[@"Raw Video",
                            @"Color Invert",
                            @"Access Pixels",
                            @"Average Pixels",
                            @"Hue Adjust",
                            @"Threshold",
                            @"Blur",
                            @"Canny",
                            @"Contour Bounds",
                            @"Contours",
                            @"Haar Cascade Default",
                            @"Haar Cascade Tree",
                            @"Haar Cascade Alt",
                            @"Haar Cascade Alt 2",
                            @"Hough Circles",
                            ];
    }
    
    return _cvExampleTypes;
}

-(CvVideoCamera *)videoCamera{
    if(!_videoCamera)
    {
        _videoCamera = [[CvVideoCamera alloc] initWithParentView:self.imageView];
        _videoCamera.delegate = self;
        _videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
        _videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
        _videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationPortrait;
        _videoCamera.defaultFPS = 24;
        _videoCamera.grayscaleMode = NO;
    }
    return _videoCamera;
}

-(BOOL)torchIsOn{
    if(!_torchIsOn)
        _torchIsOn = NO;
    
    return _torchIsOn;
}

#pragma mark - View Controller Life Cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    self.currentRow = 0;
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
}

-(void) viewDidAppear:(BOOL)animated  {
    [super viewDidAppear:animated];
    [self.videoCamera start];
}

-(void)viewWillDisappear:(BOOL)animated{
    
    [self.videoCamera stop];
    [super viewWillDisappear:animated];
}


#pragma mark - Protocol CvVideoCameraDelegate

#ifdef __cplusplus
- (void)processImage:(Mat&)image;
{
    // Do some OpenCV stuff with the image
    Mat image_copy;
    Mat grayFrame, output;
    
    static uint counter = 0;

    
    switch (self.currentRow) {
        case 1:
        {
            //============================================
            // color inverter
            cvtColor(image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
            
            // invert image
            bitwise_not(image_copy, image_copy);
            // copy back for further processing
            cvtColor(image_copy, image, CV_BGR2BGRA); //add back for display
            break;
        }
        case 2:
        {
            //============================================
            //access pixels
            cvtColor(image, image_copy, CV_BGRA2BGR);
            for(int i=0;i<counter;i++){
                for(int j=0;j<counter;j++){
                    uchar *pt = image_copy.ptr(i, j);
                    pt[0] = 255;
                    pt[1] = 0;
                    pt[2] = 255;
                    
                    pt[3] = 255;
                    pt[4] = 0;
                    pt[5] = 0;
                }
            }
            cvtColor(image_copy, image, CV_BGR2BGRA);
            
            counter++;
            counter = counter>200 ? 0 : counter;
            
            //printf("(%d,%d,%d)\n",image.ptr(0, 0)[0],image.ptr(0, 0)[1],image.ptr(0, 0)[2]);
            break;
        }
        case 3:
        {
            //============================================
            // get average pixel intensity
            cvtColor(image, image_copy, CV_BGRA2BGR); // get rid of alpha for processing
            Scalar avgPixelIntensity = cv::mean( image_copy );
            char text[50];
            sprintf(text,"Avg. B: %.1f, G: %.1f,R: %.1f", avgPixelIntensity.val[0],avgPixelIntensity.val[1],avgPixelIntensity.val[2]);
            cv::putText(image, text, cv::Point(10, 20), FONT_HERSHEY_PLAIN, 1, Scalar::all(255), 1,2);
            break;
        }
        case 4:
        {
            //============================================
            // change the hue inside an image
            
            //convert to HSV
            cvtColor(image, image_copy, CV_BGRA2BGR);
            cvtColor(image_copy, image_copy, CV_BGR2HSV);
            
            //grab  just the Hue chanel
            vector<Mat> layers;
            cv::split(image_copy,layers);
            
            // shift the colors
            cv::add(layers[0],kHueAdjustAmount,layers[0]);
            
            // get back image from separated layers
            cv::merge(layers,image_copy);
            
            cvtColor(image_copy, image_copy, CV_HSV2BGR);
            cvtColor(image_copy, image, CV_BGR2BGRA);
            break;
        }
        case 5:
        {
            //============================================
            //threshold the image using the utsu method (optimal histogram point)
            cvtColor(image, grayFrame, COLOR_BGRA2GRAY);
            cv::threshold(grayFrame, grayFrame, 0, 255, CV_THRESH_BINARY | CV_THRESH_OTSU);
            cvtColor(grayFrame, image, CV_GRAY2BGRA); //add back for display
            break;
        }
        case 6:
        {
            //============================================
            //do some blurring (filtering)
            cvtColor(image, image_copy, CV_BGRA2BGR);
            Mat gauss = cv::getGaussianKernel(9, 5);
            cv::filter2D(image_copy, image_copy, -1, gauss);
            cvtColor(image_copy, image, CV_BGR2BGRA);
            break;
        }
        case 7:
        {
            //============================================
            // canny edge detector
            // Convert captured frame to grayscale
            cvtColor(image, grayFrame, COLOR_BGRA2GRAY);
            
            // Perform Canny edge detection
            Canny(grayFrame, output,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // copy back for further processing
            cvtColor(output, image, CV_GRAY2BGRA); //add back for display
            break;
        }
        case 8:
        {
            //============================================
            // contour detector with rectangle bounding
            // Convert captured frame to grayscale
            vector<vector<cv::Point> > contours; // for saving the contours
            vector<cv::Vec4i> hierarchy;
            
            cvtColor(image, grayFrame, CV_BGRA2GRAY);
            
            // Perform Canny edge detection
            Canny(grayFrame, output,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // convert edges into connected components
            findContours( output, contours, hierarchy, CV_RETR_CCOMP, CV_CHAIN_APPROX_SIMPLE, cv::Point(0, 0) );
            
            // draw the contours to the original image
            for( int i = 0; i< contours.size(); i++ )
            {
                cv::Rect boundingRect = cv::boundingRect(contours[i]);
                cv::rectangle(image, boundingRect, Scalar(255,255,255,255));
            }
            break;

        }
        case 9:
        {
            //============================================
            // contour detector with full bounds drawing
            // Convert captured frame to grayscale
            vector<vector<cv::Point> > contours; // for saving the contours
            vector<cv::Vec4i> hierarchy;
            
            cvtColor(image, grayFrame, CV_BGRA2GRAY);
            
            // Perform Canny edge detection
            Canny(grayFrame, output,
                  kCannyLowThreshold,
                  kCannyLowThreshold*7,
                  kFilterKernelSize);
            
            // convert edges into connected components
            findContours( output, contours, hierarchy,
                         CV_RETR_CCOMP,
                         CV_CHAIN_APPROX_SIMPLE,
                         cv::Point(0, 0) );
            
            // draw the contours to the original image
            for( int i = 0; i< contours.size(); i++ )
            {
                Scalar color = Scalar( rand()%255, rand()%255, rand()%255, 255 );
                drawContours( image, contours, i, color, 1, 4, hierarchy, 0, cv::Point() );
                
            }
            break;
        }
        case 10:
        case 11:
        case 12:
        case 13:
        {

            //============================================
            // generic Haar Cascade
            cvtColor(image, grayFrame, CV_BGRA2GRAY);
            vector<cv::Rect> objects;
            
            // run classifier
            self.classifier.detectMultiScale(grayFrame, objects);
            
            // display bounding rectangles around the detected objects
            for( vector<cv::Rect>::const_iterator r = objects.begin(); r != objects.end(); r++)
            {
                cv::rectangle( image, cvPoint( r->x, r->y ), cvPoint( r->x + r->width, r->y + r->height ),Scalar(0,0,255,255));
            }
            //image already in the correct color space
            break;
        }
        case 14:
        {
            /// Convert it to gray
            cvtColor( image, image_copy, CV_BGRA2GRAY );
            
            /// Reduce the noise
            GaussianBlur( image_copy, image_copy, cv::Size(3, 3), 2, 2 );
            
            vector<Vec3f> circles;
            
            /// Apply the Hough Transform to find the circles
            HoughCircles( image_copy, circles,
                         CV_HOUGH_GRADIENT,
                         1, // downsample factor
                         image_copy.rows/10, // distance between centers
                         kCannyLowThreshold/2, // canny upper thresh
                         70, // magnitude thresh for hough param space
                         0, 0 ); // min/max centers
            
            /// Draw the circles detected
            for( size_t i = 0; i < circles.size(); i++ )
            {
                cv::Point center(cvRound(circles[i][0]), cvRound(circles[i][1]));
                int radius = cvRound(circles[i][2]);
                // circle center
                circle( image, center, 3, Scalar(0,255,0,255), -1, 8, 0 );
                // circle outline
                circle( image, center, radius, Scalar(0,0,255,255), 3, 8, 0 );
            }
            break;
        }
        default:
            break;
    }
    
    
}
#endif

#pragma mark - Change Camera Settings
- (IBAction)framesPerSecondChanged:(UIStepper *)sender forEvent:(UIEvent *)event {
    
    self.videoCamera.defaultFPS = sender.value;
    self.fpsLabel.text = [NSString stringWithFormat:@"%d fps",(int)sender.value];
    [self.fpsLabel sizeToFit];
    
    [self.videoCamera stop];
    [self.videoCamera start];
    
}

- (IBAction)switchCamera:(id)sender {
    if(self.videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionBack)
    {
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    }
    else
    {
        self.videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
    }
    
    [self.videoCamera stop];
    [self.videoCamera start];
}

#pragma mark - Flash and Torch Handling
- (IBAction)toggleTorch:(id)sender {
    if(self.videoCamera.defaultAVCaptureDevicePosition == AVCaptureDevicePositionBack){
        self.torchIsOn = !self.torchIsOn;
        [self setTorchOn:self.torchIsOn];
    }
    
}

- (void)setTorchOn: (BOOL) onOff
{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    if ([device hasTorch])
    {
        [device lockForConfiguration:nil];
        [device setTorchMode: onOff ? AVCaptureTorchModeOn : AVCaptureTorchModeOff];
        [device unlockForConfiguration];
    }
}



#pragma mark - Picker datasource and delegates
- (NSInteger)numberOfComponentsInPickerView:
(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView
numberOfRowsInComponent:(NSInteger)component
{
    return self.cvExampleTypes.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView
             titleForRow:(NSInteger)row
            forComponent:(NSInteger)component
{
    return self.cvExampleTypes[row];
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row
      inComponent:(NSInteger)component
{

    if(row>9){
        NSString *fileName;
        switch (row) {
            case 10:
                fileName = @"haarcascade_frontalface_default";
                break;
            case 11:
                fileName = @"haarcascade_frontalface_alt_tree";
                break;
            case 12:
                fileName = @"haarcascade_frontalface_alt";
                break;
            case 13:
                fileName = @"haarcascade_frontalface_alt2";
                break;
            default:
                fileName = @"haarcascade_frontalface_default";
                break;
        }
        // load in custom trained Haar Cascade filter
        // This one is a famous trained face detector from Rainer Lienhart
        // http://www.lienhart.de/Prof._Dr._Rainer_Lienhart/Welcome.html
        NSString *filePath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"xml"];
        
        self.classifier = cv::CascadeClassifier([filePath UTF8String]);
    }
    self.currentRow = row;
}


@end
