//
//  RKHTTPRequestOperation+Curl.m
//  MySTC
//
//  Created by Sam Watts on 14/03/2013.
//
//

#import "RKHTTPRequestOperation+Curl.h"

@implementation RKHTTPRequestOperation (Curl)

- (NSString *)curlString
{
    NSMutableString *headerString = [NSMutableString string];
    [self.request.allHTTPHeaderFields enumerateKeysAndObjectsUsingBlock:^(NSString *headerKey, NSString *headerValue, BOOL *stop) {
        [headerString appendFormat:@"-H \"%@: %@\" ", headerKey, headerValue];
    }];
    
    NSString *dataString = @"";
    if (self.request.HTTPBody)
    {
        NSString *HTTPBodyString = [[NSString alloc] initWithData:self.request.HTTPBody encoding:NSUTF8StringEncoding];
        dataString = [NSString stringWithFormat:@"-d \"%@\"", HTTPBodyString];
    }
    
    
    NSString *curlString = [NSString stringWithFormat:@"curl -i %@ %@ -X %@ %@", headerString, dataString, self.request.HTTPMethod, [self.request URL]];
    
    NSLog(@"curl string %@", curlString);
    
    
    return curlString;
}

@end
