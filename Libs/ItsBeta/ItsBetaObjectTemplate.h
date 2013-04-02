/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

@interface ItsBetaObjectTemplate : NSObject< NSCoding >

@property(nonatomic, readonly) NSString* Id; // Id шаблона
@property(nonatomic, readonly) NSString* name; // имя шаблона
@property(nonatomic, readonly) NSString* projectId; // Id проекта
@property(nonatomic, readonly) NSString* typeId; //  Id типа
@property(nonatomic, readonly) NSString* imageURL; // URL изображения
@property(nonatomic, readonly) ItsBetaParams* internal; // Внутриние параметры
@property(nonatomic, readonly) ItsBetaParams* shared; // Общие параметры

@property(nonatomic, readonly) NSNumber* objectCount; // Кол-во объектов в шаблоне

@property(nonatomic, readonly) ItsBetaImage* image;

+ (ItsBetaObjectTemplate*) objectTemplateWithDictionary:(NSDictionary*)dictionary;

- (id) initWithDictionary:(NSDictionary*)dictionary;

@end

/*--------------------------------------------------*/

@interface ItsBetaObjectTemplateCollection : NSObject< NSCoding, NSFastEnumeration > {
}

@property(nonatomic, readonly) NSUInteger count; // Количество элементов в колекции

+ (ItsBetaObjectTemplateCollection*) collection;
+ (ItsBetaObjectTemplateCollection*) collectionWithArray:(NSArray*)array;

- (id) initWithArray:(NSArray*)array;

- (void) addObjectTemplate:(ItsBetaObjectTemplate*)objectTemplate;
- (void) setObjectTemplates:(ItsBetaObjectTemplateCollection*)objectTemplates;
- (ItsBetaObjectTemplate*) objectTemplateAtIndex:(NSUInteger)index;
- (ItsBetaObjectTemplate*) objectTemplateAtId:(NSString*)Id;
- (ItsBetaObjectTemplate*) objectTemplateAtName:(NSString*)name;

@end

/*--------------------------------------------------*/
