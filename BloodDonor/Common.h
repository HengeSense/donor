//
//  Common.h
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface Common : NSObject
{
    NSNumber *sex;
    NSNumber *bloodGroup;
    NSNumber *bloodRH;
    NSMutableArray *events;
    
    NSUserDefaults *defaults;
    
    NSMutableArray *lastStations;
}

+ (Common *) getInstance;

@property (nonatomic, retain) NSDate *lastWholeBloodDate;
@property (nonatomic) int wholeBloodCount;

@property (nonatomic) int eventTimeReminderIndex;
@property (nonatomic, retain) NSString *eventStationAddress;
@property (nonatomic, retain) NSDateComponents *availablePlateletsDateComponents;
@property (nonatomic, retain) NSDateComponents *availablePlasmaDateComponents;
@property (nonatomic, retain) NSDateComponents *availableWholeBloodDateComponents;

@property (nonatomic, retain) NSString *email;
@property (nonatomic, retain) NSString *password;
@property (nonatomic, retain) NSString *userObjectId;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSNumber *sex;
@property (nonatomic, retain) NSNumber *bloodGroup;
@property (nonatomic, retain) NSNumber *bloodRH;
@property (nonatomic, retain) NSMutableArray *events;

//Последние использованные станции
@property (nonatomic, retain, setter = lastStationsSetter:) NSArray *lastStations;

//Настройки поиска по станциям

@property (nonatomic, setter = isMoscowSetter:)BOOL isMoscow;
@property (nonatomic, setter = isPeterburgSetter:)BOOL isPeterburg;
@property (nonatomic, setter = isRegionalRegistrationSetter:)BOOL isRegionalRegistration;
@property (nonatomic, setter = isWorkAtSaturdaySetter:)BOOL isWorkAtSaturday;
@property (nonatomic, setter = isDonorsForChildrenSetter:)BOOL isDonorsForChildren ;

- (void)isMoscowSetter:(BOOL)setterValue;
- (void)isPeterburgSetter:(BOOL)setterValue;
- (void)isRegionalRegistrationSetter:(BOOL)setterValue;
- (void)isWorkAtSaturdaySetter:(BOOL)setterValue;
- (void)isDonorsForChildrenSetter:(BOOL)setterValue;

//Settings

@property (nonatomic, setter = isNeedPasswordSetter:) BOOL isNeedPassword;
@property (nonatomic, setter = isNeedPushAnnotationsSetter:) BOOL isNeedPushAnnotations;
@property (nonatomic, setter = isNeedExpressSearchSetter:) BOOL isNeedExpressSearch;
@property (nonatomic, setter = isNeedRemindersSetter:) BOOL isNeedReminders;
@property (nonatomic, setter = isNeedClosingEventSetter:) BOOL isNeedClosingEvent;
@property (nonatomic, setter = isNeedPlateletsPushSetter:) BOOL isNeedPlateletsPush;
@property (nonatomic, setter = isNeedWholeBloodPushSetter:) BOOL isNeedWholeBloodPush;
@property (nonatomic, setter = isNeedPlasmaPushSetter:) BOOL isNeedPlasmaPush;

- (void)isNeedPasswordSetter:(BOOL)isNeed;
- (void)isNeedPushAnnotationsSetter:(BOOL)isNeed;
- (void)isNeedExpressSearchSetter:(BOOL)isNeed;
- (void)isNeedRemindersSetter:(BOOL)isNeed;
- (void)isNeedClosingEventSetter:(BOOL)isNeed;
- (void)isNeedPlateletsPushSetter:(BOOL)isNeed;
- (void)isNeedWholeBloodPushSetter:(BOOL)isNeed;
- (void)isNeedPlasmaPushSetter:(BOOL)isNeed;

- (void)lastStationsSetter:(NSArray *)setterArray;


@end
