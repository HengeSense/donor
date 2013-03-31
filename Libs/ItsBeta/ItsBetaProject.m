/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

#import "UIColor+ItsBeta.h"
#import "CIColor+ItsBeta.h"

/*--------------------------------------------------*/

@interface ItsBetaProject () {
    dispatch_queue_t _queue;
    NSMutableArray* _types;
    NSMutableArray* _templates;
}

@end

/*--------------------------------------------------*/

@implementation ItsBetaProject

- (NSArray*) types {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _types;
    });
    return result;
}

- (NSArray*) templates {
    __block NSArray* result = nil;
    dispatch_sync(_queue, ^{
        result = _templates;
    });
    return result;
}

+ (ItsBetaProject*) projectWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
}

- (id) initWithDictionary:(NSDictionary*)dictionary {
    self = [super init];
    if(self != nil) {
        _queue = dispatch_queue_create(ItsBetaDispatchQueue, nil);
        
        _Id = NS_SAFE_RETAIN([dictionary objectForKey:@"id"]);
        _name = NS_SAFE_RETAIN([dictionary objectForKey:@"api_name"]);
        _categoryName = NS_SAFE_RETAIN([dictionary objectForKey:@"category_name"]);
        _title = NS_SAFE_RETAIN([dictionary objectForKey:@"display_name"]);
        NSString* color = [dictionary objectForKey:@"color"];
        if([color isKindOfClass:[NSString class]] == YES) {
            if([color length] > 0) {
#if TARGET_OS_IPHONE
                _color = NS_SAFE_RETAIN([UIColor colorWithHexString:color]);
#else
                _color = NS_SAFE_RETAIN([CLColor colorWithHexString:color]);
#endif
            }
        }
        
        _types = NS_SAFE_RETAIN([NSMutableArray array]);
        _templates = NS_SAFE_RETAIN([NSMutableArray array]);
    }
    return self;
}

- (void) dealloc {
    dispatch_release(_queue);
    
    NS_SAFE_RELEASE(_Id);
    NS_SAFE_RELEASE(_categoryName);
    NS_SAFE_RELEASE(_name);
    NS_SAFE_RELEASE(_title);
    NS_SAFE_RELEASE(_color);
    
    NS_SAFE_RELEASE(_types);
    NS_SAFE_RELEASE(_templates);
    
    NS_SAFE_RELEASE(_currentPlayer);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) synchronize {
    dispatch_async(_queue, ^{
        [ItsBeta itsBetaTypesByProject:self
                              callback:^(NSArray* types, NSError* error) {
                                  [_types addObjectsFromArray:types];
                              }];
        for(ItsBetaType* type in _types) {
            if([[type templateCount] integerValue] > 0) {
                [ItsBeta itsBetaTemplatesByType:type
                                       callback:^(NSArray* templates, NSError* error) {
                                           [_templates addObjectsFromArray:templates];
                                       }];
            }
        }
        for(ItsBetaTemplate* template in _templates) {
            [[template image] synchronize:^(ItsBetaImage* image, NSError* error) {
            }];
        }
        if(_currentPlayer != nil) {
            [_currentPlayer synchronizeWithProject:self];
        }
    });
}

- (NSString*) description {
    return [NSString stringWithFormat:@"<ItsBetaProject> api_name = '%@', display_name = '%@', category_name = '%@'", _name, _title, _categoryName];
}

@end

/*--------------------------------------------------*/