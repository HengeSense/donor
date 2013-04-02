/*--------------------------------------------------*/

#import "NSURL+ItsBeta.h"
#import "NSString+ItsBeta.h"

/*--------------------------------------------------*/

@implementation NSURL (ItsBeta)

- (NSMutableDictionary*) queryComponents {
    return [[self query] dictionaryFromQueryComponents];
}

- (NSMutableDictionary*) fragmentComponents {
    return [[self fragment] dictionaryFromQueryComponents];
}

@end

/*--------------------------------------------------*/