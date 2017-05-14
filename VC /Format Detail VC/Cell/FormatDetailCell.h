//
//  FormatDetailCell.h
//  CamRec
//
//  Created by Abhi on 12/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FormatDetailCell : UITableViewCell
    
    @property (weak, nonatomic) IBOutlet UILabel *labelFormat;
    @property (weak, nonatomic) IBOutlet UILabel *labelDimension;
    @property (weak, nonatomic) IBOutlet UILabel *labelFPS;
    @property (weak, nonatomic) IBOutlet UILabel *labelHRSI;
    @property (weak, nonatomic) IBOutlet UILabel *labelMaxZoom;
    @property (weak, nonatomic) IBOutlet UILabel *labelISO;
    @property (weak, nonatomic) IBOutlet UILabel *labelNumberIndex;
    

@end
