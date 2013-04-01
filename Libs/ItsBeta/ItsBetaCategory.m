/*--------------------------------------------------*/

#import "ItsBetaCategory.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaCategory () {
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaCategory

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _name = NS_SAFE_RETAIN([coder decodeObjectForKey:@"name"]);
        _title = NS_SAFE_RETAIN([coder decodeObjectForKey:@"title"]);
    }
    return self;
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

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_title forKey:@"title"];
}

@end

/*--------------------------------------------------*/

@interface ItsBetaCategoryCollection () {
    NSMutableDictionary* _items;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaCategoryCollection

+ (ItsBetaCategoryCollection*) collection {
    return NS_SAFE_RETAIN([[self alloc] init]);
}

+ (ItsBetaCategoryCollection*) collectionWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (NSUInteger) count {
    return [_items count];
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"categories"]);
    }
    return self;
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([NSMutableDictionary dictionary]);
    }
    return self;
}

- (id) initWithArray:(NSArray*)array {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([NSMutableDictionary dictionary]);
        for(NSDictionary* item in array) {
            [self addCategory:[ItsBetaCategory categoryWithDictionary:item]];
        }
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_items);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_items forKey:@"categories"];
}

- (NSString*) description {
    return [_items description];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])objects count:(NSUInteger)count {
    return [[_items allValues] countByEnumeratingWithState:state objects:objects count:count];
}

- (void) addCategory:(ItsBetaCategory*)category {
    [_items setObject:category forKey:[category name]];
}

- (void) setCategories:(ItsBetaCategoryCollection*)categories {
    for(ItsBetaCategory* category in categories) {
        [_items setObject:category forKey:[category name]];
    }
}

- (ItsBetaCategory*) categoryAtIndex:(NSUInteger)index {
    return [[_items allValues] objectAtIndex:index];
}

- (ItsBetaCategory*) categoryAtName:(NSString*)name {
    return [_items objectForKey:name];
}

@end

/*--------------------------------------------------*/
