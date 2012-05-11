/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

#import "HSUserDefaults.h"

/*--------------------------------------------------*/

static BloodDonor *BloodDonorShared = nil;

/*--------------------------------------------------*/

@implementation BloodDonor

@synthesize login = mLogin;
@synthesize password = mPassword;
@synthesize name = mName;
@synthesize sex = mSex;
@synthesize bloodGroup = mBloodGroup;
@synthesize bloodRh = mBloodRh;
@synthesize verifyPassword = mVerifyPassword;
@synthesize showPushNotice = mShowPushNotice;
@synthesize searchBloodGroup = mSearchBloodGroup;
@synthesize calendarReminders = mCalendarReminders;
@synthesize calendarCloseEvent = mCalendarCloseEvent;
@synthesize bloodUsePlatelets = mBloodUsePlatelets;
@synthesize bloodUseWhole = mBloodUseWhole;
@synthesize bloodUsePlasma = mBloodUsePlasma;

+ (BloodDonor*) shared
{
    @synchronized(self)
    {
        if(BloodDonorShared == nil)
        {
            BloodDonorShared = [NSAllocateObject([self class], 0, NULL) init];
        }
    }
    return BloodDonorShared;
}

+ (id) allocWithZone:(NSZone*)zone
{
    return [[self shared] retain];
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
        if(user != nil)
        {
            mLogin = [user stringForKey:@"Login" asDefaults:@""];
            mPassword = [user stringForKey:@"Password" asDefaults:@""];
            mName = [user stringForKey:@"Name" asDefaults:@""];
            mSex = [user integerForKey:@"Sex" asDefaults:BloodDonorSexUnknown];
            mBloodGroup = [user integerForKey:@"BloodGroup" asDefaults:BloodDonorGroupUnknown];
            mBloodRh = [user integerForKey:@"BloodRh" asDefaults:BloodDonorRhUnknown];
            mVerifyPassword = [user boolForKey:@"VerifyPassword" asDefaults:NO];
            mShowPushNotice = [user boolForKey:@"ShowPushNotice" asDefaults:NO];
            mSearchBloodGroup = [user boolForKey:@"SearchBloodGroup" asDefaults:NO];
            mCalendarReminders = [user boolForKey:@"CalendarReminders" asDefaults:NO];
            mCalendarCloseEvent = [user boolForKey:@"CalendarCloseEvent" asDefaults:NO];
            mBloodUsePlatelets = [user boolForKey:@"BloodUsePlatelets" asDefaults:NO];
            mBloodUseWhole = [user boolForKey:@"BloodUseWhole" asDefaults:NO];
            mBloodUsePlasma = [user boolForKey:@"BloodUsePlasma" asDefaults:NO];
        }
    }
    return self;
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (id) autorelease
{
    return self;
}

- (void) loginWithInternet
{
}

- (void) logoutWithInternet
{
}

- (void) synchronize
{
    NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
    if(user != nil)
    {
        [user setObject:mLogin forKey:@"Login"];
        [user setObject:mPassword forKey:@"Password"];
        [user setObject:mName forKey:@"Name"];
        [user setInteger:mSex forKey:@"Sex"];
        [user setInteger:mBloodGroup forKey:@"BloodGroup"];
        [user setInteger:mBloodRh forKey:@"BloodRh"];
        [user setBool:mVerifyPassword forKey:@"VerifyPassword"];
        [user setBool:mShowPushNotice forKey:@"ShowPushNotice"];
        [user setBool:mSearchBloodGroup forKey:@"SearchBloodGroup"];
        [user setBool:mCalendarReminders forKey:@"CalendarReminders"];
        [user setBool:mCalendarCloseEvent forKey:@"CalendarCloseEvent"];
        [user setBool:mBloodUsePlatelets forKey:@"BloodUsePlatelets"];
        [user setBool:mBloodUseWhole forKey:@"BloodUseWhole"];
        [user setBool:mBloodUsePlasma forKey:@"BloodUsePlasma"];
    }
}

@end

/*--------------------------------------------------*/
