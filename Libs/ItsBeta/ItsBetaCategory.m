/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaCategory

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithName:[dictionary objectForKey:@"api_name"] title:[dictionary objectForKey:@"display_name"]]);
}

+ (ItsBetaCategory*) categoryWithName:(NSString*)name title:(NSString*)title {
    return NS_SAFE_RETAIN([[self alloc] initWithName:name title:title]);
}

- (id) initWithName:(NSString*)name title:(NSString*)title {
    self = [super init];
    if(self != nil) {
        _name = NS_SAFE_RETAIN(name);
        _title = NS_SAFE_RETAIN(title);
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

@end

/*--------------------------------------------------*/
