/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaParams : NSObject< NSCoding >

@property(nonatomic, readonly) NSDictionary* dictionary;

+ (ItsBetaParams*) paramsWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

@end

/*--------------------------------------------------*/
