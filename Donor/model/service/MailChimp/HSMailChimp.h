//
//  HSMailChimp.h
//  Donor
//
//  Created by Sergey Seroshtan on 31.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PFUser;

/**
 * This class provides wrapper over MailChimp library.
 */
@interface HSMailChimp : NSObject

/// @name Singleton
+ (HSMailChimp *)sharedInstance;

/// @name Configuration
/**
 * Configures mail chimp wrapper with specified MailChimp API key and application list key.
 */
- (void)configureWithApiKey:(NSString *)apiKey listId:(NSString *)listId;

/// @name Operations
/**
 * Subscribes or updates existing email with specified user first name and last name.
 * Note that this operation is asynchrous and silent!
 *
 * @param email email that will be added/updated
 * @param firstName - user first name (optional)
 * @param secondName - user second name (optional)
 */
- (void)subscribeOrUpdateEmail:(NSString *)email withUserFirstName:(NSString *)firstName lastName:(NSString *)lastName;

/**
 * Subscribe or update MailChimp with specified user.
 */
- (void)subscribeOrUpdateUser:(PFUser *)user;

@end
