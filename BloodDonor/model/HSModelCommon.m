//
//  HSModelCommon.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 24.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSModelCommon.h"

NSString * const kRemoteEvent_BaseClassName = @"Events";

NSString * const HSRemoteServerResonseErrorDomain = @"HSRemoteServerResonseErrorDomain";

NSString * const HSCalendarAddEventErrorDomain = @"HSCalendarAddEventErrorDomain";

NSString* localizedDescriptionForError (NSError *error) {
    THROW_IF_ARGUMENT_NIL(error, @"erro is not specified");
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
        
    } else if ([error.domain isEqualToString: HSRemoteServerResonseErrorDomain]) {
        return @"Невозможно сохранить данные на сервере, возможно нет подключения.";
    }
    return @"Ошибка неизвестна.";
}
