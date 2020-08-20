//
//  NSMutableHTTPURLRequest+CurlDescription.m
//  Easy to read and use Curl description for NSMutableURLRequest
//
//  Created by Mugunth Kumar on 7/11/11.
//  Copyright (c) 2011 Steinlogic. All rights reserved.
//
//  As a side note on using this code, you might consider giving some credit to me by
//	1) linking my website from your app's website 
//	2) or crediting me inside the app's credits page 
//	3) or a tweet mentioning @mugunthkumar
//	4) A paypal donation to mugunth.kumar@gmail.com
//
//  A note on redistribution
//	if you are re-publishing after editing, please retain the above copyright notices

#import "NSMutableURLRequest+CurlDescription.h"


@implementation NSMutableURLRequest (CurlDescription)

- (NSString *)description
{
    __block NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\ncurl -X %@", 
                                              [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]],
                                              [self HTTPMethod]];
    
    [[self allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop)
     {
         [displayString appendFormat:@" -H \"%@: %@\"", key, val];
     }];
    
    [displayString appendFormat:@" \"%@\"",  [self.URL absoluteString]];
    
    if ([[self HTTPMethod] isEqualToString:@"POST"]) {
        NSString *bodyString = [[NSString alloc] initWithData:[self HTTPBody]
                                                      encoding:NSUTF8StringEncoding] ;
        [displayString appendFormat:@" -d \"%@\"", bodyString];        
    }
    
    return displayString;
}
@end

@implementation NSURLRequest (CurlDescription)

- (NSString *)description
{
    __block NSMutableString *displayString = [NSMutableString stringWithFormat:@"%@\nRequest\n-------\ncurl -X %@",
                                              [[NSDate date] descriptionWithLocale:[NSLocale currentLocale]],
                                              [self HTTPMethod]];
    
    [[self allHTTPHeaderFields] enumerateKeysAndObjectsUsingBlock:^(id key, id val, BOOL *stop)
     {
         [displayString appendFormat:@" -H \"%@: %@\"", key, val];
     }];
    
    [displayString appendFormat:@" \"%@\"",  [self.URL absoluteString]];
    
    if ([[self HTTPMethod] isEqualToString:@"POST"]) {
        NSString *bodyString = [[NSString alloc] initWithData:[self HTTPBody]
                                                     encoding:NSUTF8StringEncoding] ;
        [displayString appendFormat:@" -d \"%@\"", bodyString];
    }
    
    return displayString;
}
@end
