//
//  SLabel.m
//  Lenta
//
//  Created by Andrey Rebrik on 25.06.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import "SLabel.h"

@interface SLabel()

- (void)drawStrikethrough;
- (void)drawSpacingAdjustment;

@end

@implementation SLabel

@synthesize strikethrough = _strikethrough;
@synthesize spacingAdjustment = _spacingAdjustment;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        _strikethrough = NO;
        _spacingAdjustment = 0.0f;
        self.lineBreakMode = UILineBreakModeWordWrap;
    }
    
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    //Зачеркивание
    if (_strikethrough)
        [self drawStrikethrough];
    
    //Межстрочные интервалы
    //if (_spacingAdjustment != 0.0f && (self.numberOfLines > 1 || self.numberOfLines == 0))
        [self drawSpacingAdjustment];
    //else
        //[super drawTextInRect:rect];
}

#pragma mark - Свойства

- (void)setStrikethrough:(BOOL)strikethrough
{
    if (_strikethrough == strikethrough)
        return;
    
    _strikethrough = strikethrough;
    [self setNeedsDisplay];
}

- (void)setSpacingAdjustment:(float)spacingAdjustment
{
    if (_spacingAdjustment == spacingAdjustment)
        return;
    
    _spacingAdjustment = spacingAdjustment;
    [self setNeedsDisplay];
}

#pragma mark - Функционал

- (void)drawStrikethrough
{
    CGSize size = [self.text sizeWithFont:self.font constrainedToSize:self.frame.size lineBreakMode:self.lineBreakMode];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    const float* colors = CGColorGetComponents(self.textColor.CGColor);
    CGContextSetStrokeColor(ctx, colors);
    CGContextSetLineWidth(ctx, 1.0f);
    
    float startX;
    
    switch (self.textAlignment)
    {
        case UITextAlignmentLeft:
            startX = 0;
            break;
            
        case UITextAlignmentCenter:
            startX = (self.bounds.size.width - size.width) / 2.0f;
            break;
            
        case UITextAlignmentRight:
            startX = self.bounds.size.width - size.width;
            break;
            
        default:
            startX = 0;
            break;
    }
    
    //self.bounds.size.height * 0.1f - поправка для шрифта ленты
    CGContextMoveToPoint(ctx, startX, self.bounds.size.height / 2.0f + self.bounds.size.height * 0.1f);
    CGContextAddLineToPoint(ctx, startX + size.width, self.bounds.size.height / 2.0f + self.bounds.size.height * 0.1f);
    
    CGContextStrokePath(ctx);
}

- (void)drawSpacingAdjustment
{
    NSArray *lines = [self linesFromString];
    [self.textColor set];
    
    CGSize size = [self.text sizeWithFont:self.font];
    
    for (int i = 0; i < lines.count; i++)
    {
        if (i + 1 > self.numberOfLines && self.numberOfLines != 0)
            break;
        
        NSString *line = [lines objectAtIndex:i];
        
        float startX;
        switch (self.textAlignment)
        {
            case UITextAlignmentLeft:
                startX = 0;
                break;
                
            case UITextAlignmentCenter:
                startX = (self.bounds.size.width - size.width) / 2.0f;
                break;
                
            case UITextAlignmentRight:
                startX = self.bounds.size.width - size.width;
                break;
                
            default:
                startX = 0;
                break;
        }
        
        float startY;
        if (i == 0)
            startY = 0;
        else
            startY = (self.font.lineHeight + _spacingAdjustment) * i;
        
        [line drawAtPoint:CGPointMake(startX, startY) forWidth:size.width withFont:self.font fontSize:self.font.pointSize lineBreakMode:UILineBreakModeClip baselineAdjustment:UIBaselineAdjustmentNone];
    }
}

- (NSArray *)linesFromString
{
    NSMutableArray *returnLines = [NSMutableArray array];
    NSMutableArray *components;
    
    if (self.lineBreakMode == UILineBreakModeCharacterWrap)
        components = [[[self.text componentsSeparatedByString:@""] mutableCopy] autorelease];
    else
        components = [[[self.text componentsSeparatedByString:@" "] mutableCopy] autorelease];
    
    while (components.count != 0)
    {
        NSString *line = @"";
        NSMutableIndexSet *componentsToRemove = [NSMutableIndexSet indexSet];
        
        for (int i = 0; i < components.count; i++)
        {
            NSString *component = [components objectAtIndex:i];
            NSArray *componentLines = [component componentsSeparatedByString:@"\n"];
            NSString *preString = [componentLines objectAtIndex:0];
            NSString *preLine;
            if (line.length == 0)
                preLine = [line stringByAppendingFormat:@"%@", preString];
            else
                preLine = [line stringByAppendingFormat:@" %@", preString];
            
            if ([preLine sizeWithFont:self.font].width <= self.frame.size.width)
            {
                line = [NSString stringWithString:preLine];
                component = [component substringFromIndex:preString.length];
                if (componentLines.count > 1)
                    component = [component substringFromIndex:1];
                
                if (component.length == 0)
                    [componentsToRemove addIndex:i];
                else
                {
                    [components replaceObjectAtIndex:i withObject:component];
                    i--;
                }
                
                if (componentLines.count > 1)
                    break;
            }
            else
            {
                if (line.length == 0)
                {
                    /*if (self.lineBreakMode != UILineBreakModeCharacterWrap && component.length > 1)
                    {
                        [components removeObjectAtIndex:i];
                        NSArray *oldComponents = [NSArray arrayWithArray:components];
                        [components removeAllObjects];
                        [components addObjectsFromArray:[component componentsSeparatedByString:@""]];
                        [components addObjectsFromArray:oldComponents];
                    }
                    else
                    {*/
                    line = [NSString stringWithString:preLine];
                    component = [component substringFromIndex:preString.length];
                    if (componentLines.count > 1)
                        component = [component substringFromIndex:1];
                    
                    if (component.length == 0)
                        [componentsToRemove addIndex:i];
                    else
                    {
                        [components replaceObjectAtIndex:i withObject:component];
                        i--;
                    }
                    //}
                }
                
                break;
            }
        }
        
        line = [line stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
        [returnLines addObject:line];
        [components removeObjectsAtIndexes:componentsToRemove];
    }
    
    //здесь нужно учесть такие режимы как truncateHead, trancateMiddle, truncateEnd
    
    return returnLines;
}

@end
