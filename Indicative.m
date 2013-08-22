//
//  Indicative.m
//  Indicative

//  Standalone client for Indicative's REST API.  Events are queued up in an NSMutableArray, and a scheduled timer job periodically sends us those events in a background thread.
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import "Indicative.h"
#import "Event.h"

#define endPointURL @"http://api.skunkalytics.com/service/event"

const int TIMEOUT_SECONDS = 30;
BOOL debug = NO;

static Indicative* mIndicative = nil;

@implementation Indicative

+(Indicative*)get {
    if(nil == mIndicative) {
        mIndicative = [[Indicative alloc] init];
        mIndicative.unsentEvents = [NSMutableArray arrayWithCapacity:0];
        [mIndicative startSendEventsTimer];
    }
    
    return mIndicative;
}

-(void)dealloc {
    self.apiKey = nil;
    self.unsentEvents = nil;
    self.sm = nil;
    [super dealloc];
}

-(void)startSendEventsTimer{
    self.sm = [[SendEventsTimer alloc] init];
    [self.sm start];
}

+(Indicative*)launch:(NSString*)apiKey {
    Indicative *indicative = [Indicative get];
    indicative.apiKey = apiKey;
    return indicative;
}

+(void)recordEvent:(NSString*)eventName withProperties:(NSDictionary*)properties withUniqueId:(NSString*)uniqueId{
    [self recordEvent:eventName withProperties:properties withUniqueId:uniqueId withApiKey:[self get].apiKey];
}

+(void)recordEvent:(NSString*)eventName withProperties:(NSDictionary*)properties withUniqueId:(NSString*)uniqueId withApiKey:(NSString*)apiKey{
    for (id value in properties.allValues) {
        Assert([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]);
    }
    
    Event *event = [Event createEvent:eventName withProperties:properties withUniqueId:uniqueId withApiKey:apiKey];
    
    @synchronized(self){
        [[self get].unsentEvents addObject:event];
    }
}

-(void) sendStats {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSArray *stats = nil;
    
    @synchronized(self) {
        stats = [NSArray arrayWithArray:self.unsentEvents];
    }
    
    if(stats.count != 0) {
        
        @try {
            
            for (Event *data in stats) {
                NSInteger statusCode = [self postRequest:[data toJson]];
                if(statusCode != 0 && statusCode != 408 && statusCode != 500){
                    [self removeSentStat:data];
                }
            }
        }
        @catch (NSException* ex) {
            NSLog(@"Error while sending events to Indicative: %@", ex);
        }
    }
    
    [pool drain];
}

-(void)removeSentStat:(Event*)data {
    @synchronized(self) {
        [self.unsentEvents removeObject:data];
    }
}

-(NSInteger)postRequest:(NSDictionary*)jsonPayload {
	// create a request
	NSURL* url = [NSURL URLWithString:endPointURL];
	NSMutableURLRequest* req = [NSMutableURLRequest requestWithURL:url];
    
	// !! Set this timeout and handle timeout errors.
	[req setTimeoutInterval:TIMEOUT_SECONDS];
	
	[req setHTTPMethod:@"POST"];
    
    NSError* jsonError = nil;
    NSData* postData = [NSJSONSerialization dataWithJSONObject:jsonPayload options:0 error:&jsonError];
    
    if(debug){
        NSLog(@"JSON event is: %@", [[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease]);
    }
        
    [req setHTTPBody:postData];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    
	// post the url to the server
	NSHTTPURLResponse* resp = nil;
    NSInteger statusCode = 0;
    NSError* error = nil;
	
	// post the request synchronously
	NSData* nsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    
    
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)resp;
    statusCode = urlResponse.statusCode;
    if(debug){
        if (!error) {
                NSLog(@"Status Code from Indicative: %li %@", (long)urlResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
                NSLog(@"Response Body from Indicative: %@", [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"An error occured with your request to Indicative, Status Code: %i", urlResponse.statusCode);
            NSLog(@"Description: %@", [error localizedDescription]);
            NSLog(@"Response Body: %@", [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding]);
        }
    }
    
    return statusCode;
}

@end
