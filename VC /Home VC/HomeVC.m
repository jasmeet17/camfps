//
//  ViewController.m
//  CamRec
//
//  Created by Abhi on 02/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import "HomeVC.h"
@interface HomeVC ()

#pragma mark - outlets
@property (weak, nonatomic) IBOutlet UILabel *label_FPS;
    @property (weak, nonatomic) IBOutlet UISlider *sliderFPS;
    @property (weak, nonatomic) IBOutlet UILabel *labelCurrentFPS;
    @property (weak, nonatomic) IBOutlet UILabel *labelMinFPS;
    @property (weak, nonatomic) IBOutlet UILabel *labelMaxFPS;

@property (weak, nonatomic) IBOutlet UILabel *detail_labelFormat;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelDimensions;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelFPS;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelHRSI;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelZoom;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelISO;
@property (weak, nonatomic) IBOutlet UILabel *detail_labelDevice;


@property AVCaptureDevice *device;
@property float minFPS;
@property float maxFPS;
@property float currentFPS;
@property NSMutableDictionary *currentFormat;
    
#define DEVICE @"deviceName"
#define DESCIPTION @"description"
#define FORMAT @"format"
#define DIMENSIONS @"dimensions"
#define MAXZOOM @"maxzoom"
#define HRSI @"highResolutionStillImageDimensions"
#define ISO @"ISO"
#define FPS @"FPS"


@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    self.currentFormat = [[NSMutableDictionary alloc] init];
    
    [self logAvailableInputDeviceNames];
    [self devicesWithFlash];
    [self.navigationController.navigationBar setHidden:YES];
    [self getVideoAccess];
    [self addVideoPreview];
    [self getCurrentActiveFormat:self.device];
    [self updateLabels];
    [self updateCurrentFormatDetails];
    [self updateUISlider];

}

-(void)viewWillAppear:(BOOL)animated{
    //Hide the Navigation Bar
    self.title = @"";
    [[self navigationController] setNavigationBarHidden:YES animated:YES];
}
    
-(void) viewWillDisappear:(BOOL)animated{
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
    
#pragma mark - Navigation
     
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
// Get the new view controller using [segue destinationViewController].
// Pass the selected object to the new view controller.

    if ([[segue identifier] isEqualToString:@"FormatDetail"])
    {
        // Get reference to the destination view controller
        FormatDetailVC *detailVC = [segue destinationViewController];
        
        // Pass any objects to the view controller here, like...
        detailVC.device = self.device;
        detailVC.delegate = self;
    }
    
}

#pragma mark - Methods
    
-(void) logAvailableInputDeviceNames{
    NSLog(@"Log: Available devices == == == == == == ==");
    NSArray *devices = [AVCaptureDevice devices];
    
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Device name: %@", [device localizedName]);
        
        if ([device hasMediaType:AVMediaTypeVideo]) {
            
            if ([device position] == AVCaptureDevicePositionBack) {
                NSLog(@"Device position : back");
            }
            else {
                NSLog(@"Device position : front");
            }
        }
    }

}
    
-(void) devicesWithFlash{
    NSLog(@"Log: Devices with torch == == == == == == ==");
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasFlash]) {
            NSLog(@"Device with torch name: %@", [device localizedName]);
        }
    }
}
    
// Switching between devices
-(void) deviceSwitchCamera:(AVCaptureSession *) session{
    [session beginConfiguration];
    
//    [session removeInput:frontFacingCameraDeviceInput];
//    [session addInput:backFacingCameraDeviceInput];
    
    [session commitConfiguration];
}
    
-(void) updateLabels{
    self.labelMinFPS.text = [NSString stringWithFormat:@"%.02f",self.minFPS];
    self.labelMaxFPS.text = [NSString stringWithFormat:@"%.02f",self.maxFPS];
    self.labelCurrentFPS.text = [NSString stringWithFormat:@"Current FPS:%.02f",self.currentFPS];
}

-(void) updateUISlider{
    [self.sliderFPS setMinimumValue:self.minFPS];
    [self.sliderFPS setMaximumValue:self.maxFPS];
    
    [self.sliderFPS setValue:self.currentFPS];
    
}

-(void) updateCurrentFormatDetails{
    self.detail_labelDevice.text = [self.currentFormat objectForKey:DEVICE];
    self.detail_labelFormat.text = [self.currentFormat objectForKey:FORMAT];
    self.detail_labelDimensions.text = [self.currentFormat objectForKey:DIMENSIONS];
    self.detail_labelZoom.text = [self.currentFormat objectForKey:MAXZOOM];
    self.detail_labelHRSI.text = [self.currentFormat objectForKey:HRSI];
    self.detail_labelISO.text = [self.currentFormat objectForKey:ISO];
    self.detail_labelFPS.text = [self.currentFormat objectForKey:FPS];
}


-(void) changeFPSValue:(float) newValue{
    if ( YES == [self.device lockForConfiguration:NULL] )
    {
        self.device.activeFormat = self.device.activeFormat;
        [self.device setActiveVideoMinFrameDuration:CMTimeMake(1,newValue)];
        [self.device setActiveVideoMaxFrameDuration:CMTimeMake(1,newValue)];
        [self.device unlockForConfiguration];
    }
}

-(void) getCurrentActiveFormat:(AVCaptureDevice *) captureDevice{
    
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(captureDevice.activeFormat.formatDescription);
    self.currentFPS = captureDevice.activeVideoMinFrameDuration.timescale;
    
    for (AVFrameRateRange *range in captureDevice.activeFormat.videoSupportedFrameRateRanges){
        NSLog(@"Range : %f",range.maxFrameRate);
        self.minFPS = range.minFrameRate;
        self.maxFPS = range.maxFrameRate;
    }
    
    [self.currentFormat setObject:[NSString stringWithFormat:@"Device: %@",captureDevice.localizedName] forKey:DEVICE];
    [self.currentFormat setObject:captureDevice.activeFormat.description forKey:DESCIPTION];
    [self.currentFormat setObject:[NSString stringWithFormat:@"Format :%@",captureDevice.activeFormat.mediaType] forKey:FORMAT];
    [self.currentFormat setObject:[NSString stringWithFormat:@"Dimensions: %d X %d",dimensions.width,dimensions.height] forKey:DIMENSIONS];
    [self.currentFormat setObject:[NSString stringWithFormat:@"Max Zoom: %.02f",captureDevice.activeFormat.videoMaxZoomFactor] forKey:MAXZOOM];
    [self.currentFormat setObject:[NSString stringWithFormat:@"HRSI: %d X %d",captureDevice.activeFormat.highResolutionStillImageDimensions.width,captureDevice.activeFormat.highResolutionStillImageDimensions.height] forKey:HRSI];
    [self.currentFormat setObject:[NSString stringWithFormat:@"ISO: %.02f - %.02f",captureDevice.activeFormat.minISO,captureDevice.activeFormat.maxISO] forKey:ISO];
    [self.currentFormat setObject:[NSString stringWithFormat:@"FPS: %.02f - %.02f",self.minFPS,self.maxFPS] forKey:FPS];
    
}
    


-(void) getVideoAccess{
    // Starting and Stopping Recording
    NSString *mediaType = AVMediaTypeVideo;
    
    [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
        if (granted)
        {
            //Granted access to mediaType
            NSLog(@"Access Granted to Mediatype :%@", AVMediaTypeVideo);
        }
        else
        {
            //Not granted access to mediaType
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UseMethods sharedInstance] showMessage:@"Access to Media type not granted." withTitle:@"Message"];
            });
        }
    }];

}
    
#pragma mark - Delegates
#pragma mark - SelectedFormat Delegate
-(void) selectedFormatIndex:(int) formatIndex{
    [self changeFormat:formatIndex];
}

-(void) changeFormat:(int) formatIndex{
    AVCaptureDeviceFormat *selectedFormat = self.device.formats[formatIndex];

    if ( YES == [self.device lockForConfiguration:NULL] )
    {
        self.device.activeFormat = selectedFormat;
        [self.device unlockForConfiguration];
    }
    
    
    [self getCurrentActiveFormat:self.device];
    [self updateCurrentFormatDetails];
    [self updateLabels];
    [self updateUISlider];
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //NSLog(@"On Output %@", captureOutput.description);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //NSLog(@"On Drop %@", captureOutput.description);
}
    
-(void) addVideoPreview{
    // Create and Configure a Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;
    
    // Create and Configure the Device and Device Input
    
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!input) {
        // Handle the error appropriately.
        NSLog(@"Error while capturing input device");
    }
    [session addInput:input];
    
    // Create and Configure the Video Data Output
    AVCaptureVideoDataOutput *output = [[AVCaptureVideoDataOutput alloc] init];
    [session addOutput:output];
    
    output.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // add preview layer
    dispatch_async(dispatch_get_main_queue(), ^{
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
        
        CALayer *viewLayer = [self.view layer];
        
        newCaptureVideoPreviewLayer.frame = self.view.bounds;
        
        [viewLayer addSublayer:newCaptureVideoPreviewLayer];
        
        [self.view.layer insertSublayer:newCaptureVideoPreviewLayer atIndex:0];
        
        [session startRunning];
    });
}
    
#pragma mark - Actions

- (IBAction)actionSliderChange:(UISlider *)sender {
    
    self.currentFPS = sender.value;
    [self updateLabels];
    
    [self changeFPSValue:self.currentFPS];
    
}
    
    
@end
