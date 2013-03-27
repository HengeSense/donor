/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaObject

+ (ItsBetaObject*) objectWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _external = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"int_params"]]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_external);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

/*--------------------------------------------------*/