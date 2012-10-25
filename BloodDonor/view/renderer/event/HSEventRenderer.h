//
//  HSEventRenderer.h
//  BloodDonor
//
//  Created by Sergey Seroshtan on 22.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "HSEvent.h"

/**
 * This class encapsulates view rendering for all types of HSEvent ojects and it's subclasses objects.
 */
@interface HSEventRenderer : NSObject

/**
 * Factory method for creation correspond HSEventRenderer subclass for the specific event type.
 */
+ (HSEventRenderer *)createEventRendererForEvent: (HSEvent *)event;

/// @name Information properties for subclasses.
@property (nonatomic, strong) HSEvent *event;

/// @name Methods for overriding in subclasses.

/**
 * Create rendered view in the specified frame. Only part of the frame is used for rendering.
 *     This method should be overriden in subclasses, by default implementation empty view is returned.
 */
- (UIView *) renderViewInFrame: (CGRect) frame;

@end
