//
//  NSUnderlinedButton.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 13.01.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "NSUnderlinedButton.h"

@implementation NSUnderlinedButton

- (void) drawRect:(CGRect)rect {
    CGRect textRect = self.titleLabel.frame;
    
    // need to put the line at top of descenders (negative value)
    CGFloat descender = self.titleLabel.font.descender;
    CGContextRef contextRef = UIGraphicsGetCurrentContext();
    
    // Shift descender on shadows height
    CGFloat shadowHeight = self.titleLabel.shadowOffset.height;
    descender += shadowHeight;
    
    // Shift descender on shadows height
    descender += 4;
    
    // set to same colour as text
    CGContextSetStrokeColorWithColor(contextRef, self.titleLabel.textColor.CGColor);
    
    CGContextMoveToPoint(contextRef, textRect.origin.x, textRect.origin.y + textRect.size.height + descender);
    
    CGContextAddLineToPoint(contextRef, textRect.origin.x + textRect.size.width,
                            textRect.origin.y + textRect.size.height + descender);
    
    CGContextClosePath(contextRef);
    
    CGContextDrawPath(contextRef, kCGPathStroke);
}

@end
