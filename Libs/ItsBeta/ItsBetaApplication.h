/*--------------------------------------------------*/

#import "ItsBetaCore.h"

/*--------------------------------------------------*/

typedef void (^ItsBetaApplicationSynchronized)();

/*--------------------------------------------------*/

@interface ItsBetaApplication : NSObject< NSCoding >

@property(nonatomic, readwrite, retain) NSString* serviceURL; // Базовый URL сервиса
@property(nonatomic, readwrite, retain) NSString* accessToken; // Уникальный ключ доступа
@property(nonatomic, readwrite, retain) NSString* locale; // Язык
@property(nonatomic, assign) id< ItsBetaApplicationDelegate > delegate;

@property(nonatomic, readonly) ItsBetaCategoryCollection* categories;
@property(nonatomic, readonly) ItsBetaProjectCollection* projects;

+ (ItsBetaApplication*) application;

- (BOOL) synchronizeASync;
- (BOOL) synchronizeSync;

@end

/*--------------------------------------------------*/

@protocol ItsBetaApplicationDelegate < NSObject >

@optional
- (BOOL) itsbetaApplication:(ItsBetaApplication*)application synchronizeProject:(ItsBetaProject*)project;

@end

/*--------------------------------------------------*/
