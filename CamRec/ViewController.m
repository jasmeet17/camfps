//
//  ViewController.m
//  CamRec
//
//  Created by Abhi on 02/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

#pragma mark - outlets

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self logAvailableInputDeviceNames];
    [self devicesWithFlash];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

#pragma mark - Delegates
#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    
    NSLog(@"On Output %@", captureOutput.description);
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didDropSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection{
    NSLog(@"On Drop %@", captureOutput.description);
}
    
#pragma mark - Actions
- (IBAction)actionVideo:(UIButton *)sender {
    // Create and Configure a Capture Session
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    session.sessionPreset = AVCaptureSessionPresetMedium;

    // Create and Configure the Device and Device Input
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSError *error = nil;
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
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

    
    CALayer *viewLayer = self.view.layer;
    
    AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    [viewLayer addSublayer:captureVideoPreviewLayer];
    
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

    
@end
