@import <Foundation/CPObject.j>
@import <Foundation/CPDate.j>
@import <Foundation/CPString.j>
@import <Foundation/CPURLConnection.j>
@import <Foundation/CPURLRequest.j>
@import "CRSupport.j"


@implementation CappuccinoRestfulNotification : CPObject
{
	id			requestor @accessors;
	CPString	modelName @accessors;
	CPString	eventType @accessors;
	id			eventParameters @accessors;
	id			eventData @accessors;
}

@end

var defaultRecordIdentifierKey = @"id",
    classAttributeNames  = [CPDictionary dictionary],
	notificationInfo = [[CappuccinoRestfulNotification alloc] init];

CappuccinoRestfulResourceWillLoad = @"CappucinoRestfulResourceWillLoad";
CappuccinoRestfulResourceDidLoad = @"CappuccinoRestfulResourceDidLoad";
CappuccinoRestfulResourcesWillLoad = @"CappucinoRestfulResourcesWillLoad";
CappuccinoRestfulResourcesDidLoad = @"CappuccinoRestfulResourcesDidLoad";
CappuccinoRestfulResourceWillSave = @"CappuccinoRestfulResourceWillSave";
CappuccinoRestfulResourceDidSave = @"CappuccinoRestfulRecordDidSave";
CappuccinoRestfulResourceDidNotSave = @"CappuccinoRestfulResourceDidNotSave";
CappuccinoRestfulResourceWillDestroy = @"CappuccinoRestfulResourceWillDestroy";
CappuccinoRestfulResourceDidDestroy = @"CappuccinoRestfulResourceDidDestroy";
CappuccinoRestfulResourceDidNotDestroy = @"CappuccinoRestfulResourceDidNotDestroy";

@implementation CappuccinoRestful : CPObject
{
	CPString identifier @accessors;
}

+ (CappuccinoRestfulNotification)restfulNotification
{
	return notificationInfo;
}

+ (void)addObserver:(id)anObserver
{	
	debugger;
	var center = [CPNotificationCenter defaultCenter];
	
	if ([anObserver respondsToSelector:@selector(resourceWillLoad:)]) 
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceWillLoad object:self];
        [center addObserver:anObserver selector:@selector(resourceWillLoad:) name:CappuccinoRestfulResourceWillLoad object:self];
	}
    if ([anObserver respondsToSelector:@selector(resourceDidLoad:)]) 
	{
	    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidLoad object:self];
        [center addObserver:anObserver selector:@selector(resourceDidLoad:) name:CappuccinoRestfulResourceDidLoad object:self];
	}
    if ([anObserver respondsToSelector:@selector(resourcesWillLoad:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourcesWillLoad object:self];
        [center addObserver:anObserver selector:@selector(resourcesWillLoad:) name:CappuccinoRestfulResourcesWillLoad object:self];
	}    
    if ([anObserver respondsToSelector:@selector(resourcesDidLoad:)]) 
	{
	    [center removeObserver:anObserver name:CappuccinoRestfulResourcesDidLoad object:self];
        [center addObserver:anObserver selector:@selector(resourcesDidLoad:) name:CappuccinoRestfulResourcesDidLoad object:self];
	}	
    if ([anObserver respondsToSelector:@selector(resourceWillSave:)])
	{
	    [center removeObserver:anObserver name:CappuccinoRestfulResourceWillSave object:self];
        [center addObserver:anObserver selector:@selector(resourceWillSave:) name:CappuccinoRestfulResourceWillSave object:self];
	}
	if ([anObserver respondsToSelector:@selector(resourceDidSave:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceDidSave object:self];
        [center addObserver:anObserver selector:@selector(resourceDidSave:) name:CappuccinoRestfulResourceDidSave object:self];
	}
	if ([anObserver respondsToSelector:@selector(resourceDidNotSave:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceDidNotSave object:self];
        [center addObserver:anObserver selector:@selector(resourceDidNotSave:) name:CappuccinoRestfulResourceDidNotSave object:self];
	}
	if ([anObserver respondsToSelector:@selector(resourceWillDestroy:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceWillDestroy object:self];
        [center addObserver:anObserver selector:@selector(resourceWillDestroy:) name:CappuccinoRestfulResourceWillDestroy object:self];
	}
	if ([anObserver respondsToSelector:@selector(resourceDidDestroy:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceDidDestroy object:self];
        [center addObserver:anObserver selector:@selector(resourceDidDestroy:) name:CappuccinoRestfulResourceDidDestroy object:self];
	}
	if ([anObserver respondsToSelector:@selector(resourceDidNotDestroy:)])
	{
		[center removeObserver:anObserver name:CappuccinoRestfulResourceDidNotDestroy object:self];
        [center addObserver:anObserver selector:@selector(resourceDidNotDestroy:) name:CappuccinoRestfulResourceDidNotDestroy object:self];
	}

}

+ (void)removeObserver:(id)anObserver
{
    var center = [CPNotificationCenter defaultCenter];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceWillLoad object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidLoad object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourcesWillLoad object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourcesDidLoad object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceWillSave object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidSave object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidNotSave object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceWillDestroy object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidDestroy object:self];
    [center removeObserver:anObserver name:CappuccinoRestfulResourceDidNotDestroy object:self];
}

+ (CPString)identifierKey
{
    return defaultRecordIdentifierKey;
}

+ (CPURL)resourcePath
{
    return [CPURL URLWithString:@"/" + [self railsName] + @"s"];
}

+ (CPString)railsName
{
    return [[self className] railsifiedString];
}

- (JSObject)attributes
{
    CPLog.warn('This method must be declared in your class to save properly.');
    return {};
}

- (CPArray)attributeNames
{
    if ([classAttributeNames objectForKey:[self className]]) {
        return [classAttributeNames objectForKey:[self className]];
    }

    var attributeNames = [CPArray array],
        attributes     = class_copyIvarList([self class]);

    for (var i = 0; i < attributes.length; i++) {
        [attributeNames addObject:attributes[i].name];
    }

    [classAttributeNames setObject:attributeNames forKey:[self className]];

    return attributeNames;
}

- (void)setAttributes:(JSObject)attributes
{

	for (var attribute in attributes) {
        if (attribute == [[self class] identifierKey]) {
            [self setIdentifier:attributes[attribute].toString()];
        } else {
            var attributeName = [attribute cappifiedString];
            if ([[self attributeNames] containsObject:attributeName]) {
                var value = attributes[attribute];
                /*
                 * I would much rather retrieve the ivar class than pattern match the
                 * response from Rails, but objective-j does not support this.
                */
                switch (typeof value) {
                    case "boolean":
                        if (value) {
                            [self setValue:YES forKey:attributeName];
                        } else {
                            [self setValue:NO forKey:attributeName];
                        }
                        break;
                    case "number":
                        [self setValue:value forKey:attributeName];
                        break;
                    case "string":
                        if (value.match(/^\d{4}-\d{2}-\d{2}$/)) {
                            // its a date
                            [self setValue:[CPDate dateWithDateString:value] forKey:attributeName];
                        } else if (value.match(/^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}Z$/)) {
                            // its a datetime
                            [self setValue:[CPDate dateWithDateTimeString:value] forKey:attributeName];
                        } else {
                            // its a string
                            [self setValue:value forKey:attributeName];
                        }
                        break;
					case "object":						
						if (value == null) 
						{
							[self setValue:nil forKey:attributeName];							
						}
						else if (value.length != null)
						{
							var childs = [CPArray array];							
							for (var i=0; i<value.length; i++)
							{
								var child = [CPClassFromString([self className]) new:value[i]];								
								[childs addObject:child];
							}							
							[self setValue:childs forKey:attributeName];						
						}
						
						break;
                }
            }
        }
    }
}

+ (id)new
{
    return [self new:nil];
}

+ (id)new:(JSObject)attributes
{
    var resource = [[self alloc] init];

    if (!attributes)
        attributes = {};

    [resource setAttributes:attributes];
    return resource;
}

@end

@implementation CappuccinoRestful (CRUD)
{
	
}

+ (CPArray)all
{
	return [self findWithParameters:nil andRequestor:nil];
}

+ (void)allAsyncWithRequestor:(id)theRequestor
{
	[self findAsyncWithParameters:nil andRequestor:theRequestor];
}

+ (CPArray)findWithParameters:(id)parameters andRequestor:(id)theRequestor
{
	var request = [self resourcesWillLoadWithParameters:parameters andRequestor:theRequestor];

    if (!request) {
        return NO;
    }

    var response = [CPURLConnection sendSynchronousRequest:request];

    if (response[0] >= 400) {
        return nil;
    } else {
        return [self resourcesDidLoadWithResponse:response[1] andRequestor:theRequestor];
    }
}

+ (void)findAsyncWithParameters:(id)parameters andRequestor:(id)theRequestor
{
	var request = [self resourcesWillLoadWithParameters:parameters andRequestor:theRequestor];

    if (!request) {
        return NO;
    }
	var connection = [[CPURLConnection alloc] initWithRequest:request delegate:[self class] startImmediately:NO];
	connection.requestor = theRequestor;
	connection.eventType = request.eventType;
	[connection start];
}

+ (id)create:(JSObject)attributes
{
	return [self createWithAttributes:attributes andRequestor:nil];
}

+ (id)createWithAttributes:(JSObject)attributes andRequestor:(id)theRequestor
{
    var resource = [self new:attributes];
    if ([resource saveWithRequestor:theRequestor]) {
        return resource;
    } else {
        return nil;
    }
}

- (BOOL)save
{
	return [self saveWithRequestor:nil];
}

- (BOOL)saveWithRequestor:(id)theRequestor
{
    var request = [self resourceWillSaveWithRequestor:theRequestor];

    if (!request) {
        return NO;
    }
    var response = [CPURLConnection sendSynchronousRequest:request];

    if (response[0] >= 400) {
        [self resourceDidNotSaveWithResponse:response[1] andRequestor:theRequestor];
        return NO;
    } else {
        [self resourceDidSaveWithResponse:response[1] andRequestor:theRequestor];
        return YES;
    }
}

- (void)saveAsync
{
	[self saveAsyncWitRequestor:nil];
}

- (void)saveAsyncWithRequestor:(id)theRequestor
{
	var request = [self resourceWillSaveWithRequestor:theRequestor];

    if (!request) {
        return NO;
    }

	var connection = [[CPURLConnection alloc] initWithRequest:request delegate:[self class] startImmediately:NO];
	connection.requestor = theRequestor;
	connection.eventType = request.eventType;
	connection.modelTarget = self;
	[connection start];
}

- (BOOL)destroy
{
	return [self destroyWithRequestor:nil];
}

- (BOOL)destroyWithRequestor:(id)theRequestor
{
    var request = [self resourceWillDestroyWithRequestor:theRequestor];

    if (!request) {
        return NO;
    }
    var response = [CPURLConnection sendSynchronousRequest:request];

    if (response[0] == 200) {
        [self resourceDidDestroyWithRequestor:theRequestor];
        return YES;
    } else {
		[self resourceDidNotDestroyWithRequestor:theRequestor];
        return NO;
    }
}

- (void)destroyAsync
{
	[self destroyAsyncWithRequestor:nil];
}

- (void)destroyAsyncWithRequestor:(id)theRequestor
{
	var request = [self resourceWillDestroyWithRequestor:theRequestor];

    if (!request) {
        return NO;
    }
	var connection = [[CPURLConnection alloc] initWithRequest:request delegate:[self class] startImmediately:NO];
	connection.requestor = theRequestor;
	connection.eventType = request.eventType;
	connection.modelTarget = self;
	[connection start];	
}

+ (void)connection:(CPURLConnection)aConnection didReceiveData:(CPString)aResponse
{
	switch (aConnection.eventType)
	{
		case 'Load':
			[self resourcesDidLoadWithResponse:aResponse andRequestor:aConnection.requestor];
			break;
		case 'Save':
			[aConnection.modelTarget resourceDidSaveWithResponse:aResponse andRequestor:aConnection.requestor];
			break;
		case 'Update':
			[aConnection.modelTarget resourceDidSaveWithResponse:aResponse andRequestor:aConnection.requestor];
			break;
		case 'Destroy':
			[aConnection.modelTarget resourceDidDestroyWithRequestor:aConnection.requestor];
			break;
	}
}

@end

@implementation CappuccinoRestful (Notifications)
{
	
}

// Resource Notifications
+ (CPURLRequest)resourceWillLoad
{
    return [self resourceWillLoad:nil];
}

// can handle a JSObject or a CPDictionary
+ (CPURLRequest)resourceWillLoad:(id)params
{
    var path             = [self resourcePath];
        //notificationName = [self className] + "CollectionWillLoad";

    if (params) {
        if (params.isa && [params isKindOfClass:CPDictionary]) {
            path += ("?" + [CPString paramaterStringFromCPDictionary:params]);
        } else {
            path += ("?" + [CPString paramaterStringFromJSON:params]);
        }
    }

    if (!path) {
        return nil;
    }

    var request = [CPURLRequest requestJSONWithURL:path];
    [request setHTTPMethod:@"GET"];

    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceWillLoad object:self];

    return request;
}

+ (id)resourceDidLoad:(CPString)aResponse
{
    var response         = [aResponse toJSON],
        attributes       = response[[self railsName]],
        //notificationName = [self className] + "ResourceDidLoad",
        resource         = [self new];
    [resource setAttributes:attributes];	
    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceDidLoad	 object:resource];
    return resource;
}

// Resourcess notifications
// can handle a JSObject or a CPDictionary
+ (CPURLRequest)resourcesWillLoadWithParameters:(id)params andRequestor:(id)theRequestor
{
    var path             = [self resourcePath];
        //notificationName = [self className] + "CollectionWillLoad";

    if (params) {
        if (params.isa && [params isKindOfClass:CPDictionary]) {
            path += ("?" + [CPString paramaterStringFromCPDictionary:params]);
        } else {
            path += ("?" + [CPString paramaterStringFromJSON:params]);
        }
    }

    if (!path) {
        return nil;
    }

	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventType:@"Load"];
	[notificationInfo setEventData:nil];

    var request = [CPURLRequest requestJSONWithURL:path];
	request.eventType = [notificationInfo eventType];
    [request setHTTPMethod:@"GET"];


    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourcesWillLoad object:self];

    return request;
}

+ (CPArray)resourcesDidLoadWithResponse:(CPString)aResponse andRequestor:(id)theRequestor
{
    var resourceArray    = [CPArray array];
        //notificationName = [self className] + "CollectionDidLoad";
    if ([[aResponse stringByTrimmingWhitespace] length] > 0) {
        var collection = [aResponse toJSON];

		if (collection.length != null)
		{
			for (var i = 0; i < collection.length; i++) {
	            var resource   = collection[i];
	            var attributes = resource[[self railsName]];
	            [resourceArray addObject:[self new:attributes]];
	        }
		}
		else
		{
			[resourceArray addObject:[self new:collection]];
		}        
    }
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventType:@"Load"];
	[notificationInfo setEventData:resourceArray];
    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourcesDidLoad object:self];
    return resourceArray;
}

- (CPURLRequest)resourceWillSaveWithRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventData:self];

    if (identifier) {
        var path             = [[self class] resourcePath] + "/" + identifier;
       	[notificationInfo setEventType:@"Update"];
    } else {
        var path             = [[self class] resourcePath];
		[notificationInfo setEventType:@"Create"];
    }

    if (!path) {
        return nil;
    }

    var request = [CPURLRequest requestJSONWithURL:path];
	request.eventType = [notificationInfo eventType];

    [request setHTTPMethod:identifier ? @"PUT" : @"POST"];
    [request setHTTPBody:[CPString JSONFromObject:[self attributes]]];

    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceWillSave object:self];
    return request;
}

- (void)resourceDidSaveWithResponse:(CPString)aResponse andRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	
    if ([aResponse length] > 1)
    {
        var response    = [aResponse toJSON],
            attributes  = response[[[self class] railsName]];
    }

    if (identifier) {
        [notificationInfo setEventType:@"Update"];
    } else {
        [notificationInfo setEventType:@"Create"];
    }

    [self setAttributes:attributes];
	[notificationInfo setEventData:self];
    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceDidSave object:self];
}

- (void)resourceDidNotSaveWithResponse:(CPString)aResponse andRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventData:aResponse];
	
    // TODO - do something with errors
    if (identifier) {
        [notificationInfo setEventType:@"Update"];
    } else {
		[notificationInfo setEventType:@"Create"];
    }
    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceDidNotSave object:self];
}

- (CPURLRequest)resourceWillDestroyWithRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventData:[identifier]];
	[notificationInfo setEventType:@"Destroy"];

    var path             = [[self class] resourcePath] + "/" + identifier;

    if (!path) {
        return nil;
    }

    var request = [CPURLRequest requestJSONWithURL:path];
	request.eventType = "Destroy";
    [request setHTTPMethod:@"DELETE"];

    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceWillDestroy object:self];
    return request;
}

- (void)resourceDidDestroyWithRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventData:[identifier]];
	[notificationInfo setEventType:@"Destroy"];

    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceDidDestroy object:self];
}

- (void)resourceDidNotDestroyWithRequestor:(id)theRequestor
{
	[notificationInfo setRequestor:theRequestor];
	[notificationInfo setModelName:[self className]];
	[notificationInfo setEventData:[identifier]];
	[notificationInfo setEventType:@"Delete"];
	
    [[CPNotificationCenter defaultCenter] postNotificationName:CappuccinoRestfulResourceDidNotDestroy object:self];
}

@end