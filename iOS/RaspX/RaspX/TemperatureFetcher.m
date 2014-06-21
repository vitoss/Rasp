//
//  TemperatureFetcher.m
//  RaspX
//
//  Created by vito on 5/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TemperatureFetcher.h"

#define CRYPTO_KEY 9086229259

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

-(void) getCurrent:(void (^)(double, NSString *))callbackBlock {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/temperature", serverName]];
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"1235" forHTTPHeaderField:@"Salt"];
        [request setValue:@"57b2e61b964e5ccdfd34d687db049885" forHTTPHeaderField:@"Hash"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];

        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             if (data.length > 0 && connectionError == nil)
             {
                 NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];
                 
                 double temperature = [[response objectForKey:@"value"] doubleValue];
                 NSString *date = [NSString stringWithString:[response objectForKey:@"timestamp"]];
                 
                 callbackBlock(temperature, date);
             }
         }];
    });
}

-(NSString *)serverName {
    return serverName;
}

@end
