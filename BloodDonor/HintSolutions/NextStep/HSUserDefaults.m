/*--------------------------------------------------*/

#import "HSUserDefaults.h"

/*--------------------------------------------------*/

@implementation NSUserDefaults (HintSolutions)

- (id) objectForKey:(NSString*)key asDefaults:(id)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return value;
    }
    return defaults;
}

- (NSString*) stringForKey:(NSString*)key asDefaults:(NSString*)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return (NSString*)value;
    }
    return defaults;
}

- (NSArray*) arrayForKey:(NSString*)key asDefaults:(NSArray*)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return (NSArray*)value;
    }
    return defaults;
}

- (NSDictionary*) dictionaryForKey:(NSString*)key asDefaults:(NSDictionary*)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return (NSDictionary*)value;
    }
    return defaults;
}

- (NSData*) dataForKey:(NSString*)key asDefaults:(NSData*)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return (NSData*)value;
    }
    return defaults;
}

- (NSArray*) stringArrayForKey:(NSString*)key asDefaults:(NSArray*)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return (NSArray*)value;
    }
    return defaults;
}

- (NSInteger) integerForKey:(NSString*)key asDefaults:(NSInteger)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return [value integerValue];
    }
    return defaults;
}

- (float) floatForKey:(NSString*)key asDefaults:(float)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return [value floatValue];
    }
    return defaults;
}

- (double) doubleForKey:(NSString*)key asDefaults:(double)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return [value doubleValue];
    }
    return defaults;
}

- (BOOL) boolForKey:(NSString*)key asDefaults:(BOOL)defaults
{
    id value = [self objectForKey:key];
    if(value != nil)
    {
        return [value boolValue];
    }
    return defaults;
}

@end

/*--------------------------------------------------*/
