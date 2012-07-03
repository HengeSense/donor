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
    BloodDonorSexUnknown = -1,
    BloodDonorSexMan = 0,
    BloodDonorSexWoman = 1
};

typedef NSInteger BloodDonorSex;

/*--------------------------------------------------*/

enum
{
    BloodDonorGroupUnknown = -1,
    BloodDonorGroupI = 0,
    BloodDonorGroupII = 1,
    BloodDonorGroupIII = 2,
    BloodDonorGroupIV = 3
};

typedef NSInteger BloodDonorGroup;

/*--------------------------------------------------*/

enum
{
    BloodDonorRhUnknown = -1,
    BloodDonorRhPos = 0,
    BloodDonorRhNeg = 1
};

typedef NSInteger BloodDonorRh;

/*--------------------------------------------------*/

typedef void (^BloodDonorSuccessBlock)();
typedef void (^BloodDonorFailureBlock)(NSError *error);

/*--------------------------------------------------*/

@interface BloodDonor : NSObject
{
    NSUserDefaults *mPreference;
}

@property (nonatomic, readwrite, assign) NSString *profileUsername;
@property (nonatomic, readwrite, assign) NSString *profilePassword;
@property (nonatomic, readwrite, assign) NSString *profileName;
@property (nonatomic, readwrite, assign) BloodDonorSex profileSex;
@property (nonatomic, readwrite, assign) BloodDonorGroup profileBloodGroup;
@property (nonatomic, readwrite, assign) BloodDonorRh profileBloodRh;
@property (nonatomic, readwrite, assign) NSArray *profileEvents;

@property (nonatomic, readwrite, assign) BOOL preferenceVerifyPassword;
@property (nonatomic, readwrite, assign) BOOL preferenceShowPushNotice;
@property (nonatomic, readwrite, assign) BOOL preferenceSearchBloodGroup;
@property (nonatomic, readwrite, assign) BOOL preferenceCalendarReminders;
@property (nonatomic, readwrite, assign) BOOL preferenceCalendarCloseEvent;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUsePlatelets;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUseWhole;
@property (nonatomic, readwrite, assign) BOOL preferenceBloodUsePlasma;

+ (BloodDonor*) shared;

- (void) setApplicationId:(NSString*)applicationId 
                clientKey:(NSString*)clientKey;

- (BOOL) isAuthenticated;

- (void) signUpWithUsername:(NSString*)username
                   password:(NSString*)password
                       name:(NSString*)name
                        sex:(BloodDonorSex)sex
                 bloodGroup:(BloodDonorGroup)bloodGroup
                    bloodRh:(BloodDonorRh)bloodRh
                    success:(BloodDonorSuccessBlock)success
                    failure:(BloodDonorFailureBlock)failure;

- (void) logInWithUsername:(NSString*)username
                  password:(NSString*)password
                   success:(BloodDonorSuccessBlock)success
                   failure:(BloodDonorFailureBlock)failure;

- (void) logOut;

@end

/*--------------------------------------------------*/

enum
{
    BloodDonorEventTypeAnalysis,
    BloodDonorEventTypeDelivery
};

typedef NSInteger BloodDonorEventType;

/*--------------------------------------------------*/

enum
{
    BloodDonorEventDeliveryPlatelets,
    BloodDonorEventDeliveryPlasma,
    BloodDonorEventDeliveryWhole
};

typedef NSInteger BloodDonorEventDelivery;

/*--------------------------------------------------*/

enum
{
    BloodDonorEventNoticeMin3,
    BloodDonorEventNoticeMin5,
    BloodDonorEventNoticeMin10,
    BloodDonorEventNoticeMin15
};

typedef NSInteger BloodDonorEventNotice;

/*--------------------------------------------------*/

@interface BloodDonorEvent : PFObject

@property (nonatomic, readwrite, retain) NSDate *date;
@property (nonatomic, readwrite, assign) BloodDonorEventType type;
@property (nonatomic, readwrite, assign) BloodDonorEventDelivery delivery;
@property (nonatomic, readwrite, assign) BloodDonorEventNotice notice;
@property (nonatomic, readwrite, assign) BOOL analysisResult;
@property (nonatomic, readwrite, retain) NSString *comment;

@end

/*--------------------------------------------------*/
