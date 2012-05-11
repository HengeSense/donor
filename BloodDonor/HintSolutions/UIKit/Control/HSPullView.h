/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

@class HSPullView;

/*--------------------------------------------------*/

@protocol HSPullViewDelegate <  NSObject >

@optional
- (void) pullView:(HSPullView*)view didChangeState:(BOOL)opened;

@end

/*--------------------------------------------------*/

@interface HSPullView : UIView
{
    UIPanGestureRecognizer *mDragRecognizer;
    UITapGestureRecognizer *mTapRecognizer;
    id< HSPullViewDelegate > mDelegate;
    UIView *mHandleView;
    CGPoint mOpenedCenter;
    CGPoint mClosedCenter;
    CGPoint mStartPos;
    CGPoint mMinPos;
    CGPoint mMaxPos;
    BOOL mOpened;
    BOOL mVerticalAxis;
    BOOL mToggleOnTap;
    BOOL mAnimate;
    CGFloat mDuration;
}

@property (nonatomic, readonly, assign) UIPanGestureRecognizer *dragRecognizer;
@property (nonatomic, readonly, assign) UITapGestureRecognizer *tapRecognizer;
@property (nonatomic, readwrite, assign) id< HSPullViewDelegate > delegate;
@property (nonatomic, readonly, assign) UIView *handleView;
@property (nonatomic, readwrite, assign) CGPoint openedCenter;
@property (nonatomic, readwrite, assign) CGPoint closedCenter;
@property (nonatomic, readwrite, assign) BOOL toggleOnTap;
@property (nonatomic, readwrite, assign) BOOL animate;
@property (nonatomic, readwrite, assign) CGFloat duration;

- (void) setOpened:(BOOL)state animated:(BOOL)animated;

@end

/*--------------------------------------------------*/
