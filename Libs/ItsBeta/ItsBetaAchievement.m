/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaAchievement

@synthesize ID = mID;
@synthesize faceBookID = mFaceBookID;
@synthesize badgeID = mBadgeID;
@synthesize details = mDetails;
@synthesize activated = mActivated;
@synthesize user = mUser;
@synthesize badge = mBadge;

+ (ItsBetaAchievement*) achievementWithID:(NSString*)ID
                            faceBookID:(NSString*)faceBookID
                                  badgeID:(NSString*)badgeID
                                  details:(NSString*)details
                                activated:(BOOL)activated
                                     user:(ItsBetaUser*)user
                                    badge:(ItsBetaBadge*)badge
{
    return [[[self alloc] initWithID:ID
                        faceBookID:(NSString*)faceBookID
                             badgeID:badgeID
                             details:details
                           activated:activated
                                user:user
                               badge:badge] autorelease];
}

- (id) initWithID:(NSString*)ID
       faceBookID:(NSString*)faceBookID
          badgeID:(NSString*)badgeID
          details:(NSString*)details
        activated:(BOOL)activated
             user:(ItsBetaUser*)user
            badge:(ItsBetaBadge*)badge
{
    self = [super init];
    if(self != nil)
    {
        mID = [ID retain];
        mFaceBookID = [faceBookID retain];
        mBadgeID = [badgeID retain];
        mDetails = [details retain];
        mActivated = activated;
        mUser = [user retain];
        mBadge = [badge retain];
    }
    return self;
}

- (void) dealloc
{
    [mBadge release];
    [mFaceBookID release];
    [mUser release];
    [mDetails release];
    [mBadgeID release];
    [mID release];
    [super dealloc];
}

@end

/*--------------------------------------------------*/