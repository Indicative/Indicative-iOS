//
//  Indicative.h
//  Indicative
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "SendEventsTimer.h"

@interface Indicative : NSObject

@property (nonatomic, copy) NSString *apiKey;
@property (nonatomic, retain) NSMutableArray *unsentEvents;
@property (nonatomic, retain) SendEventsTimer *sm;

+(Indicative*)get;

+(Indicative*)launch:(NSString*)apiKey;

+(void)recordEvent:(Event*)event;

-(void)sendEvents;

@end
