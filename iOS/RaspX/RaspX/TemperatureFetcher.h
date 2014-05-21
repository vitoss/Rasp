//
//  TemperatureFetcher.h
//  RaspX
//
//  Created by vito on 5/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TemperatureFetcher : NSObject

-(id) initWithServer: (NSString *)serverName;
-(void) getCurrent:(void (^)(double))callbackBlock;
-(NSString *)serverName;

@end