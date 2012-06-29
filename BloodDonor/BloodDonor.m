/*--------------------------------------------------*/

#import "BloodDonor.h"

/*--------------------------------------------------*/

static BloodDonor *BloodDonorShared = nil;

/*--------------------------------------------------*/

@implementation BloodDonor

#pragma mark Property

#pragma mark -
#pragma mark Property override

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
        [user setObject:value forKey:@"name"];
    }
}

- (NSString*) profileName
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user objectForKey:@"name"];
    }
    return @"";
}

- (void) setProfileSex:(BloodDonorSex)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"sex"];
    }
}

- (BloodDonorSex) profileSex
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"sex"] unsignedIntegerValue];
    }
    return BloodDonorSexMan;
}

- (void) setProfileBloodGroup:(BloodDonorGroup)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"bloodGroup"];
    }
}

- (BloodDonorGroup) profileBloodGroup
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"bloodGroup"] unsignedIntegerValue];
    }
    return BloodDonorGroupI;
}

- (void) setProfileBloodRh:(BloodDonorRh)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"bloodRh"];
    }
}

- (BloodDonorRh) profileBloodRh
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [[user objectForKey:@"bloodRh"] unsignedIntegerValue];
    }
    return BloodDonorRhPos;
}

- (void) setProfileEvents:(NSArray*)value
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        [user setObject:value forKey:@"events"];
    }
}

- (NSArray*) profileEvents
{
    PFUser *user = [PFUser currentUser];
    if([user isAuthenticated] == YES)
    {
        return [user objectForKey:@"events"];
    }
    return [NSArray array];
}

- (void) setPreferenceVerifyPassword:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"verifyPassword"];
    [mPreference synchronize];
}

- (BOOL) preferenceVerifyPassword
{
    return [[mPreference objectForKey:@"verifyPassword"] boolValue];
}

- (void) setPreferenceShowPushNotice:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"showPushNotice"];
    [mPreference synchronize];
}

- (BOOL) preferenceShowPushNotice
{
    return [[mPreference objectForKey:@"showPushNotice"] boolValue];
}

- (void) setPreferenceSearchBloodGroup:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"searchBloodGroup"];
    [mPreference synchronize];
}

- (BOOL) preferenceSearchBloodGroup
{
    return [[mPreference objectForKey:@"searchBloodGroup"] boolValue];
}

- (void) setPreferenceCalendarReminders:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"calendarReminders"];
    [mPreference synchronize];
}

- (BOOL) preferenceCalendarReminders
{
    return [[mPreference objectForKey:@"calendarReminders"] boolValue];
}

- (void) setPreferenceCalendarCloseEvent:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"calendarCloseEvent"];
    [mPreference synchronize];
}

- (BOOL) preferenceCalendarCloseEvent
{
    return [[mPreference objectForKey:@"calendarCloseEvent"] boolValue];
}

- (void) setPreferenceBloodUsePlatelets:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"bloodUsePlatelets"];
    [mPreference synchronize];
}

- (BOOL) preferenceBloodUsePlatelets
{
    return [[mPreference objectForKey:@"bloodUsePlatelets"] boolValue];
}

- (void) setPreferenceBloodUseWhole:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"bloodUseWhole"];
    [mPreference synchronize];
}

- (BOOL) preferenceBloodUseWhole
{
    return [[mPreference objectForKey:@"bloodUseWhole"] boolValue];
}

- (void) setPreferenceBloodUsePlasma:(BOOL)value
{
    [mPreference setObject:[NSNumber numberWithBool:value] forKey:@"bloodUsePlasma"];
    [mPreference synchronize];
}

- (BOOL) preferenceBloodUsePlasma
{
    return [[mPreference objectForKey:@"bloodUsePlasma"] boolValue];
}

#pragma mark -
#pragma mark Singleton

+ (BloodDonor*) shared
{
    @synchronized(self)
    {
        if(BloodDonorShared == nil)
        {
            BloodDonorShared = [[self alloc] init];
        }
    }
    return BloodDonorShared;
}

#pragma mark -
#pragma mark Parse application

- (void) setApplicationId:(NSString*)applicationId 
                clientKey:(NSString*)clientKey
{
    [Parse setApplicationId:applicationId
                  clientKey:clientKey];
}

#pragma mark -
#pragma mark Parse authentication

- (BOOL) isAuthenticated
{
    return [[PFUser currentUser] isAuthenticated];
}

- (void) signUpWithUsername:(NSString*)username
                   password:(NSString*)password
                       name:(NSString*)name
                        sex:(BloodDonorSex)sex
                 bloodGroup:(BloodDonorGroup)bloodGroup
                    bloodRh:(BloodDonorRh)bloodRh
                    success:(BloodDonorSuccessBlock)success
                    failure:(BloodDonorFailureBlock)failure
{
    PFUser *user = [PFUser user];
    if(user != nil)
    {
        [user setUsername:username];
        [user setPassword:password];
        [user setObject:name forKey:@"name"];
        [user setObject:[NSNumber numberWithUnsignedInteger:sex] forKey:@"sex"];
        [user setObject:[NSNumber numberWithUnsignedInteger:bloodGroup] forKey:@"bloodGroup"];
        [user setObject:[NSNumber numberWithUnsignedInteger:bloodRh] forKey:@"bloodRh"];
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if(succeeded == YES)
            {
                success();
            }
            else
            {
                failure(error);
            }
        }];
    }
}

- (void) logInWithUsername:(NSString*)username
                  password:(NSString*)password
                   success:(BloodDonorSuccessBlock)success
                   failure:(BloodDonorFailureBlock)failure
{
    [PFUser logInWithUsernameInBackground:username
                                 password:password
                                    block:^(PFUser *user, NSError *error) {
                                        if(user != nil)
                                        {
                                            success();
                                        }
                                        else
                                        {
                                            failure(error);
                                        }
                                    }];
}

- (void) logOut
{
    [PFUser logOut];
}

#pragma mark -

- (id) init
{
    self = [super init];
    if(self != nil)
    {
        mPreference = [NSUserDefaults standardUserDefaults];
    }
    return self;
}

@end

/*--------------------------------------------------*/

@implementation BloodDonorEvent

#pragma mark Property override

- (void) setDate:(NSDate*)value
{
    [self setObject:value forKey:@"date"];
}

- (NSDate*) date
{
    return [self objectForKey:@"date"];
}

- (void) setType:(BloodDonorEventType)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"type"];
}

- (BloodDonorEventType) type
{
    return [[self objectForKey:@"type"] unsignedIntegerValue];
}

- (void) setDelivery:(BloodDonorEventDelivery)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"delivery"];
}

- (BloodDonorEventDelivery) delivery
{
    return [[self objectForKey:@"delivery"] unsignedIntegerValue];
}

- (void) setNotice:(BloodDonorEventNotice)value
{
    [self setObject:[NSNumber numberWithUnsignedInteger:value] forKey:@"notice"];
}

- (BloodDonorEventNotice) notice
{
    return [[self objectForKey:@"notice"] unsignedIntegerValue];
}

- (void) setAnalysisResult:(BOOL)value
{
    [self setObject:[NSNumber numberWithBool:value] forKey:@"analysisResult"];
}

- (BOOL) analysisResult
{
    return [[self objectForKey:@"analysisResult"] boolValue];
}

- (void) setComment:(NSString*)value
{
    [self setObject:value forKey:@"comment"];
}

- (NSString*) comment
{
    return [self objectForKey:@"comment"];
}

#pragma mark -

@end

/*--------------------------------------------------*/
