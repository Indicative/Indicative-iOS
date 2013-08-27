//
//  SendEventsTimer.m
//  Indicative
//
//  Created by Indicative on 08-01-13.
//  Copyright (c) 2013 Indicative. All rights reserved.
//

#import "SendEventsTimer.h"
#import "Indicative.h"

#define SEND_EVENTS_INTERVAL_SECONDS  60

@implementation SendEventsTimer

- (void)main
{
	NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
	
	// set the thread prioritydfg
	[NSThread setThreadPriority:0.9];
	
	// start this scheduled task here, just so that the runloop will start.
    [self scheduleStatsTimer];
	
	CFRunLoopRun();
	
	[pool release];
}

- (void)dealloc
{
	[self.m_tSendStats release];
	[super dealloc];
}



- (void)sendStats {
    [[Indicative get] sendStats];
}

- (void)scheduleStatsTimer {
	SEL mySel = @selector(sendStats);
    
	NSMethodSignature* mySignature = [[self class] instanceMethodSignatureForSelector:mySel];
	NSInvocation* nsInv = [NSInvocation invocationWithMethodSignature:mySignature];
	
	[nsInv setTarget:self];
	[nsInv setSelector:mySel];
    
	self.m_tSendStats = [NSTimer scheduledTimerWithTimeInterval:SEND_EVENTS_INTERVAL_SECONDS invocation:nsInv repeats:YES];
}

- (void)fireStatsTimer {
	[self.m_tSendStats setFireDate:[NSDate date]];
}

@end
