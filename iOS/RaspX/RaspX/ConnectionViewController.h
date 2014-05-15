//
//  FirstViewController.h
//  RaspX
//
//  Created by vito on 4/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//  http://uj-rasp.no-ip.org/
//

#import <UIKit/UIKit.h>

@interface ConnectionViewController : UIViewController

@property (nonatomic, assign) IBOutlet UITextField *serverNameControl;
@property (nonatomic, assign) IBOutlet UITextView *logControl;
@property (nonatomic, assign) IBOutlet UIButton *connectButton;

- (IBAction)toggleConnection:(id)sender;

-(void) appendMessage:(NSString *)msg;
-(void) connectionSuccesful;
-(void) connectionFailed;
-(void) connectionDropped;
-(void) setButtonTitle:(NSString *)title andColor:(UIColor *)color;

@end
