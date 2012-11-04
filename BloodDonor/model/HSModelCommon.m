//
//  HSModelCommon.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 24.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSModelCommon.h"

NSString * const kRemoteEvent_BaseClassName = @"Events";
NSString * const HSRemoteServerResonseError = @"HSRemoteServerResonseError";
NSString * const HSBloodDonationRestPeriodNotFinishedError = @"HSBloodDonationRestPeriodNotFinishedError";

NSString* errorDomainToLicalizedDescription (NSString *errorDomain) {
    THROW_IF_ARGUMENT_NIL(errorDomain, @"errorDomain is not specified");
    if ([errorDomain isEqualToString: HSBloodDonationRestPeriodNotFinishedError]) {
        return @"Период отдыха еще не закончился.";
    } else if ([errorDomain isEqualToString: HSRemoteServerResonseError]) {
        return @"Невозможно сохранить данные на сервере, возможно нет подключения.";
    } else {
        return @"Ошибка неизвестна.";
    }
}
