//
//  GMServiceClient.h
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/28/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMService.h"

@interface GMServiceClient : NSObject
+(GMServiceClient *)sharedClient;
-(void)executeService:(GMService *)service withCompletionHandler:(void (^)(void))handler;

@end
