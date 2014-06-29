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

@property (nonatomic, strong) CPTGraphHostingView *hostView;
@property (nonatomic, strong) IBOutlet UIToolbar *toolbar;
@property (nonatomic, strong) IBOutlet UIButton *settingsButton;

-(void)initPlot;
-(void)configureHost;
-(void)setupGraph;
-(void)setupScatterPlots;
//-(void)configureLegend;
-(void)setupAxes;

-(NSDate *) parseStringToDate: (NSString *) dateString;

@end
