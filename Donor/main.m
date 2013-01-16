//
//  main.m
//  BloodDonor
//
//  Created by Sergey Seroshtan on 12.10.12.
//  Copyright (c) 2012 Hint Solutions. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"

int main(int argc, char *argv[])
{
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        } @catch (NSException *exception) {
            NSLog(@"System was crashed with exception: %@", [exception reason]);
            @throw exception;
        }
    }
}
