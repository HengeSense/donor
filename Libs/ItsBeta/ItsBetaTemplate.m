/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaTemplate

+ (ItsBetaTemplate*) templateWithDictionary:(NSDictionary*)dictionary {
    return NS_SAFE_RETAIN([[self alloc] initWithDictionary:dictionary]);
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

- (NSString*) description {
    return [NSString stringWithFormat:@"<ItsBetaType> api_name = '%@', project_id = '%@', objtype_id = '%@'", _name, _projectId, _typeId];
}

@end

/*--------------------------------------------------*/