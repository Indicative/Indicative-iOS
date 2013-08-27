//
//  Indicative.m
//  Indicative
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import "Event.h"

@implementation Event

-(void)dealloc {
    self.projectId = nil;
    self.eventName = nil;
    self.eventUniqueId = nil;
    self.eventTime = nil;
    self.properties = nil;
    
    [super dealloc];
}

-(NSDictionary*)toJson {
    NSMutableDictionary* json = [NSMutableDictionary dictionary];
    
    [json setValue:self.projectId forKey:@"projectId"];
    
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

+(Event*)createEvent:(NSString*)eventName withProperties:(NSDictionary*)properties withUniqueId:(NSString*)uniqueId withApiKey:(NSString*)apiKey{
    for (id value in properties.allValues) {
        Assert([value isKindOfClass:NSString.class] || [value isKindOfClass:NSNumber.class]);
    }
    
    Event *data = [[Event alloc] init];
    
    data.eventName = eventName;
    data.eventUniqueId = uniqueId;
    data.eventTime = [NSNumber numberWithDouble:[[NSDate date] timeIntervalSince1970] * 1000];
    data.properties = properties;
    data.projectId = apiKey;
    
    return [data autorelease];
}

@end
