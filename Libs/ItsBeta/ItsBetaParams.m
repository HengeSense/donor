/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaParams

+ (ItsBetaParams*) paramsWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (id) initWithArray:(NSArray*)array {
    self = [super init];
    if(self != nil) {
        NSMutableArray* keys = [NSMutableArray array];
        NSMutableArray* objects = [NSMutableArray array];
        for(NSDictionary* item in array) {
            NSString* name = [item objectForKey:@"pname"];
            NSString* type = [item objectForKey:@"ptype"];
            NSString* value = [item objectForKey:@"pvalue"];
            if(name != nil) {
                [keys addObject:name];
            }
            if(value != nil) {
                [objects addObject:value];
            } else if(type != nil) {
                [objects addObject:type];
            }
        }
        _dictionary = NS_SAFE_RETAIN([NSDictionary dictionaryWithObjects:objects forKeys:keys]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_dictionary);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

/*--------------------------------------------------*/