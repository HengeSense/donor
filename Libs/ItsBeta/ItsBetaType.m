/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaType

+ (ItsBetaType*) typeWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
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

- (NSString*) description {
    return [NSString stringWithFormat:@"<ItsBetaType> api_name = '%@', project_id = '%@', parent_id = '%@'", _name, _projectId, _parentId];
}

@end

/*--------------------------------------------------*/