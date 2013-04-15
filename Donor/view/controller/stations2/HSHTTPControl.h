///////////////////////////////////////////////////////////////
//                  Hintsolutions, 2013
//                  Evgeniy Korobovskiy
//                  All rights reserved
///////////////////////////////////////////////////////////////

#import <Foundation/Foundation.h>

enum{
    HSHTTPMethodGET=0,
    HSHTTPMethodPOST
};
typedef NSUInteger HSHTTPMethod;

@interface HSSingleReqest: NSObject {
    //Общие объекты для выполнения соедиения
    NSMutableURLRequest *urlRequest;
    NSURLConnection *urlConnection;
};

//Идентификаторы запроса
@property (nonatomic, strong) id requestID;
@property (nonatomic, strong) id userInfo;

//Параметры запроса
@property (nonatomic, strong) NSString *url;
@property (nonatomic) HSHTTPMethod method;
@property (nonatomic, strong) id requestData;
@property (nonatomic, strong) NSString *contentType;
@property (nonatomic, strong) NSString *xRequestWith;

//Результат запроса
@property (nonatomic, readonly) NSInteger responseCode;
@property (nonatomic, readonly) NSMutableData *resultData;

//Передача управления после выполнения запроса
@property (nonatomic, assign) id delegate;
@property (nonatomic) SEL callback;
@property (nonatomic) SEL errorCallback;

//Поля используются для хранения необходимых данных вызываемым объектом, этим интерфейсом не используются
@property (nonatomic, assign) id topLevelDelegate;
@property (nonatomic) SEL topLevelCallback;
@property (nonatomic) SEL topLevelErrorCallback;

//Инициализация
- (id)init;
- (id)initWithID:(id)reqID;
- (id)initWithURL:(NSString*)_url andDelegate:(id)_delegate andCallbackFunction:(SEL)_callback andErrorCallBackFunction:(SEL)_errorCallback;

//Управление запросом
- (BOOL)sendRequest;
- (BOOL)sendRequestWithoutAddingPercentEscapes;
- (BOOL)stopRequest;

//Заменить служебные символы процентами %20 etc
+ (NSString*)addPerfectPercentEscapes:(NSString*)str;

//Создание тела запроса для изображения
- (NSMutableData*)generatePostBodyForImage:(UIImage*)img;


@end
