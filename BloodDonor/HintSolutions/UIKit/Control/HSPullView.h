/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@class HSPullView;

/*--------------------------------------------------*/

@protocol HSPullViewDelegate <  NSObject >

@optional
- (void) pullView:(HSPullView*)view didChangeState:(BOOL)opened;

@end

/*--------------------------------------------------*/

enum
{
    HSPullDirectionLeft,
    HSPullDirectionTop,
    HSPullDirectionRight,
    HSPullDirectionBottom
};

typedef NSUInteger HSPullDirection;

/*--------------------------------------------------*/

@interface HSPullView : UIView
{
@protected
    UIPanGestureRecognizer *mDragRecognizer;
    UITapGestureRecognizer *mTapRecognizer;
    id< HSPullViewDelegate > mDelegate;
@protected
    CGRect mSuperViewFrame;
    CGFloat mHeaderSize;
    HSPullDirection mDirection;
    BOOL mToggleOnTap;
    BOOL mOpened;
@protected
    BOOL mAnimation;
    CGFloat mDuration;
@protected
    UIView *mHandleView;
    UIView *mClientView;
@protected
    CGPoint mStartPos;
    CGPoint mMinPos;
    CGPoint mMaxPos;
}

@property (nonatomic, readonly, assign) UIPanGestureRecognizer *dragRecognizer;
@property (nonatomic, readonly, assign) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, readwrite, assign) id< HSPullViewDelegate > delegate;
@property (nonatomic, readwrite, assign) CGRect superViewFrame;
@property (nonatomic, readonly, assign) CGFloat headerSize;
@property (nonatomic, readwrite, assign) HSPullDirection direction;
@property (nonatomic, readwrite, assign) BOOL toggleOnTap;
@property (nonatomic, readonly, assign) BOOL opened;
@property (nonatomic, readwrite, assign) BOOL animation;
@property (nonatomic, readwrite, assign) CGFloat duration;
@property (nonatomic, readonly, assign) UIView *handleView;
@property (nonatomic, readonly, assign) UIView *clientView;

+ (id) viewWithSuperViewFrame:(CGRect)superViewFrame
                   headerSize:(CGFloat)headerSize
                    direction:(HSPullDirection)direction
                       opened:(BOOL)opened;

- (id) initWithSuperViewFrame:(CGRect)superViewFrame
                   headerSize:(CGFloat)headerSize
                    direction:(HSPullDirection)direction
                       opened:(BOOL)opened;

- (CGRect) frameWithSuperViewFrame:(CGRect)superViewFrame
                        headerSize:(CGFloat)headerSize
                         direction:(HSPullDirection)direction
                            opened:(BOOL)opened;

- (CGPoint) centerWithSuperViewFrame:(CGRect)superViewFrame
                          headerSize:(CGFloat)headerSize
                           direction:(HSPullDirection)direction
                              opened:(BOOL)opened;

- (void) setOpened:(BOOL)opened
          animated:(BOOL)animated;

@end

/*--------------------------------------------------*/
