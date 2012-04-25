/*--------------------------------------------------*/

#import "HSUserDefaults.h"

/*--------------------------------------------------*/

enum
{
    HSDonorSexUnknown,
    HSDonorSexMan,
    HSDonorSexWoman
};

typedef NSInteger HSDonorSex;

/*--------------------------------------------------*/

enum
{
    HSDonorBloodGroupUnknown,
    HSDonorBloodGroupI,
    HSDonorBloodGroupII,
    HSDonorBloodGroupIII,
    HSDonorBloodGroupIV
};

typedef NSInteger HSDonorBloodGroup;

/*--------------------------------------------------*/

enum
{
    HSDonorBloodRhUnknown,
    HSDonorBloodRhPos,
    HSDonorBloodRhNeg
};

typedef NSInteger HSDonorBloodRh;

/*--------------------------------------------------*/

@interface HSDonor : NSObject
{
    NSString* mLogin;
    NSString* mPassword;
    NSString* mName;
    HSDonorSex mSex;
    HSDonorBloodGroup mBloodGroup;
    HSDonorBloodRh mBloodRh;
    BOOL mVerifyPassword;
    BOOL mShowPushNotice;
    BOOL mSearchBloodGroup;
    BOOL mCalendarReminders;
    BOOL mCalendarCloseEvent;
    BOOL mBloodUsePlatelets;
    BOOL mBloodUseWhole;
    BOOL mBloodUsePlasma;
}

@property (nonatomic, strong) NSString* login;
@property (nonatomic, strong) NSString* password;
@property (nonatomic, strong) NSString* name;
@property (nonatomic, assign) HSDonorSex sex;
@property (nonatomic, assign) HSDonorBloodGroup bloodGroup;
@property (nonatomic, assign) HSDonorBloodRh bloodRh;
@property (nonatomic, assign) BOOL verifyPassword;
@property (nonatomic, assign) BOOL showPushNotice;
@property (nonatomic, assign) BOOL searchBloodGroup;
@property (nonatomic, assign) BOOL calendarReminders;
@property (nonatomic, assign) BOOL calendarCloseEvent;
@property (nonatomic, assign) BOOL bloodUsePlatelets;
@property (nonatomic, assign) BOOL bloodUseWhole;
@property (nonatomic, assign) BOOL bloodUsePlasma;

+ (HSDonor*) shared;

- (void) loginWithInternet;
- (void) logoutWithInternet;

- (void) synchronize;

@end

/*--------------------------------------------------*/
