//
//  Common.m
//  BloodDonor
//
//  Created by Владимир Носков on 16.07.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Common.h"

@implementation Common

@synthesize wholeBloodCount, lastWholeBloodDate;

@synthesize email, name, password, userObjectId, sex, bloodGroup, bloodRH, events, eventTimeReminderIndex, availablePlasmaDateComponents, availablePlateletsDateComponents, availableWholeBloodDateComponents, eventStationAddress;
@synthesize isNeedClosingEvent, isNeedExpressSearch, isNeedPassword, isNeedPlasmaPush, isNeedPlateletsPush, isNeedPushAnnotations, isNeedReminders, isNeedWholeBloodPush;
@synthesize lastStations;
@synthesize isMoscow, isPeterburg, isDonorsForChildren, isRegionalRegistration, isWorkAtSaturday;

static Common *instance;

static void singleton_remover()
{
    [instance release];
}

+ (Common *) getInstance
{
    @synchronized(self)
    {
        if (instance == nil)
            [[self alloc] init];
    }
    return instance;
}

- (id)init
{
    self = [super init];
    instance = self;
    
    defaults = [NSUserDefaults standardUserDefaults];
    
    sex = [NSNumber new];
    bloodRH = [[[NSNumber alloc] initWithInt:0] retain];
    bloodGroup = [[[NSNumber new] initWithInt:0] retain];
    
   // bloodGroup = [[NSNumber numberWithInt:1] retain];
   // bloodRH = [[NSNumber numberWithInt:1] retain];
    
    events = [NSMutableArray new];
    
    isNeedPassword = [defaults boolForKey:@"isNeedPassword"];
    isNeedPushAnnotations = [defaults boolForKey:@"isNeedPushAnnotations"];
    isNeedExpressSearch = [defaults boolForKey:@"isNeedExpressSearch"];
    isNeedReminders = [defaults boolForKey:@"isNeedReminders"];
    isNeedClosingEvent = [defaults boolForKey:@"isNeedClosingEvent"];
    isNeedPlateletsPush = [defaults boolForKey:@"isNeedPlateletsPush"];
    isNeedWholeBloodPush = [defaults boolForKey:@"isNeedWholeBloodPush"];
    isNeedPlasmaPush = [defaults boolForKey:@"isNeedPlasmaPush"];
    
    isMoscow = [defaults boolForKey:@"isMoscow"];
    isPeterburg = [defaults boolForKey:@"isPeterburg"];
    if (!isMoscow && !isPeterburg)
        isMoscow = YES;
    else if (isMoscow && isPeterburg)
        isPeterburg = NO;
    isRegionalRegistration = [defaults boolForKey:@"isRegionalRegistration"];
    isWorkAtSaturday = [defaults boolForKey:@"isWorkAtSaturday"];
    isDonorsForChildren = [defaults boolForKey:@"isDonorsForChildren"];
    
    lastStations = [[NSMutableArray alloc] initWithArray:[defaults arrayForKey:@"lastStations"]];
    
    atexit(singleton_remover);
    
    return self;
}

- (void)isMoscowSetter:(BOOL)setterValue
{
    isMoscow = setterValue;
    [defaults setBool:isMoscow forKey:@"isMoscow"];
    [defaults synchronize];
}

- (void)isPeterburgSetter:(BOOL)setterValue
{
    isPeterburg = setterValue;
    [defaults setBool:isPeterburg forKey:@"isPeterburg"];
    [defaults synchronize];
}

- (void)isRegionalRegistrationSetter:(BOOL)setterValue
{
    isRegionalRegistration = setterValue;
    [defaults setBool:isRegionalRegistration forKey:@"isRegionalRegistration"];
    [defaults synchronize];
}

- (void)isWorkAtSaturdaySetter:(BOOL)setterValue
{
    isWorkAtSaturday = setterValue;
    [defaults setBool:isWorkAtSaturday forKey:@"isWorkAtSaturday"];
    [defaults synchronize];
}

- (void)isDonorsForChildrenSetter:(BOOL)setterValue
{
    isDonorsForChildren = setterValue;
    [defaults setBool:isDonorsForChildren forKey:@"isDonorsForChildren"];
    [defaults synchronize];
}

- (void)lastStationsSetter:(NSArray *)setterArray
{
    [self.lastStations addObjectsFromArray:setterArray];
    [defaults setObject:self.lastStations forKey:@"lastStations"];
    [defaults synchronize];
}

- (void)isNeedPasswordSetter:(BOOL)isNeed
{
    isNeedPassword = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedPassword"];
    [defaults synchronize];
}

- (void)isNeedPushAnnotationsSetter:(BOOL)isNeed
{
    isNeedPushAnnotations = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedPushAnnotations"];
    [defaults synchronize];
}

- (void)isNeedExpressSearchSetter:(BOOL)isNeed
{
    isNeedExpressSearch = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedExpressSearch"];
    [defaults synchronize];
}

- (void)isNeedRemindersSetter:(BOOL)isNeed
{
    isNeedReminders = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedReminders"];
    [defaults synchronize];
}

- (void)isNeedClosingEventSetter:(BOOL)isNeed
{
    isNeedClosingEvent = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedClosingEvent"];
    [defaults synchronize];
}

- (void)isNeedPlateletsPushSetter:(BOOL)isNeed
{
    isNeedPlateletsPush = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedPlateletsPush"];
    [defaults synchronize];
}

- (void)isNeedWholeBloodPushSetter:(BOOL)isNeed
{
    isNeedWholeBloodPush = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedWholeBloodPush"];
    [defaults synchronize];
}

- (void)isNeedPlasmaPushSetter:(BOOL)isNeed
{
    isNeedPlasmaPush = isNeed;
    [defaults setBool:isNeed forKey:@"isNeedPlasmaPush"];
    [defaults synchronize];
}

- (void)dealloc
{
    [lastStations release];
    [bloodGroup release];
    [bloodRH release];
    [sex release];
    [events release];
    [super dealloc];
}

@end
