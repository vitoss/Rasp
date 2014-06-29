//
//  SessionState.m
//  RaspX
//
//  Created by vito on 5/12/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "SessionState.h"

@implementation SessionState
@synthesize connected, serverName, fromDate, toDate;

static SessionState *sharedInstance = nil;

// Get the shared instance and create it if necessary.
+ (SessionState *)sharedInstance {
    if (sharedInstance == nil) {
        sharedInstance = [[super allocWithZone:NULL] init];
        
        //defaults
        sharedInstance.fromDate = [[NSDate date] dateByAddingTimeInterval:-(24*60*60)/48];
        sharedInstance.toDate = [NSDate date];
    }
    
    return sharedInstance;
}

@end
