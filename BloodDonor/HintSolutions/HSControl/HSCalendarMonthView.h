/*--------------------------------------------------*/

#import "HSView.h"

/*--------------------------------------------------*/

@protocol HSCalendarTitleViewDelegate;

/*--------------------------------------------------*/

@interface HSCalendarTitleView : HSView
{
    id< HSCalendarTitleViewDelegate > mDelegate;
}

@property (nonatomic, readwrite, assign) IBOutlet id< HSCalendarTitleViewDelegate > delegate;

@end

/*--------------------------------------------------*/

@protocol HSCalendarTitleViewDelegate <  NSObject >

@end

/*--------------------------------------------------*/
