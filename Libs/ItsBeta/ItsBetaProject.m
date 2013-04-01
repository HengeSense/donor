/*--------------------------------------------------*/

#import "ItsBetaProject.h"
#import "ItsBetaFastCache.h"
#import "ItsBetaRest.h"
#import "ItsBetaQueue.h"
#import "ItsBetaApi.h"
#import "ItsBeta.h"

/*--------------------------------------------------*/

#import "UIColor+ItsBeta.h"
#import "CIColor+ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaProject () {
    NSDate* _lastUpdateTypes;
    NSDate* _lastUpdateTemplates;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaProject

+ (ItsBetaProject*) projectWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _Id = NS_SAFE_RETAIN([coder decodeObjectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([coder decodeObjectForKey:@"name"]);
        _categoryName = NS_SAFE_RETAIN([coder decodeObjectForKey:@"category_name"]);
        _title = NS_SAFE_RETAIN([coder decodeObjectForKey:@"title"]);
        _color = NS_SAFE_RETAIN([coder decodeObjectForKey:@"color"]);
        _lastUpdateTypes = NS_SAFE_RETAIN([coder decodeObjectForKey:@"last_update_object_types"]);
        _objectTypes = NS_SAFE_RETAIN([coder decodeObjectForKey:@"object_types"]);
        _lastUpdateTemplates = NS_SAFE_RETAIN([coder decodeObjectForKey:@"last_update_object_templates"]);
        _objectTemplates = NS_SAFE_RETAIN([coder decodeObjectForKey:@"object_templates"]);
    }
    return self;
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
        _color = NS_SAFE_RETAIN([CIColor colorWithHexString:[dictionary objectForKey:@"color"]]);
#endif
        _objectTypes = NS_SAFE_RETAIN([ItsBetaObjectTypeCollection collection]);
        _objectTemplates = NS_SAFE_RETAIN([ItsBetaObjectTemplateCollection collection]);
    }
    return self;
}

- (void) dealloc {
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_categoryName);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_title);
    NS_SAFE_RELEASE(_color);
    NS_SAFE_RELEASE(_objectTypes);
    NS_SAFE_RELEASE(_objectTemplates);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) encodeWithCoder:(NSCoder*)coder {
    [coder encodeObject:_Id forKey:@"id"];
    [coder encodeObject:_name forKey:@"name"];
    [coder encodeObject:_categoryName forKey:@"category_name"];
    [coder encodeObject:_title forKey:@"title"];
    [coder encodeObject:_color forKey:@"color"];
    [coder encodeObject:_lastUpdateTypes forKey:@"last_update_object_types"];
    [coder encodeObject:_objectTypes forKey:@"object_types"];
    [coder encodeObject:_lastUpdateTemplates forKey:@"last_update_object_templates"];
    [coder encodeObject:_objectTemplates forKey:@"object_templates"];
}



- (void) synchronizeASync {
    [ItsBetaQueue runASync:^{
        [self synchronizeSync];
    }];
}

- (void) synchronizeSync {
    NSDate* lastUpdateTypes = [NSDate date];
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       lastUpdate:_lastUpdateTypes
                          project:self
                      objectTypes:^(ItsBetaObjectTypeCollection *collection, NSError *error) {
                          [_objectTypes setObjectTypes:collection];
                      }];
    NS_SAFE_SETTER(_lastUpdateTypes, lastUpdateTypes);

    NSDate* lastUpdateTemplates = [NSDate date];
    [ItsBetaApi requestServiceURL:[ItsBeta applicationServiceURL]
                      accessToken:[ItsBeta applicationAccessToken]
                       lastUpdate:_lastUpdateTemplates
                          project:self
                  objectTemplates:^(ItsBetaObjectTemplateCollection *collection, NSError *error) {
                      [_objectTemplates setObjectTemplates:collection];
                  }];
    NS_SAFE_SETTER(_lastUpdateTemplates, lastUpdateTemplates);

    for(ItsBetaObjectTemplate* objectTemplate in _objectTemplates) {
        [[objectTemplate image] synchronizeSync];
    }
}

@end

/*--------------------------------------------------*/

@interface ItsBetaProjectCollection () {
    NSMutableDictionary* _items;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaProjectCollection

+ (ItsBetaProjectCollection*) collection {
    return NS_SAFE_RETAIN([[self alloc] init]);
}

+ (ItsBetaProjectCollection*) collectionWithArray:(NSArray*)array {
    return NS_SAFE_RETAIN([[self alloc] initWithArray:array]);
}

- (NSUInteger) count {
    return [_items count];
}

- (id) initWithCoder:(NSCoder*)coder {
    self = [super init];
    if(self != nil) {
        _items = NS_SAFE_RETAIN([coder decodeObjectForKey:@"projects"]);
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
            [self addProject:[ItsBetaProject projectWithDictionary:item]];
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
    [coder encodeObject:_items forKey:@"projects"];
}

- (NSString*) description {
    return [_items description];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState*)state objects:(id __unsafe_unretained [])objects count:(NSUInteger)count {
    return [[_items allValues] countByEnumeratingWithState:state objects:objects count:count];
}

- (void) addProject:(ItsBetaProject*)project {
    [_items setObject:project forKey:[project Id]];
}

- (void) setProjects:(ItsBetaProjectCollection*)projects {
    for(ItsBetaProject* project in projects) {
        [_items setObject:project forKey:[project Id]];
    }
}

- (ItsBetaProject*) projectAtIndex:(NSUInteger)index {
    return [[_items allValues] objectAtIndex:index];
}

- (ItsBetaProject*) projectAtId:(NSString*)Id {
    return [_items objectForKey:Id];
}

- (ItsBetaProject*) projectAtName:(NSString*)name {
    for(ItsBetaProject* project in _items) {
        if([[project name] isEqualToString:name] == YES) {
            return project;
        }
    }
    return nil;
}

@end

/*--------------------------------------------------*/