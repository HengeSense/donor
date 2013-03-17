//
//  Swizzler.m
//  Donor
//
//  Created by Sergey Seroshtan on 17.03.13.
//  Copyright (c) 2013 Hint Solutions. All rights reserved.
//

#import "Swizzler.h"
#import <objc/runtime.h>

@interface SwizzlingMethodPair : NSObject

@property (nonatomic, assign) Method original;
@property (nonatomic, assign) Method swizzled;

- (id)initWithOriginal:(Method)original swizzled:(Method)swizzled;

@end

@implementation SwizzlingMethodPair

- (id)initWithOriginal:(Method)original swizzled:(Method)swizzled {
    self = [super init];
    if (self) {
        self.original = original;
        self.swizzled = swizzled;
    }
    return self;
}

@end

static NSMutableArray *swizzlingStack;

@implementation Swizzler

+ (void)initialize {
    swizzlingStack = [NSMutableArray array];
}

+ (void)swizzleFromClass:(Class)targetClass method:(SEL)targetSelector
                 toClass:(Class)swizzleClass method:(SEL)swizzleSelector {
    
    Method originalMethod = class_getInstanceMethod(targetClass, targetSelector);
    Method swizzledMethod = class_getInstanceMethod(swizzleClass, swizzleSelector);
    
    if (originalMethod != NULL && swizzledMethod != NULL) {
        method_exchangeImplementations(originalMethod, swizzledMethod);
        [swizzlingStack addObject:[[SwizzlingMethodPair alloc] initWithOriginal:originalMethod swizzled:swizzledMethod]];
    }
}

+ (void)swizzleFromClass:(Class)targetClass method:(SEL)targetSelector toClass:(Class)swizzleClass {
    [self swizzleFromClass:targetClass method:targetSelector toClass:swizzleClass method:targetSelector];
}

+ (void)deswizzle {
    for (SwizzlingMethodPair *methodPair in swizzlingStack) {
        method_exchangeImplementations(methodPair.swizzled, methodPair.original);
    }
    [swizzlingStack removeAllObjects];
}

@end
