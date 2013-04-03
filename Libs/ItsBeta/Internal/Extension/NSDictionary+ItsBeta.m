/*--------------------------------------------------*/

#import "NSDictionary+ItsBeta.h"
#import "NSString+ItsBeta.h"

/*--------------------------------------------------*/

@implementation NSDictionary (ItsBeta)

- (NSString*) stringFromQueryComponents {
    NSString* result = nil;
    for(NSString* dictKey in [self allKeys]) {
        NSString* key = [dictKey stringByEncodingURLFormat];
        NSArray* allValues = [self objectForKey:key];
        if([allValues isKindOfClass:[NSArray class]]) {
            for(NSString* dictValue in allValues) {
                NSString* value = [[value description] stringByEncodingURLFormat];
                if(result == nil) {
                    result = [NSString stringWithFormat:@"%@=%@",key,value];
                } else {
                    result = [result stringByAppendingFormat:@"&%@=%@",key,value];
                }
            }
        } else {
            NSString* value = [[allValues description] stringByEncodingURLFormat];
            if(result == nil) {
                result = [NSString stringWithFormat:@"%@=%@",key,value];
            } else {
                result = [result stringByAppendingFormat:@"&%@=%@",key,value];
            }
        }
    }
    return result;
}

@end

/*--------------------------------------------------*/