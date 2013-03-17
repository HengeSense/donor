//
//  Swizzler.h
//  Donor
//
//  Created by Sergey Seroshtan on 17.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

@interface Swizzler : NSObject

+ (void)swizzleFromClass:(Class)targetClass method:(SEL)targetSelector
                 toClass:(Class)swizzleClass method:(SEL)swizzleSelector;

+ (void)swizzleFromClass:(Class)targetClass method:(SEL)targetSelector toClass:(Class)swizzleClass;


+ (void)deswizzle;

@end
