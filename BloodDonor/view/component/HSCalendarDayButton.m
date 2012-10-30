//
//  HSCalendarDayButton.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendarDayButton.h"

#import "HSEventRenderer.h"

#pragma mark - Private interface declaration
@interface HSCalendarDayButton ()

/**
 * Hadles all added events.
 */
@property (nonatomic, strong) NSMutableSet *events;

/**
 * Removes public property 'date' readonly restiction.
 */
@property (nonatomic, strong) NSDate *date;

/**
 * Updates all UI components. Is used after adding or removing events.
 */
- (void)updateUI;

@end

@implementation HSCalendarDayButton

#pragma mark - Initialization
- (id)initWithFrame: (CGRect)frame date:(NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date, @"date is not specified");
    if (self = [super initWithFrame: frame]) {
        self.date = date;
        self.events = [[NSMutableSet alloc] init];
        
        // Configure UI
        NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components: NSDayCalendarUnit fromDate: date];
        NSString *title = [NSString stringWithFormat: @"%d", dateComponents.day];
        [self setTitle: title forState: UIControlStateNormal];
        [self setTitle: title forState: UIControlStateHighlighted];
        [self setTitle: title forState: UIControlStateDisabled];
        
        [self setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        [self setTitleColor: [UIColor blackColor] forState: UIControlStateHighlighted];
        [self setTitleColor: [UIColor grayColor] forState: UIControlStateDisabled];

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

#pragma mark -  HSEvent objects management methods
- (void)addEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self updateUI];
    }
}

- (void)removeEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event, @"event is not specified");
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self updateUI];
    }
}

- (NSSet *)allEvents {
    return [NSSet setWithSet: self.events];
}

#pragma mark - Private interface implementation
- (void)updateUI {
    // remove old events representations
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // add new events representations
    for (HSEvent *event in self.allEvents) {
        HSEventRenderer *eventRenderer = [HSEventRenderer createEventRendererForEvent: event];
        UIView *eventView = [eventRenderer renderViewInBounds: self.bounds];
        [self addSubview: eventView];
    }
    
    [self setNeedsLayout];
}

@end
