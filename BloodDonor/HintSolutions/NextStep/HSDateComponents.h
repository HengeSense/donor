/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

@interface NSDateComponents (HintSolutions)

+ (id) dateComponents;
+ (id) dateComponentsWithYear:(NSInteger)year;
+ (id) dateComponentsWithMonth:(NSInteger)month;
+ (id) dateComponentsWithDay:(NSInteger)day;
+ (id) dateComponentsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

- (id) initWithYear:(NSInteger)year;
- (id) initWithMonth:(NSInteger)month;
- (id) initWithDay:(NSInteger)day;
- (id) initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day;

@end

/*--------------------------------------------------*/
