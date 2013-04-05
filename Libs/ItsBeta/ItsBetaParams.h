/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaParams : NSObject< NSCoding >

@property(nonatomic, readonly) NSDictionary* items;

+ (ItsBetaParams*) paramsWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (NSString*) valueAtName:(NSString*)name;

@end

/*--------------------------------------------------*/
