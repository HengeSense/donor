/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaParams : NSObject

@synthesize ID = mID;
@synthesize keys = mKeys;

+ (ItsBetaParams*) paramsWithID:(NSString*)ID
                           keys:(NSArray*)keys
{
    return [[[self alloc] initWithID:ID
                                keys:keys] autorelease];
}

- (id) initWithID:(NSString*)ID
             keys:(NSArray*)keys
{
    self = [super init];
    if(self != nil)
    {
        mID = [ID retain];
        mKeys = [keys retain];
    }
    return self;
}

- (void) dealloc
{
    [mKeys release];
    [mID release];
    [super dealloc];
}

@end

/*--------------------------------------------------*/