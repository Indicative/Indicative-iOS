iOS
===

iOS Client for Indicative's REST API

Standalone client for iOS apps.  Events are queued up in an NSMutableArray, and a scheduled timer job periodically sends us those events in a background thread.  

Sample usage: [Indicative recordEvent:@"Registration" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"Male", @"Gender", @"25", @"Age", nil] withUniqueId:@"user47"];

For more details, see our documentation at: http://www.indicative.com/docs/integration.html
