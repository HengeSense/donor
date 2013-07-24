//
//  HSFoursquareError.h
//  Donor
//
//  Created by Sergey Seroshtan on 24.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const HSFoursquareErrorDomain;

typedef enum {
    HSFoursquareErrorType_InvalidAuth = 0,
    HSFoursquareErrorType_ParamError,
    HSFoursquareErrorType_EndpointError,
    HSFoursquareErrorType_NotAuthorized,
    HSFoursquareErrorType_RateLimitExceeded,
    HSFoursquareErrorType_Deprecated,
    HSFoursquareErrorType_ServerError,
    HSFoursquareErrorType_Other
} HSFoursquareErrorType;

@interface HSFoursquareError : NSError

/// @name Initialization
- (id)initWithResponse:(id)response;
+ (id)errorWithResponse:(id)response;

/// @name Info

/**
 * @return http status code
 */
- (NSUInteger)statusCode;

/**
 * @return error type received from the server
 */
- (HSFoursquareErrorType)type;

/**
 * @return additional information about error, intendent to the developer
 */
- (NSString *)detail;

/**
 * @return localized message conformed to the errorType
 */
- (NSString *)message;

/**
 * @return localized string received from the server intended for the client to display back to the user directly
 */
- (NSString *)serverMessage;

@end
