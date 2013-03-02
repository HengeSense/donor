//
//  HSBloodRemoteEvent+LocalNotification_Protected.m
//  Donor
//
//  Created by Sergey Seroshtan on 02.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "HSBloodRemoteEvent+LocalNotification_Protected.h"

@implementation HSBloodRemoteEvent (LocalNotification_Protected)

- (NSString *)alertBodyForRemindLocalNotification {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                reason:[NSString stringWithFormat:@"%@ should be implemented in subclusses", NSStringFromSelector(_cmd)]
                userInfo:nil];
}

@end
