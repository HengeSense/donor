/*--------------------------------------------------*/

#import "ItsBeta.h"

/*--------------------------------------------------*/

@implementation ItsBetaUser

@synthesize type = mType;
@synthesize ID = mID;
@synthesize faceBookID = mFaceBookID;
@synthesize userFB = mUserFB;
@synthesize achievementActivated = mAchievementActivated;

+(ItsBetaUser* )sharedItsBetaUser
{
    if(sharedItsBetaUser == nil)
    {
        @synchronized(self)
        {
            if(sharedItsBetaUser == nil)
            {
                sharedItsBetaUser = [[self alloc] initWithType:ItsBetaUserTypeFacebook];
            }
        }
    }
    return sharedItsBetaUser;
}

- (NSString*) typeAsString
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook: return @"fb";
    }
    return @"";
}

+ (ItsBetaUser*) userWithType:(ItsBetaUserType)type
{
    return [[[self alloc] initWithType:type] autorelease];
}

- (id) initWithType:(ItsBetaUserType)type
{
    self = [super init];
    if(self != nil)
    {
        mType = type;
        mAchievementActivated = NO;
    }
    return self;
}

- (void) dealloc
{
    [mID release];
    [mFaceBookID release];
    [mUserFB release];
    [super dealloc];
}

- (BOOL) isLogin
{
    return [[FBSession activeSession] isOpen];
}

- (void) login:(ItsBetaCallbackLogin)callback
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook:
            [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_stream", @"publish_actions", nil]
                                               defaultAudience:FBSessionDefaultAudienceOnlyMe
                                                  allowLoginUI:YES
                                 completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                     switch(state)
                                     {
                                         case FBSessionStateOpen:
                                         case FBSessionStateOpenTokenExtended:
                                             [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary< FBGraphUser > *user, NSError *error) {
                                                 if(error == nil)
                                                 {
                                                     mFaceBookID = [[user id] retain];
                                                     mUserFB = [user retain];
                                                     [[ItsBeta sharedItsBeta] requestInternalUserIDByUser:self
                                                                                                 callback:^(NSString *internalUserID, NSError *error)
                                                     {
                                                         if(error == nil)
                                                         {
                                                             [self setID:internalUserID];
                                                             callback(nil);
                                                         }
                                                         else
                                                         {
                                                             if([[[error userInfo] objectForKey:@"status"] isEqualToString:@"305"] == YES)
                                                             {
                                                                 [self setID:@""];
                                                                 callback(nil);
                                                             }
                                                             else
                                                                 callback(error);
                                                         }
                                                     }];
                                                     
                                                 }
                                                 else
                                                 {
                                                     callback([[error userInfo] objectForKey:@"com.facebook.sdk:ErrorInnerErrorKey"]);
                                                 }
                                             }];
                                             break;
                                         case FBSessionStateClosedLoginFailed:
                                             [[FBSession activeSession] closeAndClearTokenInformation];
                                             error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                         code:ItsBetaErrorFacebookAuth
                                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                               @"Facebook.Fail.Session", NSLocalizedDescriptionKey,
                                                                               nil]];
                                             break;
                                         case FBSessionStateClosed:
                                             break;
                                         default:
                                             error = [NSError errorWithDomain:ItsBetaErrorDomain
                                                                         code:ItsBetaErrorFacebookAuth
                                                                     userInfo:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                               @"Facebook.Fail.Unknown", NSLocalizedDescriptionKey,
                                                                               nil]];
                                             break;
                                     }
                                     if(error != nil)
                                     {
                                         callback(error);
                                     }
                                 }];
        
        break;
    }
}

- (void) logout:(ItsBetaCallbackLogout)callback
{
    switch(mType)
    {
        case ItsBetaUserTypeFacebook:
            if([FBSession activeSession] != nil)
            {
                [[FBSession activeSession] closeAndClearTokenInformation];
                mFaceBookID = nil;
                mUserFB = nil;
                mAchievementActivated = NO;
            }
            break;
    }
    if(callback != nil)
    {
        callback(nil);
    }
}

+ (BOOL) handleOpenURL:(NSURL*)url
{
    return [[FBSession activeSession] handleOpenURL:url];
}

@end

/*--------------------------------------------------*/

ItsBetaUser * sharedItsBetaUser = nil;

/*--------------------------------------------------*/