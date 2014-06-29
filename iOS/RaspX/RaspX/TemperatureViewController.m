//
//  SecondViewController.m
//  RaspX
//
//  Created by vito on 4/26/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TemperatureViewController.h"
#import "SessionState.h"
#import "TemperatureFetcher.h"

@implementation TemperatureViewController {
    TemperatureFetcher *fetcher;
}

@synthesize nonConnectedView, currentTemperatureLabel, currentTemperatureDate, refreshButton;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
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
    
    SessionState *state = [SessionState sharedInstance];
    
    //toggle view depending on connectivity state
    if([state connected]) {
        [nonConnectedView setHidden:YES];
        
        //make sure fetcher is good
        if(fetcher == nil || ![[fetcher serverName] isEqualToString:[SessionState sharedInstance]]) {
            fetcher = [[TemperatureFetcher alloc] initWithServer:[state serverName]];
        }
        
        //refresh current temperatur
        [self refresh:nil];
    } else {
        [nonConnectedView setHidden:NO];
    }
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

-(IBAction)goBack:(id)sender {
    self.tabBarController.selectedViewController = [self.tabBarController.viewControllers objectAtIndex:0];
}

-(IBAction)refresh:(id)sender {
    [refreshButton setEnabled:NO];
    [refreshButton setTitle:@"Loading..." forState:UIControlStateNormal];
    
    [fetcher getCurrent:^(double temperature, NSString *date) {
        [currentTemperatureLabel setText:[NSString stringWithFormat:@"%.02f", temperature]];
        [currentTemperatureDate setText:date];
        
        [refreshButton setEnabled:YES];
        [refreshButton setTitle:@"Refresh" forState:UIControlStateNormal];
    }];
}

@end
