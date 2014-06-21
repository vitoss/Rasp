//
//  SettingsViewController.h
//  RaspX
//
//  Created by vito on 5/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController<UITextFieldDelegate>

@property (nonatomic,weak) IBOutlet UITextField *fromDateControl;
@property (nonatomic,weak) IBOutlet UITextField *toDateControl;

-(IBAction)goBack:(id)sender;
-(NSString *) formatDate:(NSDate *)date;

@end
