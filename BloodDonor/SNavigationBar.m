//
//  SNavigationBar.m
//  BloodDonor
//
//  Created by Andrey Rebrik on 18.09.12.
//
//

#import "SNavigationBar.h"

@implementation UINavigationBar (SNavigationBar)

- (void)drawRect:(CGRect)rect
{
    UIImage *image = [UIImage imageNamed:@"navigationBar"];
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, image.size.height)];
}

@end
