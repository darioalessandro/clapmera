//
//  GMURLConnection.h
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/25/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GMURLConnection;

typedef void (^GMURLConnectionHandler)(GMURLConnection *connection,
NSError *error,
NSURLResponse *response,
NSData *responseData);

@interface GMURLConnection : NSObject <NSURLConnectionDelegate, NSURLConnectionDataDelegate>

    - (GMURLConnection *)initWithRequest:(NSURLRequest *)request
                       completionHandler:(GMURLConnectionHandler)handler;
@end


