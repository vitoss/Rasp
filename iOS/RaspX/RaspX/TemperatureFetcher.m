//
//  TemperatureFetcher.m
//  RaspX
//
//  Created by vito on 5/15/14.
//  Copyright (c) 2014 __MyCompanyName__. All rights reserved.
//

#import "TemperatureFetcher.h"
#import "SessionState.h"

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

-(void) getHistory:(void (^)(NSMutableArray *))callbackBlock {
    
#if MOCK_MODE == 0
    dispatch_async(dispatch_get_main_queue(), ^{
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"http://%@/api/temperature", serverName]];
        
        SessionState *state = [SessionState sharedInstance];
        
        NSString *startDate = [self formatDate:[state fromDate]];
        NSString *endDate = [self formatDate:[state toDate]];
        
        NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
        [request setHTTPMethod:@"GET"];
        [request setValue:@"1235" forHTTPHeaderField:@"Salt"];
        [request setValue:@"57b2e61b964e5ccdfd34d687db049885" forHTTPHeaderField:@"Hash"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [request setValue:startDate forHTTPHeaderField:@"Start-Date"];
        [request setValue:endDate forHTTPHeaderField:@"End-Date"];
        
        [NSURLConnection sendAsynchronousRequest:request
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^(NSURLResponse *response,
                                                   NSData *data, NSError *connectionError)
         {
             if (data.length > 0 && connectionError == nil)
             {
                 NSMutableArray *response = [NSJSONSerialization JSONObjectWithData:data
                                                                          options:0
                                                                            error:NULL];
                 
                 callbackBlock(response);
             }
         }];
    });
#endif

#if MOCK_MODE == 1
    double delayInSeconds = 5.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        NSString *data = @"[{\"value\": 22.687, \"timestamp\": \"2014-06-21 08:52:02\"}, { \"value\": 18.687, \"timestamp\": \"2014-06-21 09:52:02\"},{\"value\": 22.687, \"timestamp\": \"2014-06-22 08:52:02\"}, { \"value\": 18.687, \"timestamp\": \"2014-06-23 09:52:02\"},{\"value\": 22.687, \"timestamp\": \"2014-06-24 08:52:02\"}, { \"value\": 18.687, \"timestamp\": \"2014-06-25 09:52:02\"},{\"value\": 5.687, \"timestamp\": \"2014-06-25 08:52:02\"}, { \"value\": 8.187, \"timestamp\": \"2014-06-25 09:52:02\"},{\"value\": 22.687, \"timestamp\": \"2014-06-25 15:52:02\"}, { \"value\": 30.687, \"timestamp\": \"2014-06-26 09:52:02\"},{\"value\": 22.687, \"timestamp\": \"2014-06-27 08:52:02\"}, { \"value\": 18.687, \"timestamp\": \"2014-06-27 09:52:02\"}]";
        
        NSMutableArray *response = [NSJSONSerialization JSONObjectWithData:[data dataUsingEncoding:NSUTF8StringEncoding]
                                                                   options:0
                                                                     error:NULL];
        
        callbackBlock(response);
    });
#endif
    
}

-(NSString *) formatDate:(NSDate *)date {
    NSString *defaultDate = [NSString stringWithFormat:@"%@", date];
    
    return [defaultDate substringToIndex:[defaultDate rangeOfString:@"+"].location];
}

-(NSString *)serverName {
    return serverName;
}

@end
