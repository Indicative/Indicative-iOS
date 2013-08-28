//
//  SendEventsTimer.h
//  Indicative
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SendEventsTimer : NSThread

@property(nonatomic, retain) NSTimer *m_tSendEvents;

- (void)sendEvents;
- (void)scheduleEventsTimer;
- (void)fireEventsTimer;

@end

