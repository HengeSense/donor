//
//  HSHTTPControl.m
//  Invitro
//
//  Created by Eugine Korobovsky on 30.01.13.
//  Copyright (c) 2013 hintsolutions. All rights reserved.
//

#import "HSHTTPControl.h"

@implementation HSSingleReqest

@synthesize requestID, userInfo;
@synthesize url, method, requestData, contentType, xRequestWith;
@synthesize responseCode, resultData;
@synthesize delegate, callback, errorCallback, topLevelDelegate, topLevelCallback, topLevelErrorCallback;

- (id)init{
    self = [super init];
    
    if(self){
        requestID = nil;
        userInfo = nil;
        url = nil;
        method = HSHTTPMethodGET;
        requestData = nil;
        contentType = nil;
        xRequestWith = nil;
        
        responseCode = 0;
        resultData = nil;
        
        urlRequest = nil;
        urlConnection = nil;
        
        delegate = nil;
        callback = nil;
        errorCallback = nil;
        topLevelDelegate = nil;
        topLevelCallback = nil;
        topLevelErrorCallback = nil;
    };
    
    return self;
};

- (id)initWithID:(id)reqID{
    self = [self init];
    if(self){
        [self setRequestID:reqID];
    };
    
    return self;
};

- (id)initWithURL:(NSString*)_url andDelegate:(id)_delegate andCallbackFunction:(SEL)_callback andErrorCallBackFunction:(SEL)_errorCallback{
    self = [self init];
    if(self){
        NSString *urlStr = [[NSString alloc] initWithString:_url];
        self.url = urlStr;
        //[urlStr release];
        self.delegate = _delegate;
        self.callback = _callback;
        self.errorCallback = _errorCallback;
    };
    
    return self;
};



- (void)dealloc{
    delegate = nil;
    //if(url) [url release];
    //if(requestID) [requestID release];
    //if(userInfo) [userInfo release];
    
    //[super dealloc];
};


- (NSMutableData*)generatePostBodyForImage:(UIImage*)img{
    NSMutableData *body = [NSMutableData data];
    NSString *boundaryStr = @"14042802788933518161505795335";
    
    [body appendData:[[NSString stringWithFormat:@"-----------------------------%@\r\n", boundaryStr] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"user_avatar\"; filename=\"photo.jpg\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: image/jpeg\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:UIImageJPEGRepresentation(img, 0.75)];
    [body appendData:[[NSString stringWithFormat:@"\r\n-----------------------------%@--\r\n", boundaryStr] dataUsingEncoding:NSUTF8StringEncoding]];
    
    return body;
};

- (BOOL)sendRequest{
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
    urlRequest   = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    urlRequest.timeoutInterval = 30.0;
    if(contentType) [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    if(xRequestWith)[urlRequest setValue:xRequestWith forHTTPHeaderField:@"X-Request-With"];
    switch(method){
        case HSHTTPMethodGET:
            [urlRequest setHTTPMethod:@"GET"];
            //[urlRequest setHTTPBody:[requestData dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES]];
            //[urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
            break;
        case HSHTTPMethodPOST:
            [urlRequest setHTTPMethod:@"POST"];
            if(requestData!=nil){
                if([[requestData class] isSubclassOfClass:[NSString class]]){
                    [urlRequest setHTTPBody:[[requestData stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:NO]];
                    
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                }else if([[requestData class] isSubclassOfClass:[UIImage class]]){
                    [urlRequest setHTTPBody:[self generatePostBodyForImage:(UIImage*)requestData]];
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [UIImageJPEGRepresentation(requestData, 0.75) length]] forHTTPHeaderField:@"Content-Length"];
                }else if([[requestData class] isSubclassOfClass:[NSData class]]){
                    [urlRequest setHTTPBody:requestData];
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                }else{
                    NSLog(@"HSRequest ERROR: cannot set HTTP body ([requestData class]=%@)", [[requestData class] description]);
                };
            };
            //if(contentType)[urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
            break;
        default:
            [urlRequest setHTTPMethod:@"GET"];
            break;
    };
    
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
	
	if (urlConnection) {
		resultData =[[NSMutableData alloc] init];
	} else {
        NSLog(@"HSSingleRequest: Cannot create a connection!");
        
		return NO;
	};
    
    return YES;
};

- (BOOL)sendRequestWithoutAddingPercentEscapes{
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
    urlRequest   = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    urlRequest.timeoutInterval = 30.0;
    if(contentType) [urlRequest setValue:contentType forHTTPHeaderField:@"Content-Type"];
    if(xRequestWith)[urlRequest setValue:xRequestWith forHTTPHeaderField:@"X-Request-With"];
    switch(method){
        case HSHTTPMethodGET:
            [urlRequest setHTTPMethod:@"GET"];
            break;
        case HSHTTPMethodPOST:
            [urlRequest setHTTPMethod:@"POST"];
            if(requestData!=nil){
                if([[requestData class] isSubclassOfClass:[NSString class]]){
                    [urlRequest setHTTPBody:[requestData dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:NO]];
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                }else if([[requestData class] isSubclassOfClass:[UIImage class]]){
                    [urlRequest setHTTPBody:[self generatePostBodyForImage:(UIImage*)requestData]];
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [UIImageJPEGRepresentation(requestData, 0.75) length]] forHTTPHeaderField:@"Content-Length"];
                }else if([[requestData class] isSubclassOfClass:[NSData class]]){
                    [urlRequest setHTTPBody:requestData];
                    [urlRequest setValue:[NSString stringWithFormat:@"%d", [requestData length]] forHTTPHeaderField:@"Content-Length"];
                }else{
                    NSLog(@"HSRequest ERROR: cannot set HTTP body ([requestData class]=%@)", [[requestData class] description]);
                };
            };
            break;
        default:
            [urlRequest setHTTPMethod:@"GET"];
            break;
    };
    
	urlConnection = [[NSURLConnection alloc] initWithRequest:urlRequest delegate:self];
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
	
	if (urlConnection) {
		resultData =[[NSMutableData alloc] init];
	} else {
        NSLog(@"HSSingleRequest: Cannot create a connection!");
        
		return NO;
	};
    
    return YES;
};

- (BOOL)stopRequest{
    //if(urlConnection) [urlConnection release];
    
    return YES;
};

+ (NSString*)addPerfectPercentEscapes:(NSString*)str{
    return @"";
    //return [(NSString*)CFURLCreateStringByAddingPercentEscapes(NULL, (CFStringRef)str, NULL, (CFStringRef)@"/:;$&@\",?[]{}#%^+=\\|<>€£¥•", kCFStringEncodingUTF8) autorelease];
};

#pragma mark -
#pragma mark URL Loading Delegate functions

- (void)connection:(NSURLConnection*)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge*)challenge {
    NSLog(@"Authentication required!");
};

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSHTTPURLResponse*)response
{
    responseCode = [response statusCode];
    
    [resultData setLength:0];
    
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data {
    [resultData appendData:data];
    
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
}

- (void)connection:(NSURLConnection*)connection didFailWithError:(NSError*)error
{
    //[connection release];
    //[resultData release];
	
	//[urlRequest release];
	
    // inform the user
    NSLog(@"HSSingleRequest: Connection failed! Error - %@ %@", [error localizedDescription], [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
	
	if(errorCallback) {
		[delegate performSelector:errorCallback withObject:self withObject:error];
	}
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    
	if(delegate && callback) {
		if([delegate respondsToSelector:self.callback]) {
            [delegate performSelector:self.callback withObject:self withObject:resultData];
		} else {
			NSLog(@"HSSingleRequest: Cannot call delegate (%@) callback function", [[delegate class] description]);
		}
	}
    
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
	
	// release the connection, and the data object
	//[urlConnection release];
    //[resultData release];
	//[urlRequest release];
    
    //NSLog(@"uRequest info: address = 0x%x, retainCount = %d", self, [self retainCount]);
}

@end

