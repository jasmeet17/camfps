//
//  FormatDetailVC.m
//  CamRec
//
//  Created by Abhi on 10/05/17.
//  Copyright © 2017 Jeev. All rights reserved.
//

#import "FormatDetailVC.h"

@interface FormatDetailVC ()
    
    @property NSString *deviceName;
    @property NSMutableArray *formatDetails;
    
#define FORMAT @"format"
#define DIMENSIONS @"dimensions"
#define MAXZOOM @"maxzoom"
#define HRSI @"highResolutionStillImageDimensions"
#define ISO @"ISO"
#define FPS @"FPS"

@end

@implementation FormatDetailVC
@synthesize delegate;


    - (void)viewDidLoad {
        [super viewDidLoad];
        // Do any additional setup after loading the view.
        
        [self initialSetup];
    }

    - (void)didReceiveMemoryWarning {
        [super didReceiveMemoryWarning];
        // Dispose of any resources that can be recreated.
    }
    
    -(void) initialSetup {
        self.formatDetails = [[NSMutableArray alloc] init];
        
        [self getAllFormats:self.device];
        
        //Update the Navigation Bar
        [self updateNavigationBar];
        
        for (NSDictionary *format in self.formatDetails){
            NSLog(@"Format :%@",format[@"format"]);
        }
    }

    #pragma mark - Methods Ease
    
    -(void) updateNavigationBar{
        //Hide the Navigation Bar
        [[self navigationController] setNavigationBarHidden:NO animated:NO];
    
        //Modifying the Navigation Bar Appearence
        self.navigationController.navigationBar.translucent = NO;
        self.title = self.deviceName;
    }

    -(void) getAllFormats:(AVCaptureDevice *) captureDevice{
        
        self.deviceName = captureDevice.localizedName;
        
        for (AVCaptureDeviceFormat *format in captureDevice.formats) {
            NSMutableDictionary *dictFormat = [[NSMutableDictionary alloc] init];
            
            CMVideoDimensions dimensions = CMVideoFormatDescriptionGetDimensions(format.formatDescription);
            AVFrameRateRange *range = [format.videoSupportedFrameRateRanges objectAtIndex:0];
            
            dictFormat[FORMAT] = [NSString stringWithFormat:@"Format: %@",format.mediaType];
            dictFormat[DIMENSIONS] = [NSString stringWithFormat:@"Dimensions: %d X %d",dimensions.width,dimensions.height];
            dictFormat[MAXZOOM] = [NSString stringWithFormat:@"Max Zoom Factor: %.02f",format.videoMaxZoomFactor];
            dictFormat[HRSI] = [NSString stringWithFormat:@"HRSI: %d X %d",format.highResolutionStillImageDimensions.width,format.highResolutionStillImageDimensions.height];
            dictFormat[ISO] = [NSString stringWithFormat:@"ISO: %.02f - %.02f",format.minISO,format.maxISO];
            dictFormat[FPS] = [NSString stringWithFormat:@"FPS: %.02f - %.02f",range.minFrameRate, range.maxFrameRate];
            
            
            [self.formatDetails addObject:dictFormat];
        }
        
    }

    
    
#pragma mark - TableView datasource
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.formatDetails.count;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 164.0;
}
    
-(UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath  {

    FormatDetailCell *cell = (FormatDetailCell *)[tableView dequeueReusableCellWithIdentifier:@"FormatDetailCell"];
    
    cell.labelFormat.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:FORMAT];
    cell.labelDimension.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:DIMENSIONS];
    cell.labelMaxZoom.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:MAXZOOM];
    cell.labelHRSI.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:HRSI];
    cell.labelISO.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:ISO];
    cell.labelFPS.text = [[self.formatDetails objectAtIndex:indexPath.row] valueForKey:FPS];
    
    cell.labelNumberIndex.text = [@(indexPath.row + 1) stringValue];
    
    return cell;
}

#pragma mark - TableView delegates
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self selectedIndex:(int)indexPath.row];
    
}

-(void) selectedIndex:(int) index{
    
    UIAlertController * alert = [UIAlertController
                                 alertControllerWithTitle:[NSString stringWithFormat:@"Selected Format Index :%d",index+1]
                                 message:[NSString stringWithFormat:@"%@ (Range Min-Max)", [[self.formatDetails objectAtIndex:index] valueForKey:FPS]]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    
    
    UIAlertAction* yesButton = [UIAlertAction
                                actionWithTitle:@"Yes"
                                style:UIAlertActionStyleDefault
                                handler:^(UIAlertAction * action) {
                                    [delegate selectedFormatIndex:index];
                                    [self.navigationController popViewControllerAnimated:YES];

                                }];
    
    UIAlertAction* noButton = [UIAlertAction
                               actionWithTitle:@"No"
                               style:UIAlertActionStyleDefault
                               handler:^(UIAlertAction * action) {
                                   
                               }];
    
    [alert addAction:yesButton];
    [alert addAction:noButton];
    
    [self presentViewController:alert animated:YES completion:nil];
}

@end
