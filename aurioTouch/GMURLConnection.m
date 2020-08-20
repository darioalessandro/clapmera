//
//  GMURLConnection.m
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/25/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMURLConnection.h"
#import "NSMutableURLRequest+CurlDescription.h"

@interface GMURLConnection ()
    @property (nonatomic, strong) NSMutableData *data;
    @property (nonatomic, copy) GMURLConnectionHandler handler;
    @property (nonatomic, strong) NSURLResponse *response;
@end

@implementation GMURLConnection

- (GMURLConnection *)initWithRequest:(NSURLRequest *)request
               completionHandler:(GMURLConnectionHandler)handler
{
    if (self = [super init]) {
        BFLog(@"GMURLConnection will send request %@", [request description]);
        NSURLConnection * connection= [[NSURLConnection alloc] initWithRequest:request delegate:self];
        [connection start];
        self.data= [NSMutableData new];
        if(!handler){
            [NSException raise:@"Invalid handler" format:@"You can't create a GMURLConnection without handler"];
        }
        self.handler=handler;
    }
    return self;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate


//TODO: This was necesary since the server does not implement the right certificate!

//- (BOOL)connection:(NSURLConnection *)connection canAuthenticateAgainstProtectionSpace:(NSURLProtectionSpace *)protectionSpace{
//    return [protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust];
//}
//
//- (void)connection:(NSURLConnection *)connection didReceiveAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
//    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust])
//    {
//        [challenge.sender useCredential:[NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust] forAuthenticationChallenge:challenge];
//    }
//    else
//    {
//        [challenge.sender continueWithoutCredentialForAuthenticationChallenge:challenge];
//    }
//}

-(NSCachedURLResponse *)connection:(NSURLConnection *)connection
                 willCacheResponse:(NSCachedURLResponse *)cachedResponse
{
    return nil;
}

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    self.handler(self, error, nil, nil);
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [self.data appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    self.handler(self, nil, nil, self.data);
}



@end
