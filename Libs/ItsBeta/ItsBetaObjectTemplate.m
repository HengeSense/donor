/*--------------------------------------------------*/

#import "ItsBetaObjectTemplate.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaObjectTemplate

+ (ItsBetaObjectTemplate*) objectTemplateWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([coder decodeObjectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([coder decodeObjectForKey:@"name"]);
        _projectId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"project_id"]);
        _typeId = NS_SAFE_RETAIN([coder decodeObjectForKey:@"type_id"]);
        _imageURL = NS_SAFE_RETAIN([coder decodeObjectForKey:@"image_url"]);
        _internal = NS_SAFE_RETAIN([coder decodeObjectForKey:@"internal"]);
        _shared = NS_SAFE_RETAIN([coder decodeObjectForKey:@"shared"]);
        _objectCount = NS_SAFE_RETAIN([coder decodeObjectForKey:@"object_count"]);
        _image = NS_SAFE_RETAIN([coder decodeObjectForKey:@"image"]);
    }
    return self;
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _projectId = NS_SAFE_RETAIN([dictionary objectForKey:@"project_id"]);
        _typeId = NS_SAFE_RETAIN([dictionary objectForKey:@"objtype_id"]);
        _imageURL = NS_SAFE_RETAIN([dictionary objectForKey:@"pic"]);
        _internal = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"ext_params"]]);
        _shared = NS_SAFE_RETAIN([ItsBetaParams paramsWithArray:[dictionary objectForKey:@"shr_params"]]);
        _objectCount = NS_SAFE_RETAIN([dictionary objectForKey:@"objs_counts"]);
        _image = NS_SAFE_RETAIN([ItsBetaImage imageWithImageURL:_imageURL]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_projectId);
    NS_SAFE_RELEASE(_typeId);
    NS_SAFE_RELEASE(_imageURL);
    NS_SAFE_RELEASE(_internal);
    NS_SAFE_RELEASE(_shared);
    
    NS_SAFE_RELEASE(_objectCount);
    
    NS_SAFE_RELEASE(_image);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_Id forKey:@"id"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_projectId forKey:@"project_id"];
    [coder encodeObject:_typeId forKey:@"type_id"];
    [coder encodeObject:_imageURL forKey:@"image_url"];
    [coder encodeObject:_internal forKey:@"internal"];
    [coder encodeObject:_shared forKey:@"shared"];
    [coder encodeObject:_objectCount forKey:@"object_count"];
    [coder encodeObject:_image forKey:@"image"];
}

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectTemplateCollection () {
    NSMutableDictionary* _items;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaObjectTemplateCollection

+ (ItsBetaObjectTemplateCollection*) collection {
    return NS_SAFE_RETAIN([[self alloc] init]);
}

+ (ItsBetaObjectTemplateCollection*) collectionWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (NSUInteger) count {
    return [_items count];
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"object_templates"]);
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
            [self addObjectTemplate:[ItsBetaObjectTemplate objectTemplateWithDictionary:item]];
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
    [coder encodeObject:_items forKey:@"object_templates"];
}

- (NSString*) description {
    return [_items description];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])objects count:(NSUInteger)count {
    return [[_items allValues] countByEnumeratingWithState:state objects:objects count:count];
}

- (void) addObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate {
    [_items setObject:objectTemplate forKey:[objectTemplate Id]];
}

- (void) setObjectTemplates:(ItsBetaObjectTemplateCollection*)objectTemplates {
    for(ItsBetaObjectTemplate* objectTemplate in objectTemplates) {
        [_items setObject:objectTemplate forKey:[objectTemplate Id]];
    }
}

- (ItsBetaObjectTemplate*) objectTemplateAtIndex:(NSUInteger)index {
    return [[_items allValues] objectAtIndex:index];
}

- (ItsBetaObjectTemplate*) objectTemplateAtId:(NSString*)Id {
    return [_items objectForKey:Id];
}

@end

/*--------------------------------------------------*/