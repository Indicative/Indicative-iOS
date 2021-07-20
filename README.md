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
    

    // To specify the acting user, call identifyUser: method, passing in the user's unique identifier.
    // If you don't identify the user with your own identifier, we will generate an ID for
    // the user based on their device's MAC address.
    
    [Indicative identifyUser:@"TestUser123"];
    
We've added <b>common properties</b> and cached <b>unique identifiers</b>!

A <b>common property</b> is a property that gets recorded for all events. Common properties are stored in NSUserDefaults and appended to each event's properties when the event is recorded.

You can also set a <b>unique identifier</b> to be recorded for all events. This value will be stored in NSUserDefaults as well, and will be set for all events that don't otherwise have a unique identifier specified.  If you haven't set a unique identifier, Indicative will generate a UUID during initialization and and treat that UUID as the default unique identifier for all events. To set a different unique identifier for a specific event, simply call the `record:withUniqueKey:` method.

Our API -- all are static methods:

<table>
<tr>
<th> Method Name </th>
<th> Method Description </th>
</tr>

<tr>
<td> +(Indicative*)launch:(NSString*)apiKey</td>
<td> Initializes the static Indicative instance with the project's API Key.  This method will generate and store an anonymous unique identifier if one isn't already stored.</td>
</tr>

<tr>
<td> +(Indicative*)identifyUser:(NSString*)uniqueKey</td>
<td> Stores (in NSUserDefaults) a unique identifier to be used for all events that don't have a unique key otherwise specified.</td>
</tr>

<tr>
<td>+(Indicative*)identifyUserWithAlias:(NSString*)uniqueKey</td>
<td> Stores (in NSUserDefaults) a unique identifier to be used for all events that don't have a unique key otherwise specified. Additionally, an alias call is sent to Indicative's servers to associate the specified unique identifier with the persisted anonymous ID.</td>
</tr>

<tr>
<td> +(Indicative*)identifyUser:(NSString*)uniqueKey</td>
<td> Stores (in NSUserDefaults) a unique identifier to be used for all events that don't have a unique key otherwise specified.</td>
</tr>

<tr>
<td> +(void)clearUniqueKey</td>
<td> Clears the user-specified unique identifier. The uniqueness identifier will fall back to the anonymous ID generated on first initialization.</td>
</tr>
<tr>
<td> +(void)reset</td>
<td> Clears all state stored by the SDK, including peristed user IDs, common properties, and anonymous ID.</td>
</tr>


<tr>
<td> +(Indicative*)addCommonProperties:(NSDictionary*)properties</td>
<td> Adds the specified properties to the dictionary of common properties in NSUserDefaults.  NOTE: dictionary keys should be NSString objects, while dictionary values should be string, numeric, or boolean objects. </td>
</tr>

<tr>
<td> +(Indicative*)addCommonProperty:(id)propertyValue forName:(NSString*)propertyName</td>
<td> Adds a property to the dictionary of common properties in NSUserDefaults with the given name and value. Property values should be string, numeric, or boolean objects.</td>
</tr>

<tr>
<td> +(Indicative*)removeCommonPropertyWithName:(NSString*)propertyName </td>
<td> Removes a single common property from storage with the given name.</td>
</tr>

<tr>
<td> +(Indicative*)clearCommonProperties </td>
<td> Removes all common properties from storage. </td>
</tr>

<tr>
<td> +(void)record:(NSString*)eventName</td>
<td> Queues an event to be recorded with the given name, using the uniqueness identifier stored previously by initialization or explicitly set by the `identifyUser:` method, and any common properties previously stored.</td>
</tr>

<tr>
<td> +(void)record:(NSString*)eventName withProperties:(NSDictionary*)properties</td>
<td> Queues an event to be recorded with the given name and properties, along with the uniqueness identifier generated by the app or cached previously, and any common properties in storage. NOTE: the objects stored as property values should be string, numeric, or boolean objects.</td>
</tr>

<tr>
<td> +(void)record:(NSString*)eventName withUniqueKey:(NSString*)uniqueKey</td>
<td> Queues an event to be recorded with the given name and uniqueness identifier, along with any common properties previously stored.</td>
</tr>

<tr>
<td> +(void)record:(NSString*)eventName withProperties:(NSDictionary*)properties withUniqueKey:(NSString*)uniqueKey</td>
<td> Queues an event to be recorded with the given name, uniqueness identifier, and properties, along with any common properties in storage. NOTE: the objects stored as property values should be string, numeric, or boolean objects.</td>
</tr>

<tr>
<td> +(void)recordEvent:(IndicativeEvent*)event</td>
<td> Queues the given IndicativeEvent object to be recorded.</td>
</tr>

</table>

You should modify and extend this project to your heart's content.  If you make any changes please send a pull request!

As a best practice, consider adding a method that takes as a parameter the object representing your user, and adds certain default properties based on that user's characteristics (e.g., gender, age, etc.).

For more details, see our documentation at: http://app.indicative.com/docs/integration.html
