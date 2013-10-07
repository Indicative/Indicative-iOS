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
#import "Indicative.h"

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
 * @param uniqueId     a unique identifier for the user associated with the event
 *
 * @returns the created Event
 */

+(Event*)createEvent:(NSString*)eventName withUniqueId:(NSString*)uniqueId {
    return [self createEvent:eventName withUniqueId:uniqueId withApiKey:[Indicative get].apiKey];
}

/**
 * Creates the Event and sets its initial values.
 *
 * @param eventName    the name of the event
 * @param uniqueId     a unique identifier for the user associated with the event
 * @param apiKey       the project's API key
 *
 * @returns the created Event
 */
+(Event*)createEvent:(NSString*)eventName withUniqueId:(NSString*)uniqueId withApiKey:(NSString*)apiKey{
    
    Event *data = [[Event alloc] init];
    
    data.eventName = eventName;
    data.eventUniqueId = uniqueId;
    data.eventTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    data.properties = [[NSMutableDictionary alloc] init];
    data.apiKey = apiKey;
    
    return [data autorelease];
}

/**
 * Adds a property name/value pair to the properties NSMutableDictionary, gracefully handling nil property values.
 *
 * @param propertyName      the name of the event
 * @param propertyValue     a unique identifier for the user associated with the event
 *
 * @returns the modified Event
 */

-(Event*)addProperty:(NSString*)propertyName withValue:(id)propertyValue {
    if(!propertyName) {
        NSLog(@"Indicative property name was nil, not recording property");
        return self;
    }
    
    if (!([propertyValue isKindOfClass:NSString.class] || [propertyValue isKindOfClass:NSNumber.class])) {
        if(!propertyValue){
            [self.properties setObject: @"null" forKey:propertyName];
            return self;
        }
        
        NSLog(@"Indicative property value was not an NSString or NSNumber, not recording property named %@", propertyName);
        return self;
    }
    
    [self.properties setObject: propertyValue ? propertyValue : [NSNull null] forKey:propertyName];

    return self;
}

@end
