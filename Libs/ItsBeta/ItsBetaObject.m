/*--------------------------------------------------*/

#import "ItsBetaObject.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaObject

+ (ItsBetaObject*) objectWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([coder decodeObjectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([coder decodeObjectForKey:@"name"]);
        _objectTemplateId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"_object_template_id"]);
        _external = NS_SAFE_RETAIN([coder decodeObjectForKey:@"external"]);
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _objectTemplateId = NS_SAFE_RETAIN([dictionary objectForKey:@"objtemplate_id"]);
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

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_Id forKey:@"id"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_objectTemplateId forKey:@"_object_template_id"];
    [coder encodeObject:_external forKey:@"external"];
}

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectCollection () {
    NSMutableDictionary* _items;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaObjectCollection

+ (ItsBetaObjectCollection*) collection {
    return NS_SAFE_RETAIN([[self alloc] init]);
}

+ (ItsBetaObjectCollection*) collectionWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (NSUInteger) count {
    return [_items count];
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"objects"]);
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
            [self addObject:[ItsBetaObject objectWithDictionary:item]];
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
    [coder encodeObject:_items forKey:@"objects"];
}

- (NSString*) description {
    return [_items description];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])objects count:(NSUInteger)count {
    return [[_items allValues] countByEnumeratingWithState:state objects:objects count:count];
}

- (void) addObject:(ItsBetaObject*)object {
    [_items setObject:object forKey:[object Id]];
}

- (void) setObjects:(ItsBetaObjectCollection*)objects {
    for(ItsBetaObject* object in objects) {
        [_items setObject:object forKey:[object Id]];
    }
}

- (ItsBetaObject*) objectAtIndex:(NSUInteger)index {
    return [[_items allValues] objectAtIndex:index];
}

- (ItsBetaObject*) objectAtId:(NSString*)Id {
    return [_items objectForKey:Id];
}

- (ItsBetaObjectCollection*) objectsWithObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate {
    ItsBetaObjectCollection* collection = [ItsBetaObjectCollection collection];
    for(ItsBetaObject* object in _items) {
        if([[object objectTemplateId] isEqualToString:[objectTemplate Id]] == YES) {
            [collection addObject:object];
        }
    }
    return collection;
}

- (void) removeAllObjects {
    [_items removeAllObjects];
}

@end

/*--------------------------------------------------*/