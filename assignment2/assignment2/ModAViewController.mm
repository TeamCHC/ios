//
//  ModAViewController.m
//  assignment2
//
//  Created by CONNER KNUTSON on 2/20/14.
//  Copyright (c) 2014 SMU. All rights reserved.
//

#import "ModAViewController.h"
#import "Novocaine.h"
#import "AudioFileReader.h"
#import "RingBuffer.h"
#import "SMUGraphHelper.h"
#import "SMUFFTHelper.h"


#define kBufferLengthA 4096
#define localMaxWindowSize 7


@interface ModAViewController ()
@property (weak, nonatomic) IBOutlet UILabel *firstLoudest;
@property (weak, nonatomic) IBOutlet UILabel *secondLoudest;
@property (weak, nonatomic) IBOutlet UILabel *firstValue;
@property (weak, nonatomic) IBOutlet UILabel *secondValue;



@end

@implementation ModAViewController

int ind1 = 0;
int ind2 = 0;


Novocaine *audioManagerA;
AudioFileReader *fileReaderA;
RingBuffer *ringBufferA;
GraphHelper *graphHelperA;
float *audioDataA;

SMUFFTHelper *fftHelperA;
float *fftMagnitudeBufferA;
float *fftPhaseBufferA;


/*- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}*/

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //_loudestLabel = [[UILabel alloc]] initWithFrame: CGRectMake(20, 70, 100, 50)
    
    audioManagerA = [Novocaine audioManager];
    ringBufferA = new RingBuffer(kBufferLengthA,2);
    
    audioDataA = (float*)calloc(kBufferLengthA,sizeof(float));
    
    //setup the fft
    fftHelperA = new SMUFFTHelper(kBufferLengthA,kBufferLengthA,WindowTypeRect);
    fftMagnitudeBufferA = (float *)calloc(kBufferLengthA/2,sizeof(float));
    fftPhaseBufferA     = (float *)calloc(kBufferLengthA/2,sizeof(float));
    
    
    // start animating the graph
    int framesPerSecond = 30;
    int numDataArraysToGraph = 2;
    graphHelperA = new GraphHelper(self,
                                  framesPerSecond,
                                  numDataArraysToGraph,
                                  PlotStyleSeparated);//drawing starts immediately after call
    
    graphHelperA->SetBounds(-0.5,0.9,-0.9,0.9); // bottom, top, left, right, full screen==(-1,1,-1,1)
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    
    [audioManagerA setInputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
     {
         if(ringBufferA!=nil)
             ringBufferA->AddNewFloatData(data, numFrames);
     }];
    
//    __block float frequency = 261.0; //starting frequency
//    __block float phase = 0.0;
//    __block float samplingRate = audioManagerA.samplingRate;
    
//    [audioManagerA setOutputBlock:^(float *data, UInt32 numFrames, UInt32 numChannels)
//     {
//         
//         double phaseIncrement = 2*M_PI*frequency/samplingRate;
//         double repeatMax = 2*M_PI;
//         for (int i=0; i < numFrames; ++i)
//         {
//             for(int j=0;j<numChannels;j++){
//                 data[i*numChannels+j] = 0.8*sin(phase);
//                 
//             }
//             phase += phaseIncrement;
//             
//             if(phase>repeatMax)
//                 phase -= repeatMax;
//         }
//         
//         
//     }];
    
}

#pragma mark - unloading and dealloc
-(void) viewDidDisappear:(BOOL)animated{
    // stop opengl from running
    graphHelperA->tearDownGL();
}

-(void)dealloc{
    graphHelperA->tearDownGL();
    
    free(audioDataA);
    
    free(fftMagnitudeBufferA);
    free(fftPhaseBufferA);
    
    delete fftHelperA;
    delete ringBufferA;
    delete graphHelperA;
    
    ringBufferA = nil;
    fftHelperA  = nil;
    audioManagerA = nil;
    graphHelperA = nil;
    
    // ARC handles everything else, just clean up what we used c++ for (calloc, malloc, new)
    
}

#pragma mark - OpenGL and Update functions
//  override the GLKView draw function, from OpenGLES
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect {
    graphHelperA->draw(); // draw the graph
}

//  override the GLKViewController update function, from OpenGLES
- (void)update{
    
    // plot the audio
    ringBufferA->FetchFreshData2(audioDataA, kBufferLengthA, 0, 1);
    graphHelperA->setGraphData(0,audioDataA,kBufferLengthA); // set graph channel
    
    //take the FFT
    fftHelperA->forward(0,audioDataA, fftMagnitudeBufferA, fftPhaseBufferA);
    
    //Analyze the FFT
    //get the index value of 500Hz and only look at above that
    //k(Fs/N)=500 => k=500(N/Fs) where N is buffer length and Fs 44100
    int minFreqIndex = 500 * (kBufferLengthA/audioManagerA.samplingRate);
    //create variables for holding the two loudest frequencies and their indices
    float mag1 = 0;
    int ind1 = 0;
    float mag2 = 0;
    int ind2 = 0;
    float magTemp = 0;
    int indTemp = 0;
    //outer loop to go through fft
    for(int n = minFreqIndex; n < kBufferLengthA/2-localMaxWindowSize; n++)
    {
        //reset temp variables to zero
        magTemp = 0;
        indTemp = 0;
        
        //inner loop to go through current window
        for(int m = n; m <= n+localMaxWindowSize; m++)
        {
            //find max in current window
            if(fftMagnitudeBufferA[m] > magTemp)
            {
                magTemp = fftMagnitudeBufferA[m];
                indTemp = m;
            }
        }
        //is max in window the middle value?
        if(indTemp == (n+localMaxWindowSize/2))
        {
            //loudest tone
            if(fftMagnitudeBufferA[indTemp] > fftMagnitudeBufferA[ind1])
            {
                mag2 = mag1;
                ind2 = ind1;
                mag1 = fftMagnitudeBufferA[indTemp];
                ind1 = indTemp;

            }
            //second loudest tone
            else if(fftMagnitudeBufferA[indTemp] > fftMagnitudeBufferA[ind2])
            {
                mag2 = fftMagnitudeBufferA[indTemp];
                ind2 = indTemp;

            }
        }
    }
    
    if(fftMagnitudeBufferA[ind1] > .8 && fftMagnitudeBufferA[ind2] > .8)
    {
        NSLog(@"The loudest frequency is: %.2f Hz",(ind1*(audioManagerA.samplingRate/kBufferLengthA)));
        _firstValue.text = [NSString stringWithFormat:@"%.2f",ind1*(audioManagerA.samplingRate/kBufferLengthA)];
        
        NSLog(@"The second loudest frequency is: %.2f Hz",(ind2*(audioManagerA.samplingRate/kBufferLengthA)));
        _secondValue.text = [NSString stringWithFormat:@"%.2f",ind2*(audioManagerA.samplingRate/kBufferLengthA)];
    }
    
    // plot the FFT
    graphHelperA->setGraphData(1,fftMagnitudeBufferA,kBufferLengthA/2,sqrt(kBufferLengthA)); // set graph channel
    
    graphHelperA->update(); // update the graph
}

#pragma mark - status bar
-(BOOL)prefersStatusBarHidden{
    return YES;
}


/*- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}*/

@end
