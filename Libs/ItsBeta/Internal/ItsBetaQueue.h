/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

char* const ItsBetaDispatchQueue;

/*--------------------------------------------------*/

typedef dispatch_block_t ItsBetaQueueBlock;
typedef void (^ItsBetaQueueBlockAt)(NSUInteger index);

/*--------------------------------------------------*/

@interface ItsBetaQueue : NSObject {
}

+ (ItsBetaQueue*) sharedItsBetaQueue;

+ (void) runSync:(ItsBetaQueueBlock)block;
+ (void) runASync:(ItsBetaQueueBlock)block;
+ (void) runASyncCount:(NSUInteger)count block:(ItsBetaQueueBlockAt)block;
+ (void) runMainSync:(ItsBetaQueueBlock)block;
+ (void) runMainASync:(ItsBetaQueueBlock)block;

@end


/*--------------------------------------------------*/

extern ItsBetaQueue* sharedItsBetaQueue;

/*--------------------------------------------------*/
