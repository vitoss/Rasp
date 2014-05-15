//
//  FirstViewController.m
//  RaspX
//
//  Created by vito on 4/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "ConnectionViewController.h"
#import "CommonUIUtility.h"
#import "SessionState.h"

@implementation ConnectionViewController
@synthesize serverNameControl, logControl, connectButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [connectButton setTitle:@"Connecting..." forState:UIControlStateDisabled];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

-(IBAction)toggleConnection:(id)sender {
    
    if([[SessionState sharedInstance] connected]) {
        [self connectionDropped];
    } else {
        [connectButton setEnabled:false];
        
        NSURL *url = [NSURL URLWithString:[serverNameControl text]];
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             [connectButton setEnabled:true];
             if (data.length > 0 && connectionError == nil)
             {
                 NSDictionary *greeting = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];
                 
                 [self connectionSuccesful];
                 
                 //self.greetingId.text = [[greeting objectForKey:@"id"] stringValue];
                 //self.greetingContent.text = [greeting objectForKey:@"content"];
             } else {
                 [self connectionFailed];
             }
         }];
    }
}

-(void) appendMessage:(NSString *)msg {
    logControl.text = [logControl.text stringByAppendingString:[msg stringByAppendingString: @"\n"]];
}
         
-(void) connectionSuccesful {
    [[SessionState sharedInstance] setConnected:YES];
    [[SessionState sharedInstance] setServerName:[serverNameControl text]];
    
    [self appendMessage:@"Connection to server success."];

    [self setButtonTitle:@"Disconnect" andColor:[UIColor colorWithRed:1.0 green:0.0 blue:0.0 alpha:1.0]];
}

-(void) connectionFailed {
    [[SessionState sharedInstance] setConnected:NO];
    [self appendMessage:@"Connection to server failed."];
}

-(void) connectionDropped {
    [[SessionState sharedInstance] setConnected:NO];
    [self setButtonTitle:@"Connect" andColor:[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.0]];
    
    [self appendMessage:@"Disconnected."];
}

-(void) setButtonTitle:(NSString *)title andColor:(UIColor *)color {
    [connectButton setTitle:title forState:UIControlStateNormal];    
    [connectButton setBackgroundImage:[CommonUIUtility imageFromColor:color] 
                      forState:UIControlStateNormal];
    connectButton.layer.cornerRadius = 8.0;
    connectButton.layer.masksToBounds = YES;
    connectButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    connectButton.layer.borderWidth = 1;
}

@end
