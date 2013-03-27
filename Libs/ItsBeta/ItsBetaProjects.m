/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaProjects

@synthesize list = mList;

+ (ItsBetaProjects*) projects
{
    return [[[self alloc] init] autorelease];
}

+ (ItsBetaProjects*) projectsWithProject:(ItsBetaProject*)project
{
    return [[[self alloc] initWithProject:project] autorelease];
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        mList = [[NSMutableArray arrayWithCapacity:32] retain];
    }
    return self;
}

- (id) initWithProject:(ItsBetaProject*)project
{
    self = [super init];
    if(self != nil)
    {
        mList = [[NSMutableArray arrayWithObject:project] retain];
    }
    return self;
}

- (void) dealloc
{
    [mList release];
    [super dealloc];
}

- (void) addProject:(ItsBetaProject*)project
{
    [mList addObject:project];
}
- (void) removeProject:(ItsBetaProject*)project
{
    [mList removeObject:project];
}

- (void) removeProjectByID:(NSString*)projectID
{
    NSUInteger index = 0;
    for(ItsBetaProject* project in mList)
    {
        if([[project ID] isEqualToString:projectID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (ItsBetaProject*) projectAtID:(NSString*)projectID
{
    for(ItsBetaProject* project in mList)
    {
        if([[project ID] isEqualToString:projectID] == YES)
        {
            return project;
        }
    }
    return nil;
}

- (ItsBetaProject*) projectAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/