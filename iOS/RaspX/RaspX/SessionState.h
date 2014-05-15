//
//  SessionState.h
//  RaspX
//
//  Created by vito on 5/12/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SessionState : NSObject
    + (id)sharedInstance;

@property (nonatomic, assign) BOOL connected;
@property (nonatomic, retain) NSString *serverName;

@end
