/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@protocol ItsBetaGraphUser

@property (readonly, nonatomic) NSString* id;
@property (readonly, nonatomic) NSString* name;
@property (readonly, nonatomic) NSString* firstName;
@property (readonly, nonatomic) NSString* middleName;
@property (readonly, nonatomic) NSString* lastName;
@property (readonly, nonatomic) NSString* link;
@property (readonly, nonatomic) NSString* username;
@property (readonly, nonatomic) NSString* birthday;

@end

/*--------------------------------------------------*/

@interface NSDictionary (ItsBetaGraphUser) < ItsBetaGraphUser >

+ (NSDictionary< ItsBetaGraphUser >*) graphUser;

@end

/*--------------------------------------------------*/

@interface NSMutableDictionary (ItsBetaGraphUser) < ItsBetaGraphUser >

+ (NSMutableDictionary< ItsBetaGraphUser >*) graphUser;

@end

/*--------------------------------------------------*/
