//
//  FormatDetailVC.h
//  CamRec
//
//  Created by Abhi on 10/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "FormatDetailCell.h"

@interface FormatDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property AVCaptureDevice *device;

@end
