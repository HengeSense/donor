//
//  HSFoursquareError.m
//  Donor
//
//  Created by Sergey Seroshtan on 24.07.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSFoursquareError.h"

NSString * const HSFoursquareErrorDomain = @"HSFoursquareErrorDomain";

@interface HSFoursquareError ()

@property (nonatomic, assign) NSUInteger statusCode;
@property (nonatomic, assign) HSFoursquareErrorType type;
@property (nonatomic, strong) NSString *detail;
@property (nonatomic, strong) NSString *serverMessage;

@end

@implementation HSFoursquareError

#pragma mark - Initialization
- (id)initWithResponse:(id)response {
    if ((self = [super initWithDomain:HSFoursquareErrorDomain code:0 userInfo:nil]) == nil) {
        return nil;
    }
    
    if (response == nil) {
        self.type = HSFoursquareErrorType_Other;
    } else if ([response isKindOfClass:[NSDictionary class]]) {
        self.statusCode = [[response valueForKeyPath:@"meta.code"] unsignedIntegerValue];
        self.type = [self errorTypeFromString:[response valueForKeyPath:@"meta.errorType"]];
        self.detail = [response valueForKeyPath:@"meta.errorDetail"];
        self.serverMessage = [response valueForKeyPath:@"meta.errorMessage"];
    } else if ([response isKindOfClass:[NSString class]]) {
        self.serverMessage = response;
        self.type = HSFoursquareErrorType_Other;
    }
    
    return self;
}

+ (id)errorWithResponse:(id)response {
    return [[self alloc] initWithResponse:response];
}

#pragma mark - Info
- (NSString *)message {
    return [self messageFromErrorType:self.type];
}

#pragma mark - NSObject overridings
- (NSString *)description {
    return self.serverMessage != nil ? self.serverMessage : self.message;
}

- (NSString *)localizedDescription {
    return self.serverMessage != nil ? self.serverMessage : self.message;
}

#pragma mark - Private
- (HSFoursquareErrorType)errorTypeFromString:(NSString *)typeString {
    if ([typeString isEqualToString:@"invalid_auth"]) {
        return HSFoursquareErrorType_InvalidAuth;
    } else if ([typeString isEqualToString:@"param_error"]) {
        return HSFoursquareErrorType_ParamError;
    } else if ([typeString isEqualToString:@"endpoint_error"]) {
        return HSFoursquareErrorType_EndpointError;
    } else if ([typeString isEqualToString:@"not_authorized"]) {
        return HSFoursquareErrorType_NotAuthorized;
    } else if ([typeString isEqualToString:@"rate_limit_exceeded"]) {
        return HSFoursquareErrorType_RateLimitExceeded;
    } else if ([typeString isEqualToString:@"deprecated"]) {
        return HSFoursquareErrorType_Deprecated;
    } else if ([typeString isEqualToString:@"server_error"]) {
        return HSFoursquareErrorType_ServerError;
    }
    return HSFoursquareErrorType_Other;
}

- (NSString *)messageFromErrorType:(HSFoursquareErrorType)errorType {
    switch (errorType) {
        case HSFoursquareErrorType_InvalidAuth:
            return @"Авторизация не была выполнена, или ее срок истек.";
        case HSFoursquareErrorType_ParamError:
            return @"Обязательный параметр запроса опущен или плохо сформирован.";
        case HSFoursquareErrorType_EndpointError:
            return @"Путь запроса не существует.";
        case HSFoursquareErrorType_NotAuthorized:
            return @"Нет прав доступа на данную операцию.";
        case HSFoursquareErrorType_RateLimitExceeded:
            return @"Ограничение пропускной способности на этот час превышен.";
        case HSFoursquareErrorType_Deprecated:
            return @"Запрос использует устаревшую фунциональность.";
        case HSFoursquareErrorType_ServerError:
            return @"Внутреняя ошибка сервера.";
        case HSFoursquareErrorType_Other:
        default:
            return @"Неизвестная ошибка.";
    }
}

@end
