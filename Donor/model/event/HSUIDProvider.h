//
//  HSUIDProvider.h
//  Donor
//
//  Created by Sergey Seroshtan on 05.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol HSUIDProvider <NSObject>

/**
 * Returns unique identifier of the object.
 *     Identifiers should be unique in the one object hierarchy, and may be the same in the different.
 */
- (NSUInteger)uid;

@end
