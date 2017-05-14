//
//  ViewController.h
//  CamRec
//
//  Created by Abhi on 02/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "UseMethods.h"
#import "FormatDetailVC.h"

@interface HomeVC : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate,SelectedFormat>

    
@end

