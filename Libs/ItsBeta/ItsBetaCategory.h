/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaCategory : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* name; // Имя категории
@property(nonatomic, readonly) NSString* title; // Внешнее название категории

+ (ItsBetaCategory*) categoryWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaCategoryCollection : NSObject< NSCoding, NSFastEnumeration > {
}

@property(nonatomic, readonly) NSUInteger count; // Количество элементов в колекции

+ (ItsBetaCategoryCollection*) collection;
+ (ItsBetaCategoryCollection*) collectionWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (void) addCategory:(ItsBetaCategory*)category;
- (void) setCategories:(ItsBetaCategoryCollection*)categories;
- (ItsBetaCategory*) categoryAtIndex:(NSUInteger)index;
- (ItsBetaCategory*) categoryAtName:(NSString*)name;

@end

/*--------------------------------------------------*/
