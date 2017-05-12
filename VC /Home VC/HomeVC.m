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
@property AVCaptureDevice *device;

@end

@implementation HomeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    [self logAvailableInputDeviceNames];
    [self devicesWithFlash];
    [self.navigationController.navigationBar setHidden:YES];
    [self getVideoAccess];

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

-(void) getCurrentActiveFormat:(AVCaptureDevice *) captureDevice{
    NSLog(@"Current Active format for %@",captureDevice.localizedName);
    NSLog(@"captureDevice.formatDescription: %@",captureDevice.activeFormat.description);
    NSLog(@"HRSI: %d X %d",captureDevice.activeFormat.highResolutionStillImageDimensions.width,captureDevice.activeFormat.highResolutionStillImageDimensions.height);
    
    CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(captureDevice.activeFormat.formatDescription);
    NSLog(@"Type used for video dimensions, units are pixels. Dimensions: %d X %d",dimensions.width,dimensions.height);
    
    for (AVFrameRateRange *range in captureDevice.activeFormat.videoSupportedFrameRateRanges){
        NSLog(@"Range : %f",range.maxFrameRate);
    }
}
    
-(void) getAllFormats:(AVCaptureDevice *) captureDevice{
    
    NSLog(@"@_@_@_@__@_@_@_@_@_@_@_@__@_@__@_@_");

    NSLog(@"captureDevice.localized: %@",captureDevice.localizedName);

    for (AVCaptureDeviceFormat *format in captureDevice.formats) {
        //format.videoSupportedFrameRateRanges[0]
        NSLog(@"=====    =====     =====     =====");
        NSLog(@"captureDevice.formatDescription: %@",format.formatDescription);
        
        NSLog(@"FOrmat :%@",format.mediaType);
        
        CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
        NSLog(@"Type used for video dimensions, units are pixels. Dimensions: %d X %d",dimensions.width,dimensions.height);

//        CMVideoDimensions dimensions =
        //NSLog(@"Codec: %@",CMFormatDescriptionGetMediaSubType(format.formatDescription));
        
        NSLog(@"Type used for video dimensions, units are pixels. Dimensions: %d X %d",dimensions.width,dimensions.height);

        
        NSLog(@"MaxZoomFactor: %f",format.videoMaxZoomFactor);
        //NSLog(@"format.minExposureDuration.timescale: %d",format.minExposureDuration.timescale);
        //NSLog(@"format.minExposureDuration.value: %lld",format.minExposureDuration.value);
        NSLog(@"w:%d and h:%d",format.highResolutionStillImageDimensions.width,format.highResolutionStillImageDimensions.height);
        
        NSLog(@"Max Zoom Factor: %f",format.videoMaxZoomFactor);
        NSLog(@"Min max iso :%f-%f",format.minISO,format.maxISO);
        
        for (AVFrameRateRange *range in format.videoSupportedFrameRateRanges){
            NSLog(@"Min-Frame Rate:%f Max-Frame Rate:%f",range.minFrameRate, range.maxFrameRate);
            
            //NSLog(@"range.maxFrameDuration.timescale: %d",range.maxFrameDuration.timescale);
            //NSLog(@"range.maxFrameDuration.value: %lld",range.maxFrameDuration.value);
            
        }
    }
    
    
    NSLog(@"@_@_@_@__@_@_@_@_@_@_@_@__@_@__@_@_");
//    for(int i=0; i<captureDevice.formats.count; i++){
//        NSLog(@"The format at:%d , is:%@",i+1, [captureDevice.formats[i] class]);
//    }
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
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //NSLog(@"On Output %@", captureOutput.description);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    //NSLog(@"On Drop %@", captureOutput.description);
}
    
#pragma mark - Actions
- (IBAction)actionVideo:(UIButton *)sender {
    // Create and Configure a Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;

    // Create and Configure the Device and Device Input
    
    [self getCurrentActiveFormat:self.device];
    [self getAllFormats:self.device];
    
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
//    [device setActiveVideoMinFrameDuration:CMTimeMake(1, 15)];
//    output.minFrameDuration = CMTimeMake(1, 15);
    
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    [output setSampleBufferDelegate:self queue:queue];
    
    // add preview layer
    dispatch_async(dispatch_get_main_queue(), ^{
        AVCaptureVideoPreviewLayer *newCaptureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];

        CALayer *viewLayer = [self.view layer];
        
        newCaptureVideoPreviewLayer.frame = self.view.bounds;
                
        [viewLayer addSublayer:newCaptureVideoPreviewLayer];
        
        [self.view.layer addSublayer:newCaptureVideoPreviewLayer];
        
        [session startRunning];
    });
    
    
}


    
- (IBAction)changeFormat:(UIButton *)sender {
    
    
    for(AVCaptureDeviceFormat *vFormat in [self.device formats] )
    {
        CMFormatDescriptionRef description= vFormat.formatDescription;
        float maxrate=((AVFrameRateRange*)[vFormat.videoSupportedFrameRateRanges objectAtIndex:0]).maxFrameRate;
        
        if(maxrate>59 && CMFormatDescriptionGetMediaSubType(description)==kCVPixelFormatType_420YpCbCr8BiPlanarFullRange)
        {
            if ( YES == [self.device lockForConfiguration:NULL] )
            {
                self.device.activeFormat = vFormat;
                [self.device setActiveVideoMinFrameDuration:CMTimeMake(10,50)];
                [self.device setActiveVideoMaxFrameDuration:CMTimeMake(10,50)];
                [self.device unlockForConfiguration];
                NSLog(@"formats  %@ %@ %@",vFormat.mediaType,vFormat.formatDescription,vFormat.videoSupportedFrameRateRanges);
            }
        }
    }
    
    [self getCurrentActiveFormat:self.device];
}
    
    
    
@end
