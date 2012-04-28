/*--------------------------------------------------*/

#import <UIKit/UIKit.h>

/*--------------------------------------------------*/

@interface UIBarButtonItem (HintSolutions)

+ (id) barButtomItemWithImage:(UIImage*)image style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id) barButtomItemWithImage:(UIImage*)image landscapeImagePhone:(UIImage*)landscapeImagePhone style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action __OSX_AVAILABLE_STARTING(__MAC_NA,__IPHONE_5_0);
+ (id) barButtomItemWithTitle:(NSString*)title style:(UIBarButtonItemStyle)style target:(id)target action:(SEL)action;
+ (id) barButtomItemWithBarButtonSystemItem:(UIBarButtonSystemItem)systemItem target:(id)target action:(SEL)action;
+ (id) barButtomItemWithCustomView:(UIView*)customView;

@end

/*--------------------------------------------------*/
