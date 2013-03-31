/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaCategory

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _title = NS_SAFE_RETAIN([dictionary objectForKey:@"display_name"]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_title);
    NS_SAFE_RELEASE(_name);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<ItsBetaCategory> api_name = '%@', display_name = '%@'", _name, _title];
}

@end

/*--------------------------------------------------*/
