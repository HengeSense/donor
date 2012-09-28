//
//  SLabel.h
//  Lenta
//
//  Created by Andrey Rebrik on 25.06.12.
//  Copyright 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SLabel : UILabel
{
    BOOL _strikethrough;
    float _spacingAdjustment;
}

@property (nonatomic, assign) BOOL strikethrough;
@property (nonatomic, assign) float spacingAdjustment;

- (NSArray *)linesFromString;

@end
