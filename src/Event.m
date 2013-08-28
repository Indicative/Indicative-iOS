//
//  Indicative.m
//  Indicative
//
//  Object representing an Indicative Event.
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import "Event.h"

@implementation Event

-(void)dealloc {
    self.apiKey = nil;
    self.eventName = nil;
    self.eventUniqueId = nil;
    self.eventTime = nil;
    self.properties = nil;
    
    [super dealloc];
}

/**
 * Creates an NSDictionary representing the Event.
 *
 * @returns the NSDictionary representing the Event.
 */
-(NSDictionary*)toJson {
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    
    [json setValue:self.apiKey forKey:@"apiKey"];
    
    [json setValue:self.eventName forKey:@"eventName"];
    
    [json setValue:self.eventTime forKey:@"eventTime"];
    
    if (self.properties.count > 0) {
        [json setObject:self.properties forKey:@"properties"];
    }
    
    if (self.eventUniqueId != nil) {
        [json setObject:self.eventUniqueId forKey:@"eventUniqueId"];
    }
    
    return json;
}

/**
 * Creates the Event and sets its initial values.
 *
 * @param eventName    the name of the event
 * @param properties   a dictionary containing names and values of properties
 * @param uniqueId     a unique identifier for the user associated with the event
 * @param apiKey       the project's API key
 *
 * @returns the created Event
 */
+(Event*)createEvent:(NSString*)eventName withProperties:(NSDictionary*)properties withUniqueId:(NSString*)uniqueId withApiKey:(NSString*)apiKey{
    for (id value in properties.allValues) {
        Assert([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]);
    }
    
    Event *data = [[Event alloc] init];
    
    data.eventName = eventName;
    data.eventUniqueId = uniqueId;
    data.eventTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    data.properties = properties;
    data.apiKey = apiKey;
    
    return [data autorelease];
}

@end
