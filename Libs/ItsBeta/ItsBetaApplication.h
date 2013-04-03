/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

typedef void (^ItsBetaApplicationSynchronized)();

/*--------------------------------------------------*/

@interface ItsBetaApplication : NSObject< NSCoding >

@property(nonatomic, readwrite, retain) NSString* serviceURL; // Базовый URL сервиса
@property(nonatomic, readwrite, retain) NSString* accessToken; // Уникальный ключ доступа
@property(nonatomic, readwrite, retain) NSString* locale; // Язык

@property(nonatomic, readonly) ItsBetaCategoryCollection* categories;
@property(nonatomic, readonly) ItsBetaProjectCollection* projects;

@property(nonatomic, readwrite, retain) NSArray* projectWhiteList;
@property(nonatomic, readwrite, retain) NSArray* projectBlackList;

+ (ItsBetaApplication*) application;

- (BOOL) synchronizeASync;
- (BOOL) synchronizeSync;

@end

/*--------------------------------------------------*/
