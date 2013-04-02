/*--------------------------------------------------*/

#import "ItsBetaObjectType.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaObjectType

+ (ItsBetaObjectType*) objectTypeWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([coder decodeObjectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([coder decodeObjectForKey:@"name"]);
        _projectId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"project_id"]);
        _parentId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"parent_id"]);
        _internal = NS_SAFE_RETAIN([coder decodeObjectForKey:@"internal"]);
        _external = NS_SAFE_RETAIN([coder decodeObjectForKey:@"external"]);
        _shared = NS_SAFE_RETAIN([coder decodeObjectForKey:@"shared"]);
        _templateCount = NS_SAFE_RETAIN([coder decodeObjectForKey:@"template_count"]);
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _projectId = NS_SAFE_RETAIN([dictionary objectForKey:@"project_id"]);
        _parentId = NS_SAFE_RETAIN([dictionary objectForKey:@"parent_id"]);
        _internal = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"my_ext_params"]]);
        _external = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"my_int_params"]]);
        _shared = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"my_shr_params"]]);
        
        _templateCount = NS_SAFE_RETAIN([dictionary objectForKey:@"templates_count"]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_projectId);
    NS_SAFE_RELEASE(_parentId);
    NS_SAFE_RELEASE(_internal);
    NS_SAFE_RELEASE(_external);
    NS_SAFE_RELEASE(_shared);
    
    NS_SAFE_RELEASE(_templateCount);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_Id forKey:@"id"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_projectId forKey:@"project_id"];
    [coder encodeObject:_parentId forKey:@"parent_id"];
    [coder encodeObject:_internal forKey:@"internal"];
    [coder encodeObject:_external forKey:@"external"];
    [coder encodeObject:_shared forKey:@"shared"];
    [coder encodeObject:_templateCount forKey:@"template_count"];
}

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectTypeCollection () {
    NSMutableDictionary* _items;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaObjectTypeCollection

+ (ItsBetaObjectTypeCollection*) collection {
    return NS_SAFE_RETAIN([[self alloc] init]);
}

+ (ItsBetaObjectTypeCollection*) collectionWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (NSUInteger) count {
    return [_items count];
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"object_types"]);
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
            [self addObjectType:[ItsBetaObjectType objectTypeWithDictionary:item]];
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
    [coder encodeObject:_items forKey:@"object_types"];
}

- (NSString*) description {
    return [_items description];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])objects count:(NSUInteger)count {
    return [[_items allValues] countByEnumeratingWithState:state objects:objects count:count];
}

- (void) addObjectType:(ItsBetaObjectType*)objectType {
    [_items setObject:objectType forKey:[objectType Id]];
}

- (void) setObjectTypes:(ItsBetaObjectTypeCollection*)objectTypes {
    for(ItsBetaObjectType* objectType in objectTypes) {
        [_items setObject:objectType forKey:[objectType Id]];
    }
}

- (ItsBetaObjectType*) objectTypeAtIndex:(NSUInteger)index {
    return [[_items allValues] objectAtIndex:index];
}

- (ItsBetaObjectType*) objectTypeAtId:(NSString*)Id {
    return [_items objectForKey:Id];
}

- (ItsBetaObjectType*) objectTypeAtName:(NSString*)name {
    for(ItsBetaObjectType* objectType in _items) {
        if([[objectType name] isEqualToString:name] == YES) {
            return objectType;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/