/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaBadge

@synthesize ID = mID;
@synthesize name = mName;
@synthesize title = mTitle;
@synthesize description = mDescription;
@synthesize imageURL = mImageURL;
@synthesize project = mProject;
@synthesize image = mImage;

+ (ItsBetaBadge*) badgeWithID:(NSString*)ID
                         name:(NSString*)name
                        title:(NSString*)title
                  description:(NSString*)description
                     imageURL:(NSString*)imageURL
                      project:(ItsBetaProject*)project
{
    return [[[self alloc] initWithID:ID
                                name:name
                               title:title
                         description:description
                            imageURL:imageURL
                             project:project] autorelease];
}

- (id) initWithID:(NSString*)ID
             name:(NSString*)name
            title:(NSString*)title
      description:(NSString*)description
         imageURL:(NSString*)imageURL
          project:(ItsBetaProject*)project
{
    self = [super init];
    if(self != nil)
    {
        mID = [ID retain];
        mName = [name retain];
        mTitle = [title retain];
        mDescription = [description retain];
        mImageURL = [imageURL retain];
        mProject = [project retain];
        mImage = [[ItsBetaImage imageWithFileName:mImageURL] retain];
        _aviability = NO;
    }
    return self;
}

- (void) dealloc
{
    [mImage release];
    [mProject release];
    [mImageURL release];
    [mDescription release];
    [mTitle release];
    [mName release];
    [mID release];
    [super dealloc];
}

@end

/*--------------------------------------------------*/