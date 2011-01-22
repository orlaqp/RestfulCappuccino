# Restful Cappuccino #

Restful Cappuccino is an easy way to access Ruby on Rails RESTful Web Services. This project uses code/ideas from two existing projects CappuccinoResource and CPActiveRecord and add more functionality to make it even more easy and flexible to use.

## How do I use it? ##

I am planning on add an installer but for now it can be downloaded manually to your Frameworks folder. In my case I create a subfolder called RestfulCappuccino and copy the files to it.

Once you have your files in place (I am assuming you put them into Frameworks/RestfulCappuccino) you can import it to your models like this:

	@import <RestfulCappuccino/RestfulCappuccino.j>

## How create a RestfulCappuccino model in Cappuccino ##

	@import <RestfulCappuccino/RestfulCappuccino.j>
	
	@implementation Student : RestfulCappuccino
	{
		CPString	firstName @accessors;
		CPString	lastName @accessors;
	}

	// You do not ned to do this if you are using your model just to retrieve data from the server.
	- (JSObject)attributes
    {
        return {
          "student": {
            "first_name":firstName,
            "last_name":lastName
          }
        };
    }

	// At this moment Restful cappuccino does not do a very job with pluralization it just add an 's' at the end.
	// If your class need a different resource path update this class method.
	+ (CPURL)resourcePath
	{
	    return [CPURL URLWithString:@"/" + [self railsName] + @"s"];
	}

	@end

This is a basic declaration of a RestfulCappuccino class. A simple Cappuccino class inheriting from RestfulCappuccino. With this simple class you could retrieve any data from the server side Synchronously or Asynchronously. Check the following examples:

## Let's talk about Notifications first ##

Restful Cappuccino generate notifications for every single CRUD method either synchronous or asynchronous. Let me explain what information you can get from the notifications. The RestfulCappuccinoNotification object is used to pass important notification information. Let's start by showing you the definition for this class:

	@implementation RestfulCappuccinoNotification : CPObject
	{
		id			requestor @accessors; // Who request the method.
		CPString	modelName @accessors; // The model that requested the method, in our example this would "Student"
		CPString	eventType @accessors; // Type of the event: Load, Save, Update, Remove is mostly for internal use.
		id			eventParameters @accessors; // The parameters passed to the request (not implemented yet, is coming soon)
		id			eventData @accessors; // Some data realated to the method's call. It vary depending on the method.
	}

	@end

There are two ways to subscribe to a notification.

1- Using the addObserver static method. 
	
	[Student addObserver:self];
	
2- Or subscribing to the notification directly: 
	
	[[CPNotificationCenter defaultCenter] addObserver:anObserver selector:@selector(resourceWillLoad:) name:CappuccinoRestfulResourceWillLoad object:self]  


Once you are subscribe to the notification, you could retrieve the RestfulCappuccinoNotification instance like this:

	[[aNotification object] restfulNotification] // This call will return the RestfulCappuccinoNotification object for that notification


## Creating new Records  (C) ##

	var studemt = [Student create:{first_name:"Steven", last_name: "Somthing"}];
	
	var studemt = [Student create:{first_name:"Steven", last_name: "Somthing"} andRequestor:self];
	
### Notification Data ###


## Retrieving Data using Synchronous and Asynchronous calls (R) ##

	Synchronous
	-----------

	var students = [Student all];
	
	var students = [Student allWithRequestor:self];
												   
	var students = [Student findWithParameters:{first_name: "Steven"}];
	
	var students = [Student findWithParameters:{first_name: "Steven"} andRequestor:self];
	

	Asynchronous
	------------
	
	[Student allAsync];
	
	[Student allAsyncWithRequestor:self];
	
	[Student findAsyncWithParameters:{first_name: "Steven"}];
	
	[Student findAsyncWithParameters:{first_name: "Steve"} andRequestor:self];
	
## Updating Records (U) ##

	
	Synchronous
	-----------

	var succesfullySaved = [student save]; // student should be an instance of RestfulCappuccino
	
	var succesfullySaved = [student saveWithRequestor:self];


	Asynchronous
	------------
	
	[student saveAsync];
	
	[student saveAsyncWithRequestor:self];
	

## Deleting Records (D) ##

	
	Synchronous
	-----------

	var succesfullyRemoved = [student destroy]; // student should be an instance of RestfulCappuccino
	
	var succesfullyRemoved = [student destroyWithRequestor:self];


	Asynchronous
	------------
	
	[student destroyAsync];
	
	[student destroyAsyncWithRequestor:self];



 documentation not completed yet ..... more coming soon ...