//
//  HistoryViewController.h
//  RaspX
//
//  Created by vito on 5/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CorePlot-CocoaTouch.h"

@interface HistoryViewController : UIViewController<CPTPlotDataSource, UIActionSheetDelegate>

@property (nonatomic, assign) IBOutlet UIView *nonConnectedView;
@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIButton *settingsButton;
@property (nonatomic, assign) IBOutlet UILabel *loadingLabel;

-(void)initPlot;
-(void)configureHost;
-(void)setupGraph;
-(void)setupScatterPlots;
//-(void)configureLegend;
-(void)setupAxes;
-(int)getDateSpan;
-(double)getMaxTemp;
-(IBAction)goBack:(id)sender;

-(NSDate *) parseStringToDate: (NSString *) dateString;
+ (NSInteger)daysBetweenDate:(NSDate*)fromDateTime andDate:(NSDate*)toDateTime;

@end
