iOS Client for Indicative's REST API

This REST client creates a JSON representation of your event and posts it to Indicative's Event endpoint.

Features:

+ No external dependencies, so you'll never have library conflicts.
+ Asynchronous, designed to never slow down or break your app.
+ Fault tolerent: if network connectivity is lost, events are queued and retried.

Sample usage:

    // In the didFinishLaunchingWithOptions: method of your main app   
    // delegate, call the launch: method with your project's API key. 
    // You can find yours by logging in to indicative.com and navigating
    // to the Project Settings page.
    
    - (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
        [Indicative launch:@"Your-API-Key-Goes-Here"];
    }

    
    // To record an event, first call the record: method, passing in the name of your event 
    // For example:

    [Indicative record:@"Registration"];


    // To record an event with properties, call the record:withProperties: method, like so:

    [Indicative record:@"Registration" withProperties:@{
        @"Gender": @"Male",
        @"Age": @"23"
    }];
    

    // To acting user, call indentifyUser: method, passing in the user's unique identifier.
    // If you don't identify the user with your own identifier, we will generate an ID for
    // the user based on their device's MAC address.
    
    [Indicative identifyUser:@"TestUser123"];

You should modify and extend this project to your heart's content.  If you make any changes please send a pull request!

As a best practice, consider adding a method that takes as a parameter the object representing your user, and adds certain default properties based on that user's characteristics (e.g., gender, age, etc.).

For more details, see our documentation at: http://www.indicative.com/docs/integration.html
