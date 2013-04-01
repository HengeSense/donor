/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaProject : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* Id; // Уникальный Id проекта
@property(nonatomic, readonly) NSString* name; // Имя проекта
@property(nonatomic, readonly) NSString* categoryName; // Имя категории
@property(nonatomic, readonly) NSString* title; // Заголовок проекта
#if TARGET_OS_IPHONE
@property(nonatomic, readonly) UIColor* color; // Цвет проекта
#else
@property(nonatomic, readonly) CIColor* color; // Цвет проекта
#endif

@property(nonatomic, readonly) ItsBetaObjectTypeCollection* objectTypes;
@property(nonatomic, readonly) ItsBetaObjectTemplateCollection* objectTemplates;

+ (ItsBetaProject*) projectWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

- (void) synchronizeASync;
- (void) synchronizeSync;

@end

/*--------------------------------------------------*/

@interface ItsBetaProjectCollection : NSObject< NSCoding, NSFastEnumeration > {
}

@property(nonatomic, readonly) NSUInteger count; // Количество элементов в колекции

+ (ItsBetaProjectCollection*) collection;
+ (ItsBetaProjectCollection*) collectionWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (void) addProject:(ItsBetaProject*)project;
- (void) setProjects:(ItsBetaProjectCollection*)projects;
- (ItsBetaProject*) projectAtIndex:(NSUInteger)index;
- (ItsBetaProject*) projectAtId:(NSString*)Id;
- (ItsBetaProject*) projectAtName:(NSString*)name;

@end

/*--------------------------------------------------*/
