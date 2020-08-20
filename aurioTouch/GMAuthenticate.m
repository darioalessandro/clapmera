//
//  GMAuthenticate.m
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/25/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMAuthenticate.h"
#import "SBJson.h"
#import "NSData+Base64Additions.h"

@implementation GMAuthenticate

-(void)main{
    self.connection= [[GMURLConnection alloc] initWithRequest:[self urlRequest] completionHandler:^(GMURLConnection *connection, NSError *error, NSURLResponse *response, NSData *responseData) {
        if(error){
            self.error=error;
        }else{
            SBJsonParser * parser=[SBJsonParser new];
            id object=[parser objectWithData:responseData];
            self.jsonResponse= object;
            BFLog(@"response %@", self.jsonResponse);
        }
        self.connectionFinishedLoading=TRUE;
    }];
    while (self.connectionFinishedLoading==NO) {
        [[NSRunLoop currentRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:1]];
    }
}

-(NSURLRequest *)urlRequest{
    NSURL * loginURL=[NSURL URLWithString:@"https://develcom/api/v1/oauth/access_token"];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc] initWithURL:loginURL];
    [request setValue:[self authorizationHeaderValue] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

-(NSString *)authorizationHeaderValue{
    NSString * plainUsernameAndPass=[NSString stringWithFormat:@"%@:%@", [[GMSession activeSession] APIKey], [[GMSession activeSession] APISecret]];
    NSString * base64EncodedCredentials= [[plainUsernameAndPass dataUsingEncoding:NSUTF8StringEncoding] encodeBase64ForData];
    return [NSString stringWithFormat:@"Basic %@", base64EncodedCredentials];
}

@end
