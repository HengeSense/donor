/*--------------------------------------------------*/

#import "NSString+ItsBeta.h"

/*--------------------------------------------------*/

@implementation NSString (ItsBeta)

- (NSString*) stringByDecodingURLFormat {
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*) stringByEncodingURLFormat {
    return [[self stringByReplacingOccurrencesOfString:@" " withString:@"+"] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSMutableDictionary*) dictionaryFromQueryComponents {
    NSMutableDictionary* queryComponents = [NSMutableDictionary dictionary];
    for(NSString* keyValuePairString in [self componentsSeparatedByString:@"&"]) {
        NSArray* keyValuePairArray = [keyValuePairString componentsSeparatedByString:@"="];
        if([keyValuePairArray count] < 2) {
            continue;
        }
        NSString* key = [[keyValuePairArray objectAtIndex:0] stringByDecodingURLFormat];
        NSString* value = [[keyValuePairArray objectAtIndex:1] stringByDecodingURLFormat];
        NSMutableArray* results = [queryComponents objectForKey:key];
        if(results == nil) {
            results = [NSMutableArray arrayWithCapacity:1];
            [queryComponents setObject:results forKey:key];
        }
        [results addObject:value];
    }
    return queryComponents;
}

@end

/*--------------------------------------------------*/