//
//  SecondViewController.h
//  RaspX
//
//  Created by vito on 4/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TemperatureViewController : UIViewController

@property (nonatomic, assign) IBOutlet UIView *nonConnectedView;
@property (nonatomic, assign) IBOutlet UILabel *currentTemperatureLabel;
@property (nonatomic, assign) IBOutlet UIButton *refreshButton;

-(IBAction)goBack:(id)sender;
-(IBAction)refresh:(id)sender;

@end
