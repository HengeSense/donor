/*--------------------------------------------------*/

#import <Foundation/Foundation.h>

/*--------------------------------------------------*/

@interface NSString (ItsBeta)

- (NSString*) stringByDecodingURLFormat;
- (NSString*) stringByEncodingURLFormat;
- (NSMutableDictionary*) dictionaryFromQueryComponents;

@end

/*--------------------------------------------------*/
