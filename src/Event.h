//
//  Event.h
//  Event
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, copy) NSString *eventName;
@property (nonatomic, copy) NSString *eventUniqueId;
@property (nonatomic, copy) NSNumber *eventTime;
@property (nonatomic, retain) NSDictionary *properties;

-(NSDictionary*)toJson;

+(Event*)createEvent:(NSString*)eventName withProperties:(NSDictionary*)withProperties withUniqueId:(NSString*) uniqueId withApiKey:(NSString*) apiKey;

@end
