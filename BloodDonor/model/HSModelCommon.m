//
//  HSModelCommon.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 24.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSModelCommon.h"
#import <Parse/Parse.h>

NSString * const kRemoteEvent_BaseClassName = @"Events";

NSString * const HSRemoteServerResponseErrorDomain = @"HSRemoteServerResonseErrorDomain";

NSString * const HSCalendarAddEventErrorDomain = @"HSCalendarAddEventErrorDomain";

NSString* localizedDescriptionForParseError (NSError *error) {
    THROW_IF_ARGUMENT_NIL(error, @"erro is not specified");
    if (error.code == kPFErrorUserEmailTaken) {
        return @"Невозможно сохранить данные, так как почтовый ящик используется другим пользователем.";
    }
    return @"Невозможно сохранить данные. Ошибка на сервере.";
}

NSString* localizedDescriptionForError (NSError *error) {
    THROW_IF_ARGUMENT_NIL(error, @"erro is not specified");
    NSLog(@"Trying to make localization for error: %@", error);
    if ([error.domain isEqualToString: HSCalendarAddEventErrorDomain]) {
        switch (error.code) {
            case HSCalendarAddEventErrorDomainCode_RestPeriodNotFinished:
                return @"Период отдыха еще не закончился.";
            case HSCalendarAddEventErrorDomainCode_BeforeFirstDonation:
                return @"Нельзя добавить событие перед первой кроводачей.";
            case HSCalendarAddEventErrorDomainCode_DayIsBusy:
                return @"В этот день уже есть запланированное событие.";
            default:
                break;
        }
        
    } else if ([error.domain isEqualToString: HSRemoteServerResponseErrorDomain]) {
        NSError *parseError = [error.userInfo objectForKey:NSUnderlyingErrorKey];
        if (parseError != nil) {
            return localizedDescriptionForParseError(parseError);
        } else {
            return @"Невозможно сохранить данные на сервере, возможно нет подключения.";
        }
    }
    return @"Ошибка неизвестна.";
}
