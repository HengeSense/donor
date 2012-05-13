/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

@interface NSUserDefaults (HintSolutions)

- (id) objectForKey:(NSString*)key asDefaults:(id)defaults;
- (NSString*) stringForKey:(NSString*)key asDefaults:(NSString*)defaults;
- (NSArray*) arrayForKey:(NSString*)key asDefaults:(NSArray*)defaults;
- (NSDictionary*) dictionaryForKey:(NSString*)key asDefaults:(NSDictionary*)defaults;
- (NSData*) dataForKey:(NSString*)key asDefaults:(NSData*)defaults;
- (NSArray*) stringArrayForKey:(NSString*)key asDefaults:(NSArray*)defaults;
- (NSInteger) integerForKey:(NSString*)key asDefaults:(NSInteger)defaults;
- (float) floatForKey:(NSString*)key asDefaults:(float)defaults;
- (double) doubleForKey:(NSString*)key asDefaults:(double)defaults;
- (BOOL) boolForKey:(NSString*)key asDefaults:(BOOL)defaults;

@end

/*--------------------------------------------------*/
