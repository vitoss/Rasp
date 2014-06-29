//
//  SettingsViewController.m
//  RaspX
//
//  Created by vito on 5/16/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SettingsViewController.h"
#import "SessionState.h";

@implementation SettingsViewController

@synthesize fromDateControl, toDateControl;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIDatePicker *datePicker = [[UIDatePicker alloc] init];
    [datePicker setDate:[NSDate date]];
    [datePicker addTarget:self action:@selector(updateFromDate:) forControlEvents:UIControlEventValueChanged];       
    [self.fromDateControl setInputView:datePicker];
    
    UIDatePicker *datePicker2 = [[UIDatePicker alloc] init];
    [datePicker2 setDate:[NSDate date]];
    [datePicker2 addTarget:self action:@selector(updateToDate:) forControlEvents:UIControlEventValueChanged];       
    [self.toDateControl setInputView:datePicker2];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewWillAppear:(BOOL)animated {
    SessionState *state = [SessionState sharedInstance];
    self.fromDateControl.text = [self formatDate:state.fromDate];
    self.toDateControl.text = [self formatDate:state.toDate];

    UIDatePicker *fromPicker = (UIDatePicker*)self.fromDateControl.inputView;
    fromPicker.date = state.fromDate;
    
    UIDatePicker *toPicker = (UIDatePicker*)self.toDateControl.inputView;
    toPicker.date = state.toDate;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(IBAction)goBack:(id)sender {
    [self dismissModalViewControllerAnimated:YES];
}

-(void)updateFromDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.fromDateControl.inputView;
    self.fromDateControl.text = [self formatDate:picker.date];
}

-(void)updateToDate:(id)sender
{
    UIDatePicker *picker = (UIDatePicker*)self.toDateControl.inputView;
    self.toDateControl.text = [self formatDate:picker.date];
}

-(NSString *) formatDate:(NSDate *)date {
    NSString *defaultDate = [NSString stringWithFormat:@"%@", date];
    
    return [defaultDate substringToIndex:[defaultDate rangeOfString:@"+"].location];
}

@end
