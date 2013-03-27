/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaCategories

+ (ItsBetaCategories*) categories {
    return [[[self alloc] init] autorelease];
}

+ (ItsBetaCategories*) categoriesWithCategory:(ItsBetaCategory*)category {
    return [[[self alloc] initWithCategory:category] autorelease];
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _list = [[NSMutableArray arrayWithCapacity:32] retain];
    }
    return self;
}

- (id) initWithCategory:(ItsBetaCategory*)category {
    self = [super init];
    if(self != nil) {
        _list = [[NSMutableArray arrayWithObject:category] retain];
    }
    return self;
}

- (void) dealloc {
    [_list release];
    [super dealloc];
}

- (void) addCategory:(ItsBetaCategory*)category {
    [_list addObject:category];
}

- (void) removeCategory:(ItsBetaCategory*)category {
    [_list removeObject:category];
}

- (void) removeCategoryByName:(NSString*)categoryName {
    NSUInteger index = 0;
    for(ItsBetaCategory* category in _list) {
        if([[category name] isEqualToString:categoryName] == YES) {
            [_list removeObjectAtIndex:index];
            break;
        }
        index++;
    }
}

- (ItsBetaCategory*) categoryAtName:(NSString*)categoryName {
    for(ItsBetaCategory* category in _list) {
        if([[category name] isEqualToString:categoryName] == YES) {
            return category;
        }
    }
    return nil;
}

- (ItsBetaCategory*) categoryAt:(NSUInteger)index {
    return [_list objectAtIndex:index];
}

@end

/*--------------------------------------------------*/
