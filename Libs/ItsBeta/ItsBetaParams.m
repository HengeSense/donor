/*--------------------------------------------------*/

#import "ItsBetaParams.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaParams () {
    NSMutableDictionary* _items;
}

- (void) internalInit;

@end

/*--------------------------------------------------*/

@implementation ItsBetaParams

+ (ItsBetaParams*) paramsWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        [self internalInit];
        
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"items"]);
    }
    return self;
}

- (id) initWithArray:(NSArray*)array {
    self = [super init];
    if(self != nil) {
        [self internalInit];
        
        _items = NS_SAFE_RETAIN([NSMutableDictionary dictionary]);
        for(NSDictionary* item in array) {
            NSString* name = [item objectForKey:@"pname"];
            if(name != nil) {
                NSString* type = [item objectForKey:@"ptype"];
                NSString* value = [item objectForKey:@"pvalue"];
                if(value != nil) {
                    [_items setObject:value forKey:name];
                } else if(type != nil) {
                    [_items setObject:type forKey:name];
                }
            }
        }
    }
    return self;
}

- (void) internalInit {
}

- (void) dealloc {
    NS_SAFE_RELEASE(_items);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_items forKey:@"items"];
}

@end

/*--------------------------------------------------*/