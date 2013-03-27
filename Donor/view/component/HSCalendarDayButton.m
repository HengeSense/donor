//
//  HSCalendarDayButton.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 21.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import "HSCalendarDayButton.h"

#import "HSEventRenderer.h"

#import "NSDate+HSCalendar.h"

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
 * Adds today marker view as subview. Note that old marker view does not deleted.
 */
- (void)addTodayMarkerView;

/**
 * Updates all UI components. Is used after adding or removing events.
 */
- (void)updateUI;

@end

@implementation HSCalendarDayButton

#pragma mark - Initialization
- (id)initWithFrame: (CGRect)frame date:(NSDate *)date {
    THROW_IF_ARGUMENT_NIL(date);
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
        [self setTitleColor: [UIColor redColor] forState: UIControlStateHighlighted];
        [self setTitleColor: [UIColor grayColor] forState: UIControlStateDisabled];
        
        UIColor *highlightColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.07f];
        UIImage *backgroundColorImage = [self imageWithColor: highlightColor frame: self.bounds];
        [self setBackgroundImage: backgroundColorImage forState: UIControlStateHighlighted];
        
        self.backgroundColor = [UIColor clearColor];
        if ([self.date isTheSameDay: [NSDate date]]) {
            [self addTodayMarkerView];
        }
    }
    return self;
}

#pragma mark -  HSEvent objects management methods
- (void)addEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event);
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self updateUI];
    }
}

- (void)removeEvent: (HSEvent *)event {
    THROW_IF_ARGUMENT_NIL(event);
    if (![self.events containsObject: event]) {
        [self.events addObject: event];
        [self updateUI];
    }
}

- (NSSet *)allEvents {
    return [NSSet setWithSet: self.events];
}

#pragma mark - Private interface implementation
- (void)addTodayMarkerView {
    UIImage *borderImage = [UIImage imageNamed: @"calendarItemBorder.png"];
    UIImageView *borderView = [[UIImageView alloc] initWithImage: borderImage];
    CGRect borderViewFrame = borderView.frame;
    const CGFloat kTopMargin = 1.0f;
    borderViewFrame.origin.y = kTopMargin;
    borderView.frame = borderViewFrame;
    [self addSubview: borderView];
}

- (void)updateUI {
    if (!self.isEnabled) {
        // Do not render events for disabled button
        return;
    }
    // remove old events representations
    for (UIView *view in self.subviews) {
        [view removeFromSuperview];
    }
    
    // add new events representations
    UIView *eventsView = [self createViewForEvents];
    for (HSEvent *event in self.allEvents) {
        HSEventRenderer *eventRenderer = [HSEventRenderer createEventRendererForEvent: event];
        UIView *eventView = [eventRenderer renderViewInBounds: eventsView.bounds];
        [eventsView addSubview: eventView];
    }
    [self addSubview: eventsView];
    
    if ([self.date isTheSameDay: [NSDate date]]) {
        [self addTodayMarkerView];
    }
    
    [self setNeedsLayout];
}

- (UIImage *)imageWithColor: (UIColor *)color frame: (CGRect)frame {
    UIGraphicsBeginImageContext(frame.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, frame);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (UIView *)createViewForEvents {
    const CGFloat padding = 4.0f;
    CGRect eventsFrame =
            CGRectMake(padding, padding, self.bounds.size.width - 2 * padding, self.bounds.size.height - 2 * padding);
    UIView *result = [[UIView alloc] initWithFrame: eventsFrame];
    result.userInteractionEnabled = NO;
    [result setBackgroundColor: [UIColor clearColor]];
    return result;
}
@end
