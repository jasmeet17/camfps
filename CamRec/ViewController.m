//
//  ViewController.m
//  CamRec
//
//  Created by Abhi on 02/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self logAvailableInputDeviceNames];
    [self devicesWithTorch];
    
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
    
-(void) devicesWithTorch{
    NSLog(@"Log: Devices with torch == == == == == == ==");
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *device in devices) {
        if ([device hasTorch]) {
            NSLog(@"Device with torch name: %@", [device localizedName]);
        }
    }
}

#pragma mark - Actions

- (IBAction)captureSession:(UIButton *)sender {
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
    // Add inputs and outputs.
    [session startRunning];
    
    if ([session canSetSessionPreset:AVCaptureSessionPresetHigh]) {
        session.sessionPreset = AVCaptureSessionPresetHigh;
    }
    else {
        // Handle the failure.
        NSLog(@"faliure in setting up sesion preset.");
    }

}

@end
