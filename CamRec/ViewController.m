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
    
    NSArray *devices = [AVCaptureDevice devices];
    
    for (int i=0; i<devices.count ; i++){
        NSLog(@"name :%@\n\n", devices[i]);
    }

    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

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
