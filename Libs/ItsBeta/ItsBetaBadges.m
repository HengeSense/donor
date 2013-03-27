/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaBadges

@synthesize list = mList;

+ (ItsBetaBadges*) sharedBadges
{
    if(sharedBadges == nil)
    {
        @synchronized(self)
        {
            if(sharedBadges == nil)
            {
                sharedBadges = [[self alloc] init] ;
            }
        }
    }
    return sharedBadges;
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

- (void) addBadge:(ItsBetaBadge*)badge
{
    [mList addObject:badge];
}

-(void) addBadge:(ItsBetaBadge *)newBadge replaceIfExist:(BOOL)replaceIfExist
{
    if(replaceIfExist == YES)
    {
        for(ItsBetaBadge* badge in mList)
        {
            if([[newBadge ID] isEqualToString:[badge ID]] == YES)
            {
                [self removeBadge:badge];
                [self addBadge:newBadge];
                return;
            }
        }
    }
    [self addBadge:newBadge];
}

- (void) removeBadge:(ItsBetaBadge*)badge
{
    [mList removeObject:badge];
}

- (void) removeBadgeByID:(NSString*)badgeID
{
    NSUInteger index = 0;
    for(ItsBetaBadge* badge in mList)
    {
        if([[badge ID] isEqualToString:badgeID] == YES)
        {
            [mList removeObjectAtIndex:index];
        }
        index++;
    }
}

- (ItsBetaBadge*) badgeAtID:(NSString*)badgeID
{
    for(ItsBetaBadge* badge in mList)
    {
        if([[badge ID] isEqualToString:badgeID] == YES)
        {
            return badge;
        }
    }
    return nil;
}

- (ItsBetaBadge*) badgeAt:(NSUInteger)index
{
    return [mList objectAtIndex:index];
}

@end

/*--------------------------------------------------*/

ItsBetaBadges* sharedBadges = nil;