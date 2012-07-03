/*--------------------------------------------------*/

#import "HSDateComponents.h"

/*--------------------------------------------------*/

@implementation NSDateComponents (HintSolutions)

+ (id) dateComponents
{
    return [[self alloc] init];
}

+ (id) dateComponentsWithYear:(NSInteger)year
{
    return [[self alloc] initWithYear:year];
}

+ (id) dateComponentsWithMonth:(NSInteger)month
{
    return [[self alloc] initWithMonth:month];
}

+ (id) dateComponentsWithDay:(NSInteger)day
{
    return [[self alloc] initWithDay:day];
}

+ (id) dateComponentsWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    return [[self alloc] initWithYear:year month:month day:day];
}

- (id) initWithYear:(NSInteger)year
{
    self = [super init];
    if(self != nil)
    {
        [self setYear:year];
    }
    return self;
}

- (id) initWithMonth:(NSInteger)month
{
    self = [super init];
    if(self != nil)
    {
        [self setMonth:month];
    }
    return self;
}

- (id) initWithDay:(NSInteger)day
{
    self = [super init];
    if(self != nil)
    {
        [self setDay:day];
    }
    return self;
}

- (id) initWithYear:(NSInteger)year month:(NSInteger)month day:(NSInteger)day
{
    self = [super init];
    if(self != nil)
    {
        [self setYear:year];
        [self setMonth:month];
        [self setDay:day];
    }
    return self;
}

@end

/*--------------------------------------------------*/
