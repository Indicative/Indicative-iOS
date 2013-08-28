iOS
===

iOS Client for Indicative's REST API

Standalone client for iOS apps.  Events are queued up in an NSMutableArray, and a scheduled timer job periodically sends us those events in a background thread.  It has no external dependencies, so you'll never have library conflicts, and it should never slow down or break your app.  You should modify and extend this class to your heart's content.  As a best practice, consider adding a method that takes as a parameter the object representing the user, and adds certain default properties based on that user's characteristics (e.g., gender, age, etc.).

Sample usage: 

    [Indicative recordEvent:@"Registration" withProperties:[NSDictionary dictionaryWithObjectsAndKeys:@"Male", @"Gender", @"25", @"Age", nil] withUniqueId:@"user47"];

For more details, see our documentation at: http://www.indicative.com/docs/integration.html
