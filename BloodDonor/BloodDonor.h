/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

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
    NSString* mLogin;
    NSString* mPassword;
    NSString* mName;
    BloodDonorSex mSex;
    BloodDonorGroup mBloodGroup;
    BloodDonorRh mBloodRh;
    BOOL mVerifyPassword;
    BOOL mShowPushNotice;
    BOOL mSearchBloodGroup;
    BOOL mCalendarReminders;
    BOOL mCalendarCloseEvent;
    BOOL mBloodUsePlatelets;
    BOOL mBloodUseWhole;
    BOOL mBloodUsePlasma;
}

@property (nonatomic, retain) NSString* login;
@property (nonatomic, retain) NSString* password;
@property (nonatomic, retain) NSString* name;
@property (nonatomic, assign) BloodDonorSex sex;
@property (nonatomic, assign) BloodDonorGroup bloodGroup;
@property (nonatomic, assign) BloodDonorRh bloodRh;
@property (nonatomic, assign) BOOL verifyPassword;
@property (nonatomic, assign) BOOL showPushNotice;
@property (nonatomic, assign) BOOL searchBloodGroup;
@property (nonatomic, assign) BOOL calendarReminders;
@property (nonatomic, assign) BOOL calendarCloseEvent;
@property (nonatomic, assign) BOOL bloodUsePlatelets;
@property (nonatomic, assign) BOOL bloodUseWhole;
@property (nonatomic, assign) BOOL bloodUsePlasma;

+ (BloodDonor*) shared;

- (void) loginWithInternet;
- (void) logoutWithInternet;

- (void) synchronize;

@end

/*--------------------------------------------------*/
