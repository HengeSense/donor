/*--------------------------------------------------*/

#import "HSDonor.h"

/*--------------------------------------------------*/

static HSDonor *HSDonorShared = nil;

/*--------------------------------------------------*/

@implementation HSDonor

+ (HSDonor*) shared
{
    @synchronized(self)
    {
        if(HSDonorShared == nil)
        {
            HSDonorShared = [NSAllocateObject([self class], 0, NULL) init];
        }
    }
    return HSDonorShared;
}

+ (id) allocWithZone:(NSZone *)zone
{
    return [[self shared] retain];
}

- (id) copyWithZone:(NSZone*)zone
{
    return self;
}

- (id) retain
{
    return self;
}

- (NSUInteger) retainCount
{
    return NSUIntegerMax;
}

- (id) autorelease
{
    return self;
}

@end

/*--------------------------------------------------*/
