/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

#import "UIColor+ItsBeta.h"
#import "CIColor+ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaProject

+ (ItsBetaProject*) projectWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _categoryName = NS_SAFE_RETAIN([dictionary objectForKey:@"category_name"]);
        _title = NS_SAFE_RETAIN([dictionary objectForKey:@"display_name"]);
#if TARGET_OS_IPHONE
        _color = NS_SAFE_RETAIN([UIColor colorWithHexString:[dictionary objectForKey:@"color"]]);
#else
        _color = NS_SAFE_RETAIN([CLColor colorWithHexString:[dictionary objectForKey:@"color"]]);
#endif
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_categoryName);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_title);
    NS_SAFE_RELEASE(_color);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

@end

/*--------------------------------------------------*/