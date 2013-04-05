/*--------------------------------------------------*/

#import "ItsBetaQueue.h"

/*--------------------------------------------------*/

char* const ItsBetaDispatchQueue = "com.itsbeta";

/*--------------------------------------------------*/

@interface ItsBetaQueue () {
    dispatch_queue_t _queue;
}

- (void) runQueueSync:(ItsBetaQueueBlock)block;
- (void) runQueueASync:(ItsBetaQueueBlock)block;
- (void) runQueueASyncCount:(NSUInteger)count block:(ItsBetaQueueBlockAt)block;

@end

/*--------------------------------------------------*/

@implementation ItsBetaQueue

+ (ItsBetaQueue*) sharedItsBetaQueue {
    if(sharedItsBetaQueue == nil) {
        @synchronized(self) {
            if(sharedItsBetaQueue == nil) {
                sharedItsBetaQueue = [[self alloc] init];
            }
        }
    }
    return sharedItsBetaQueue;
}

- (id) init {
    self = [super init];
    if(self != nil) {
        _queue = dispatch_queue_create(ItsBetaDispatchQueue, nil);
    }
    return self;
}

- (void) dealloc {
    dispatch_release(_queue);
    
#if !__has_feature(objc_arc)
    [super dealloc];
#endif
}

- (void) runQueueSync:(ItsBetaQueueBlock)block {
    dispatch_sync(_queue, block);
}

- (void) runQueueASync:(ItsBetaQueueBlock)block {
    dispatch_async(_queue, block);
}

- (void) runQueueASyncCount:(NSUInteger)count block:(ItsBetaQueueBlockAt)block {
    dispatch_apply(count, _queue, ^(size_t index) { block(index); });
}

+ (void) runSync:(ItsBetaQueueBlock)block {
    [[ItsBetaQueue sharedItsBetaQueue] runQueueSync:block];
}

+ (void) runASync:(ItsBetaQueueBlock)block {
    [[ItsBetaQueue sharedItsBetaQueue] runQueueASync:block];
}

+ (void) runASyncCount:(NSUInteger)count block:(ItsBetaQueueBlockAt)block {
    [[ItsBetaQueue sharedItsBetaQueue] runQueueASyncCount:count block:block];
}

+ (void) runMainSync:(ItsBetaQueueBlock)block {
    dispatch_sync(dispatch_get_main_queue(), block);
}

+ (void) runMainASync:(ItsBetaQueueBlock)block {
    dispatch_async(dispatch_get_main_queue(), block);
}

@end

/*--------------------------------------------------*/

ItsBetaQueue* sharedItsBetaQueue = NULL;

/*--------------------------------------------------*/
