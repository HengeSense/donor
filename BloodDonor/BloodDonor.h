/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

#import <Parse/Parse.h>

/*--------------------------------------------------*/

#define BD_PARSE_APPLICATION_ID @"EIpakVdZblHedhqgxMgiEVnIGCRGvWdy9v8gkKZu"
#define BD_PARSE_CLIENT_KEY @"uNarhakSf1on8lJjrAVs1VWmPlG1D6ZJf9dO5QZY"

/*--------------------------------------------------*/

enum
{
    BloodDonorSexUnknown,
    BloodDonorSexMan,
    BloodDonorSexWoman
};

typedef NSInteger BloodDonorSex;

/*--------------------------------------------------*/

enum
{
    BloodDonorGroupUnknown,
    BloodDonorGroupI,
    BloodDonorGroupII,
    BloodDonorGroupIII,
    BloodDonorGroupIV
};

typedef NSInteger BloodDonorGroup;

/*--------------------------------------------------*/

enum
{
    BloodDonorRhUnknown,
    BloodDonorRhPos,
    BloodDonorRhNeg
};

typedef NSInteger BloodDonorRh;

/*--------------------------------------------------*/

@interface BloodDonor : NSObject
{
    PFObject *mPreference;
}

@property (nonatomic, readonly, retain) PFObject *preference;

@property (nonatomic, readwrite, assign) NSString *profileUsername;
@property (nonatomic, readwrite, assign) NSString *profilePassword;
@property (nonatomic, readwrite, assign) NSString *profileName;
@property (nonatomic, readwrite, assign) BloodDonorSex profileSex;
@property (nonatomic, readwrite, assign) BloodDonorGroup profileBloodGroup;
@property (nonatomic, readwrite, assign) BloodDonorRh profileBloodRh;

@property (nonatomic, readwrite, assign) BOOL preferenceVerifyPassword;
@property (nonatomic, readwrite, assign) BOOL preferenceShowPushNotice;
@property (nonatomic, readwrite, assign) BOOL preferenceSearchBloodGroup;
@property (nonatomic, readwrite, assign) BOOL preferenceCalendarReminders;
@property (nonatomic, readwrite, assign) BOOL preferenceCalendarCloseEvent;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUsePlatelets;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUseWhole;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUsePlasma;

- (void) setApplicationId:(NSString*)applicationId 
                clientKey:(NSString*)clientKey;

- (void) signUpWithUsername:(NSString*)username
                   password:(NSString*)password
                       name:(NSString*)name
                        sex:(BloodDonorSex)sex
                 bloodGroup:(BloodDonorGroup)bloodGroup
                    bloodRh:(BloodDonorRh)bloodRh
                     target:(id)target
                    success:(SEL)success
                    failure:(SEL)failure;

- (void) logInWithUsername:(NSString*)username
                  password:(NSString*)password
                    target:(id)target
                   success:(SEL)success
                   failure:(SEL)failure;

- (void) logOut;

@end

/*--------------------------------------------------*/
