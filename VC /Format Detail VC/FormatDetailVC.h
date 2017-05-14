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

@protocol SelectedFormat <NSObject>
/**
 * To send value back to the Calling VC
 * @param formatIndex is the Format selected
 */
-(void) selectedFormatIndex:(int) formatIndex;

@end

@interface FormatDetailVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

@property AVCaptureDevice *device;

//For delegation
@property(nonatomic,assign)id delegate;


@end
