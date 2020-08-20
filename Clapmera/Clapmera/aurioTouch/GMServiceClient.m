//
//  GMServiceClient.m
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/28/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMServiceClient.h"
#import "GMService.h"
#import "GMConfiguration.h"

static GMServiceClient * _client;

@interface GMServiceClient ()
@property(nonatomic, strong)NSOperationQueue * serviceQueue;
@end

@implementation GMServiceClient

+(GMServiceClient *)sharedClient{
    if(!_client){
        _client= [[GMServiceClient alloc] _init];
    }
    return _client;
}

-(id)_init{
    self=[super init];
    if(self){
        self.serviceQueue=[NSOperationQueue new];
    }
    return self;
}

-(id)init{
    [NSException raise:@"Unable to init GMServiceClient, use the +sharedClient" format:@"%@", self];
    return nil;
}

-(void)executeService:(GMService *)service withCompletionHandler:(void (^)(void))handler{
    if(!service){
        [NSException raise:@"unable to send nil service" format:@"You can't try to send a nil service"];
    }
    [service setCompletionBlock:handler];
    if([[[GMConfiguration sharedInstance] environment] isEqualToString:kGMConfigurationEnvironmentDevelopmentTests]){
        [self.serviceQueue performSelector:@selector(addOperation:) withObject:service afterDelay:0.5];
    }else{
        [self.serviceQueue addOperation:service];
    }
}

@end
