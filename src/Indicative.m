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

#define endPointURL @"https://api.indicative.com/service/event"

// Number of seconds to wait before timing out
const int TIMEOUT_SECONDS = 30;

// Enable this to see some basic logging
BOOL debug = NO;

static Indicative* mIndicative = nil;

@implementation Indicative

/**
 * Instantiates and returns the static Indicative instance.
 *
 * @returns the static Indicative instance
 */
+(Indicative*)get {
    if(nil == mIndicative) {
        mIndicative = [[Indicative alloc] init];
    }
    
    return mIndicative;
}

-(void)dealloc {
    self.apiKey = nil;
    self.unsentEvents = nil;
    self.sm = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

/**
 * Schedules the timer to periodically send Events to the Indicative API endpoint.
 */
-(void)startSendEventsTimer{
    self.sm = [[SendEventsTimer alloc] init];
    [self.sm start];
}

/**
 * Instantiates the static Indicative instance and initializes it with the project's API key.
 *
 * @param apiKey    the Project's API Key
 *
 * @returns         the static Indicative instance
 */
+(Indicative*)launch:(NSString*)apiKey {
    Indicative *indicative = [Indicative get];
    indicative.apiKey = apiKey;
    indicative.unsentEvents = [NSMutableArray arrayWithCapacity:0];
    [indicative startSendEventsTimer];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(sendEvents)
                                                 name:UIApplicationDidEnterBackgroundNotification
                                               object:nil];
    return indicative;
}

/**
 * Adds the Event object to an NSMutableArray.
 *
 * @param event    the Event to be recorded
 */
+(void)recordEvent:(Event*)event {
    @synchronized(self){
        [[self get].unsentEvents addObject:event];
    }
}

/**
 * Sends any events in the NSMutableArray to the Indicative API endpoint.
 */
+(void) sendEvents {
    [[Indicative get] sendEvents];
}

/**
 * Sends any events in the NSMutableArray to the Indicative API endpoint. If sent successfully, or if a non-retriable error code is received, the event is removed from the NSMutableArray.
 */
-(void) sendEvents {
    NSAutoreleasePool *pool = [NSAutoreleasePool new];
    NSArray *events = nil;
    
    @synchronized(self) {
        events = [NSArray arrayWithArray:self.unsentEvents];
    }
    
    if(events.count != 0) {
        
        @try {
            
            for (Event *data in events) {
                NSInteger statusCode = [self postRequest:[data toJson]];
                if(statusCode != 0 && statusCode != 408 && statusCode != 500){
                    [self removeSentEvent:data];
                }
            }
        }
        @catch (NSException* ex) {
            NSLog(@"Error while sending events to Indicative: %@", ex);
        }
    }
    
    [pool drain];
}

/**
 * Removes the Event from the NSMutableArray.
 *
 * @param data  the Event to remove
 */
-(void)removeSentEvent:(Event*)data {
    @synchronized(self) {
        [self.unsentEvents removeObject:data];
    }
}

/**
 * Posts the Event to the Indicative API endpoint.
 *
 * @param jsonPayload   an NSDictionary representing the event
 *
 * @returns             the response's status code
 */
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
        NSLog(@"Indicative JSON event is: %@", [[[NSString alloc] initWithData:postData encoding:NSUTF8StringEncoding] autorelease]);
    }
    
    [req setHTTPBody:postData];
    [req setValue:@"application/json" forHTTPHeaderField: @"Content-Type"];
    [req setValue:[NSString stringWithFormat:@"%d", postData.length] forHTTPHeaderField:@"Content-Length"];
    
	NSHTTPURLResponse* resp = nil;
    NSInteger statusCode = 0;
    NSError* error = nil;
	
	NSData* nsData = [NSURLConnection sendSynchronousRequest:req returningResponse:&resp error:&error];
    
    NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)resp;
    statusCode = urlResponse.statusCode;
    if(debug){
        if (!error) {
            NSLog(@"Status Code from Indicative: %li %@", (long)urlResponse.statusCode, [NSHTTPURLResponse localizedStringForStatusCode:urlResponse.statusCode]);
            NSLog(@"Response Body from Indicative: %@", [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding]);
        } else {
            NSLog(@"An error occured with your request to Indicative, Status Code: %i", urlResponse.statusCode);
            NSLog(@"Indicative Response Error Description: %@", [error localizedDescription]);
            NSLog(@"Indicative Response Body: %@", [[NSString alloc] initWithData:nsData encoding:NSUTF8StringEncoding]);
        }
    }
    
    return statusCode;
}

@end
