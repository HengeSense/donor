/*--------------------------------------------------*/

#import "HSControl.h"

/*--------------------------------------------------*/

@protocol HSPullViewDelegate;

/*--------------------------------------------------*/

enum
{
    HSPullDirectionTop,
    HSPullDirectionRight,
    HSPullDirectionBottom,
    HSPullDirectionLeft
};

typedef NSUInteger HSPullDirection;

/*--------------------------------------------------*/

@interface HSPullView : HSControl
{
    BOOL mRecognizerEnable;
    UIPanGestureRecognizer *mPanRecognizer;
    UITapGestureRecognizer *mTapRecognizer;
    id< HSPullViewDelegate > mDelegate;
    UIView *mTarget;
    HSPullDirection mDirection;
    CGPoint mOrigin;
    CGFloat mOffset;
    BOOL mOpened;
    BOOL mAnimation;
    CGFloat mDuration;
    CGPoint mStartPos;
    CGPoint mMinPos;
    CGPoint mMaxPos;
}

@property (nonatomic, readwrite, assign) BOOL recognizerEnable;
@property (nonatomic, readonly, strong) UIPanGestureRecognizer *panRecognizer;
@property (nonatomic, readonly, strong) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, readwrite, strong) IBOutlet id< HSPullViewDelegate > delegate;
@property (nonatomic, readwrite, strong) IBOutlet UIView *target;
@property (nonatomic, readwrite, assign) HSPullDirection direction;
@property (nonatomic, readwrite, assign) CGPoint origin;
@property (nonatomic, readwrite, assign) CGFloat offset;
@property (nonatomic, readwrite, assign) BOOL opened;
@property (nonatomic, readwrite, assign) BOOL animation;
@property (nonatomic, readwrite, assign) CGFloat duration;

- (void) setOpened:(BOOL)opened animated:(BOOL)animated;

- (CGPoint) centerWithOpened:(BOOL)opened;
- (CGRect) frameWithOpened:(BOOL)opened;
- (CGRect) boundsWithOpened:(BOOL)opened;

- (void) delegateDidChangeState:(BOOL)opened;

@end

/*--------------------------------------------------*/

@protocol HSPullViewDelegate <  NSObject >

@optional
- (void) pullView:(HSPullView*)view didChangeState:(BOOL)opened;

@end

/*--------------------------------------------------*/
