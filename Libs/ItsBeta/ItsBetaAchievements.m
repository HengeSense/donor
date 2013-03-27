/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaAchievements

@synthesize list = mList;

+(ItsBetaAchievements* )sharedItsBetaAchievements
{
    if(sharedItsBetaAchievements == nil)
    {
        @synchronized(self)
        {
            if(sharedItsBetaAchievements == nil)
            {
                sharedItsBetaAchievements = [[self alloc] init];
            }
        }
    }
    return sharedItsBetaAchievements;
}

+ (ItsBetaAchievements*) achievements
{
    return [[[self alloc] init] autorelease];
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

- (void) dealloc
{
    [mList release];
    [super dealloc];
}

- (void) addAchievement:(ItsBetaAchievement*)achievement
{
    [mList addObject:achievement];
}
- (void) removeAchievement:(ItsBetaAchievement*)achievement
{
    [mList removeObject:achievement];
}

- (void) removeAchievementByID:(NSString*)achievementID
{
    NSUInteger index = 0;
    for(ItsBetaAchievement* achievement in mList)
    {
        if([[achievement ID] isEqualToString:achievementID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (ItsBetaAchievement*) achievementAtID:(NSString*)achievementID
{
    for(ItsBetaAchievement* achievement in mList)
    {
        if([[achievement ID] isEqualToString:achievementID] == YES)
        {
            return achievement;
        }
    }
    return nil;
}

- (ItsBetaAchievement*) achievementAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/

ItsBetaAchievements* sharedItsBetaAchievements = nil;

/*--------------------------------------------------*/