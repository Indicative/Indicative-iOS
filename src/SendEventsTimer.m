//
//  SendEventsTimer.m
//  Indicative
//
//  Scheduled timer to periodically send Events to Indicative's API.
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import "SendEventsTimer.h"
#import "Indicative.h"

// How often to send the Events to Indicative's API
#define SEND_EVENTS_INTERVAL_SECONDS  60

@implementation SendEventsTimer

/**
 * Sets the thread's priority and starts the scheduled task.
 */
- (void)main
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// set the thread priority
	[NSThread setThreadPriority:0.9];
	
	// start this scheduled task here, just so that the runloop will start.
    [self scheduleEventsTimer];
	
	CFRunLoopRun();
	
	[pool release];
}

- (void)dealloc
{
	[self.m_tSendEvents release];
	[super dealloc];
}


/**
 * Sends the events to Indicative's API endpoint.
 */
- (void)sendEvents {
    [[Indicative get] sendEvents];
}

/**
 * Schedules the timer to periodically send Events to Indicative's API endpoint.
 */
- (void)scheduleEventsTimer {
	SEL mySel = @selector(sendEvents);
    
	NSMethodSignature* mySignature = [[self class] instanceMethodSignatureForSelector:mySel];
	NSInvocation* nsInv = [NSInvocation invocationWithMethodSignature:mySignature];
	
	[nsInv setTarget:self];
	[nsInv setSelector:mySel];
    
	self.m_tSendEvents = [NSTimer scheduledTimerWithTimeInterval:SEND_EVENTS_INTERVAL_SECONDS invocation:nsInv repeats:YES];
}

/**
 * Fires the timer.
 */
- (void)fireEventsTimer {
	[self.m_tSendEvents setFireDate:[NSDate date]];
}

@end
