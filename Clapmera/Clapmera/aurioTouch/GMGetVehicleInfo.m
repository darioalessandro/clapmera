//
//  GMGetVehicleInfo.m
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/26/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMGetVehicleInfo.h"
#import "SBJson.h"

@implementation GMGetVehicleInfo

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
    NSURL * loginURL=[NSURL URLWithString:@"https://develocom/api/v1/account/vehicles/1G6DH5E53C000003"];
    NSMutableURLRequest * request=[[NSMutableURLRequest alloc] initWithURL:loginURL];
    [request setValue:[self authenticationBearerHeader] forHTTPHeaderField:@"Authorization"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    return request;
}

-(NSString *)authenticationBearerHeader{
    return [NSString stringWithFormat:@"Bearer %@", [[GMSession activeSession] accessToken]];
}

@end
