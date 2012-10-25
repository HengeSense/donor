//
//  HSCalendarException.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 18.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const HSCalendarExceptionUserUnauthorized;

/**
 * Encapsulates error which can be occured during interaction with HSCalendar class.
 * This exception is *checked* exception.
 */
@interface HSCalendarException : NSException

@end
