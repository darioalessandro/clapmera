//
//  GMSession.m
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMSession.h"
#import "GMService.h"
#import "GMAuthenticate.h"
#import "GMServiceClient.h"
//#import "SGConsumptionService.h"
//#import "SGConsumptionDataParser.h"
//#import "SGCostService.h"
//#import "SGGetVoltTickerService.h"

static GMSession * _session;

@implementation GMSession{
    NSString * _APIKey;
    NSString * _APISecret;
}

+(GMSession *)activeSession{
    if(!_session){
        _session= [[GMSession alloc] _init];
        
    }
    return _session;
}

-(id)_init{
    self= [super init];
    if(self){
        _APIKey=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"GMAPIKEY"];
        _APISecret=[[[NSBundle mainBundle] infoDictionary] objectForKey:@"GMAPIKEYSECRET"];
        if(!_APIKey)
            _APIKey= @"DEFAULTKEY";
        if(!_APISecret)
            _APISecret=@"DEFAULTSECRET";
    }
    return self;
}

-(id)init{
    [NSException raise:@"Unable to init GMSession, use the +activeSession" format:@"%@", self];
    return nil;
}

-(NSString *)APIKey{
    return _APIKey;
}

-(NSString *)APISecret{
    return _APISecret;
}

-(void)authenticateWithCompletionHandler:(GMSessionCompletionHandler)handler{
    GMAuthenticate * authenticate= [GMAuthenticate new];
    [[GMServiceClient sharedClient] executeService:authenticate withCompletionHandler:^{
        if(authenticate.error){
            BFLog(@"error %@", authenticate.error);
        }else if([authenticate.jsonResponse objectForKey:@"error"]){
            authenticate.error=[NSError errorWithDomain:[authenticate.jsonResponse objectForKey:@"error"] code:200 userInfo:nil];
        }else{
            self.accessToken=[authenticate.jsonResponse objectForKey:@"access_token"];
            NSTimeInterval expires_in=[[authenticate.jsonResponse objectForKey:@"expires_in"] floatValue];
            self.expirationDate=[NSDate dateWithTimeIntervalSinceNow:expires_in];
        }
        handler(self, authenticate.error);
    }];
}

-(NSString *)description{
    NSMutableString * string= [NSMutableString string];
    [string appendFormat:@"expirationDate %@\n", self.expirationDate];
    [string appendFormat:@"accessToken    %@", self.accessToken];
    return string;
}

//-(void)getConsumptionWithHandler:(GMSessionCompletionHandler)handler{
//    SGConsumptionService * consuptionService=[SGConsumptionService new];
//    [consuptionService setPricingModel:@"MONTHLY"];
//    [consuptionService setFrequency:@"DAILY"];
//    [consuptionService setStartDate:[[NSDate date] dateByAddingTimeInterval:-604800]];
//    [consuptionService setEndDate:[NSDate date]];
//    __block GMSession * this=self;
//    [[GMServiceClient sharedClient] executeService:consuptionService withCompletionHandler:^{
//        if(!consuptionService.consumptionArray && !consuptionService.error){
//            consuptionService.error=[NSError errorWithDomain:@"There's no info for your account" code:402 userInfo:nil];
//        }
//        if(consuptionService.consumptionArray && [consuptionService.consumptionArray count]>0){
//            this.lastConsumptionArray=consuptionService.consumptionArray;
//        }
//        handler(this, consuptionService.error);
//    }];
//}
//
//-(void)getCostWithHandler:(GMSessionCompletionHandler)handler{
//    SGCostService * costService=[SGCostService new];
//    [costService setPricingModel:@"MONTHLY"];
//    [costService setFrequency:@"DAILY"];
//    [costService setStartDate:[[NSDate date] dateByAddingTimeInterval:-604800]];
//    [costService setEndDate:[NSDate date]];
//    __block GMSession * this=self;
//    [[GMServiceClient sharedClient] executeService:costService withCompletionHandler:^{
//        if(!costService.costData && !costService.error){
//            costService.error=[NSError errorWithDomain:@"There's no info for your account" code:402 userInfo:nil];
//        }
//        if(costService.costData && [costService.costData count]>0){
//            this.lastCostData=costService.costData;
//        }
//        handler(this, costService.error);
//    }];
//}
//
//-(void)getVoltTickerWithHandler:(GMSessionCompletionHandler)handler{
//    SGGetVoltTickerService * tickerService=[SGGetVoltTickerService new];
//    __block GMSession * this=self;
//    [[GMServiceClient sharedClient] executeService:tickerService withCompletionHandler:^{
//        if(tickerService.voltTicker){
//            this.lastTickerData=tickerService.voltTicker;
//        }
//        handler(this, tickerService.error);
//    }];
//}

@end
