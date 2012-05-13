/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

static BloodDonor *BloodDonorShared = nil;

/*--------------------------------------------------*/

@implementation BloodDonor

#pragma mark Property synthesize

@synthesize preference = mPreference;

#pragma mark -
#pragma mark Property setter/getter

- (void) setProfileUsername:(NSString*)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setUsername:value];
    }
}

- (NSString*) profileUsername
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user username];
    }
    return @"";
}

- (void) setProfilePassword:(NSString*)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setPassword:value];
    }
}

- (NSString*) profilePassword
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user password];
    }
    return @"";
}

- (void) setProfileName:(NSString*)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:value forKey:@"Name"];
    }
}

- (NSString*) profileName
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user objectForKey:@"Name"];
    }
    return @"";
}

- (void) setProfileSex:(BloodDonorSex)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"Sex"];
    }
}

- (BloodDonorSex) profileSex
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"Sex"] unsignedIntegerValue];
    }
    return BloodDonorSexUnknown;
}

- (void) setProfileBloodGroup:(BloodDonorGroup)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"BloodGroup"];
    }
}

- (BloodDonorGroup) profileBloodGroup
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"BloodGroup"] unsignedIntegerValue];
    }
    return BloodDonorGroupUnknown;
}

- (void) setProfileBloodRh:(BloodDonorRh)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"BloodRh"];
    }
}

- (BloodDonorRh) profileBloodRh
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"BloodRh"] unsignedIntegerValue];
    }
    return BloodDonorRhUnknown;
}

- (void) setProfileEvents:(NSArray*)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:value forKey:@"Events"];
    }
}

- (NSArray*) profileEvents
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user objectForKey:@"Events"];
    }
    return [NSArray array];
}

- (void) setPreferenceVerifyPassword:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"VerifyPassword"];
}

- (BOOL) preferenceVerifyPassword
{
    return [[mPreference objectForKey:@"VerifyPassword"] boolValue];
}

- (void) setPreferenceShowPushNotice:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"ShowPushNotice"];
}

- (BOOL) preferenceShowPushNotice
{
    return [[mPreference objectForKey:@"ShowPushNotice"] boolValue];
}

- (void) setPreferenceSearchBloodGroup:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"SearchBloodGroup"];
}

- (BOOL) preferenceSearchBloodGroup
{
    return [[mPreference objectForKey:@"SearchBloodGroup"] boolValue];
}

- (void) setPreferenceCalendarReminders:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"CalendarReminders"];
}

- (BOOL) preferenceCalendarReminders
{
    return [[mPreference objectForKey:@"CalendarReminders"] boolValue];
}

- (void) setPreferenceCalendarCloseEvent:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"CalendarCloseEvent"];
}

- (BOOL) preferenceCalendarCloseEvent
{
    return [[mPreference objectForKey:@"CalendarCloseEvent"] boolValue];
}

- (void) setPreferenceBloodUsePlatelets:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"BloodUsePlatelets"];
}

- (BOOL) preferenceBloodUsePlatelets
{
    return [[mPreference objectForKey:@"BloodUsePlatelets"] boolValue];
}

- (void) setPreferenceBloodUseWhole:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"BloodUseWhole"];
}

- (BOOL) preferenceBloodUseWhole
{
    return [[mPreference objectForKey:@"BloodUseWhole"] boolValue];
}

- (void) setPreferenceBloodUsePlasma:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"BloodUsePlasma"];
}

- (BOOL) preferenceBloodUsePlasma
{
    return [[mPreference objectForKey:@"BloodUsePlasma"] boolValue];
}

#pragma mark -
#pragma mark Singleton

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

#pragma mark -
#pragma mark Parse application

- (BOOL) isAuthenticated
{
    return [[PFUser currentUser] isAuthenticated];
}

- (void) setApplicationId:(NSString*)applicationId 
                clientKey:(NSString*)clientKey
{
    [Parse setApplicationId:applicationId
                  clientKey:clientKey];
}

#pragma mark -
#pragma mark Parse authentication

- (void) signUpWithUsername:(NSString*)username
                   password:(NSString*)password
                       name:(NSString*)name
                        sex:(BloodDonorSex)sex
                 bloodGroup:(BloodDonorGroup)bloodGroup
                    bloodRh:(BloodDonorRh)bloodRh
                     target:(id)target
                    success:(SEL)success
                    failure:(SEL)failure
{
    PFUser *user = [PFUser user];
    if(user != nil)
    {
        [user setUsername:username];
        [user setPassword:password];
        [user setObject:name forKey:@"Name"];
        [user setObject:[NSNumber numberWithUnsignedInteger:sex] forKey:@"Sex"];
        [user setObject:[NSNumber numberWithUnsignedInteger:bloodGroup] forKey:@"BloodGroup"];
        [user setObject:[NSNumber numberWithUnsignedInteger:bloodRh] forKey:@"BloodRh"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(error != nil)
            {
                if([target respondsToSelector:success] == YES)
                {
                    [target performSelector:success withObject:self];
                }
            }
            else
            {
                if([target respondsToSelector:failure] == YES)
                {
                    [target performSelector:failure withObject:error];
                }
            }
        }];
    }
}

- (void) logInWithUsername:(NSString*)username
                  password:(NSString*)password
                    target:(id)target
                   success:(SEL)success
                   failure:(SEL)failure
{
    [PFUser logInWithUsernameInBackground:username
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if(user != nil)
                                        {
                                            if([target respondsToSelector:success] == YES)
                                            {
                                                [target performSelector:success withObject:self];
                                            }
                                        }
                                        else
                                        {
                                            if([target respondsToSelector:failure] == YES)
                                            {
                                                [target performSelector:failure withObject:error];
                                            }
                                        }
                                    }];
}

- (void) logOut
{
    [PFUser logOut];
}

#pragma mark -

+ (id) allocWithZone:(NSZone*)zone
{
    return [[self shared] retain];
}

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        mPreference = [[PFObject objectWithClassName:@"Preference"] retain];
    }
    return self;
}

- (void) dealloc
{
    [mPreference release];
    [super dealloc];
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

@end

/*--------------------------------------------------*/

@implementation BloodDonorEvent

#pragma mark Property setter/getter

- (void) setDate:(NSDate*)value
{
    [self setObject:value forKey:@"Date"];
}

- (NSDate*) date
{
    return [self objectForKey:@"Date"];
}

- (void) setType:(BloodDonorEventType)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"Type"];
}

- (BloodDonorEventType) type
{
    return [[self objectForKey:@"Type"] unsignedIntegerValue];
}

- (void) setDelivery:(BloodDonorEventDelivery)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"Delivery"];
}

- (BloodDonorEventDelivery) delivery
{
    return [[self objectForKey:@"Delivery"] unsignedIntegerValue];
}

- (void) setNotice:(BloodDonorEventNotice)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"Notice"];
}

- (BloodDonorEventNotice) notice
{
    return [[self objectForKey:@"Notice"] unsignedIntegerValue];
}

- (void) setAnalysisResult:(BOOL)value
{
    [self setObject:[NSNumber numberWithBool:value] forKey:@"AnalysisResult"];
}

- (BOOL) analysisResult
{
    return [[self objectForKey:@"AnalysisResult"] boolValue];
}

- (void) setComment:(NSString*)value
{
    [self setObject:value forKey:@"Comment"];
}

- (NSString*) comment
{
    return [self objectForKey:@"Comment"];
}

#pragma mark -

@end

/*--------------------------------------------------*/
