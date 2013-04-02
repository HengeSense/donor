/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaObjectType : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* Id; // Id типа
@property(nonatomic, readonly) NSString* name; // имя типа
@property(nonatomic, readonly) NSString* projectId; // Id проекта
@property(nonatomic, readonly) NSString* parentId; // Id родительского типа
@property(nonatomic, readonly) ItsBetaParams* internal; // Внутриние параметры
@property(nonatomic, readonly) ItsBetaParams* external; // Внешние параметры
@property(nonatomic, readonly) ItsBetaParams* shared; // Общие параметры

@property(nonatomic, readonly) NSNumber* templateCount; // Кол-во шаблонов в типе

+ (ItsBetaObjectType*) objectTypeWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectTypeCollection : NSObject< NSCoding, NSFastEnumeration > {
}

@property(nonatomic, readonly) NSUInteger count; // Количество элементов в колекции

+ (ItsBetaObjectTypeCollection*) collection;
+ (ItsBetaObjectTypeCollection*) collectionWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (void) addObjectType:(ItsBetaObjectType*)objectType;
- (void) setObjectTypes:(ItsBetaObjectTypeCollection*)objectTypes;
- (ItsBetaObjectType*) objectTypeAtIndex:(NSUInteger)index;
- (ItsBetaObjectType*) objectTypeAtId:(NSString*)Id;
- (ItsBetaObjectType*) objectTypeAtName:(NSString*)name;

@end

/*--------------------------------------------------*/
