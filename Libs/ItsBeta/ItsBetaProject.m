/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaProject

@synthesize ID = mID;
@synthesize name = mName;
@synthesize title = mTitle;
@synthesize category = mCategory;

+ (ItsBetaProject*) projectWithID:(NSString*)ID
                             name:(NSString*)name
                            title:(NSString*)title
                         category:(ItsBetaCategory*)category
{
    return [[[self alloc] initWithID:ID
                                name:name
                               title:title
                            category:category] autorelease];
}

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
         category:(ItsBetaCategory*)category
{
    self = [super init];
    if(self != nil)
    {
        mID = [ID retain];
        mName = [name retain];
        mTitle = [title retain];
        mCategory = [category retain];
    }
    return self;
}

- (void) dealloc
{
    [mCategory release];
    [mTitle release];
    [mName release];
    [mID release];
    [super dealloc];
}

@end

/*--------------------------------------------------*/