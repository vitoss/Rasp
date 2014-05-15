//
//  TemperatureFetcher.m
//  RaspX
//
//  Created by vito on 5/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TemperatureFetcher.h"

@implementation TemperatureFetcher {
    NSString *serverName;
}

-(id) initWithServer: (NSString *)name
{
    self = [super init];
    if(self)
    {
        serverName = name;
    }
    return self;
}

-(void) getCurrent:(void (^)(double))callbackBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        callbackBlock(1.0f);
    });
}

-(NSString *)serverName {
    return serverName;
}

@end
