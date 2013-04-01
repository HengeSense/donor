/*--------------------------------------------------*/

#import "ItsBetaGraphUser.h"

/*--------------------------------------------------*/

@implementation NSDictionary (ItsBetaGraphUser)

+ (NSDictionary< ItsBetaGraphUser >*) graphUser {
    return (NSDictionary< ItsBetaGraphUser >*)[self new];
}

- (NSString*) id {
    return [self objectForKey:@"id"];
}

- (NSString*) name {
    return [self objectForKey:@"name"];
}

- (NSString*) firstName {
    return [self objectForKey:@"first_name"];
}

- (NSString*) middleName {
    return [self objectForKey:@"middle_name"];
}

- (NSString*) lastName {
    return [self objectForKey:@"last_name"];
}

- (NSString*) link {
    return [self objectForKey:@"link"];
}

- (NSString*) username {
    return [self objectForKey:@"username"];
}

- (NSString*) birthday {
    return [self objectForKey:@"birthday"];
}

@end

/*--------------------------------------------------*/

@implementation NSMutableDictionary (ItsBetaGraphUser)

+ (NSMutableDictionary< ItsBetaGraphUser >*) graphUser {
    return (NSMutableDictionary< ItsBetaGraphUser >*)[self new];
}

- (NSString*) id {
    return [self objectForKey:@"id"];
}

- (NSString*) name {
    return [self objectForKey:@"name"];
}

- (NSString*) firstName {
    return [self objectForKey:@"first_name"];
}

- (NSString*) middleName {
    return [self objectForKey:@"middle_name"];
}

- (NSString*) lastName {
    return [self objectForKey:@"last_name"];
}

- (NSString*) link {
    return [self objectForKey:@"link"];
}

- (NSString*) username {
    return [self objectForKey:@"username"];
}

- (NSString*) birthday {
    return [self objectForKey:@"birthday"];
}

@end

/*--------------------------------------------------*/
