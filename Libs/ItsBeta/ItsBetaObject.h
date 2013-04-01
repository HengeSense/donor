/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaObject : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* Id; // Id обьекта
@property(nonatomic, readonly) NSString* name; // имя обьекта
@property(nonatomic, readonly) ItsBetaParams* external; // Внешние параметры

+ (ItsBetaObject*) objectWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectCollection : NSObject< NSCoding, NSFastEnumeration > {
}

@property(nonatomic, readonly) NSUInteger count; // Количество элементов в колекции

+ (ItsBetaObjectCollection*) collection;
+ (ItsBetaObjectCollection*) collectionWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (void) addObject:(ItsBetaObject*)object;
- (void) setObjects:(ItsBetaObjectCollection*)objects;
- (ItsBetaObject*) objectAtIndex:(NSUInteger)index;
- (ItsBetaObject*) objectAtId:(NSString*)Id;

@end

/*--------------------------------------------------*/
