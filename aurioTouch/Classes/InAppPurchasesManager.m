//
//  InAppPurchasesManager.m
//  Clapmera
//
//  Created by Dario Lencina on 5/4/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "InAppPurchasesManager.h"
#import "GAITracker.h"
#import "CPConfiguration.h"
#define kMaxNumberOfPicsAllowed 1000

static InAppPurchasesManager * _manager= nil;

@interface InAppPurchasesManager ()
@property(nonatomic, copy)  InAppPurchasesManagerHandler buyProVersionHandler;
@property(nonatomic, copy)  InAppPurchasesManagerHandler buy24PicsHandler;
@end

@implementation InAppPurchasesManager{
    SKProductsRequest * req;
}

@synthesize products;

+(InAppPurchasesManager *)sharedManager{
    if(_manager==nil){
        _manager= [[InAppPurchasesManager alloc] init];
    }
    return _manager;
}

-(BOOL)isInProgress{
    NSArray * transactions=[[SKPaymentQueue defaultQueue] transactions];
    BOOL isInProgress=transactions!=nil;
    if(isInProgress){
        isInProgress=[transactions count]>0;
    }
    return isInProgress;
}

-(void)userWantsToBuyGoProFeature:(InAppPurchasesManagerHandler)handler{
        self.buyProVersionHandler=handler;
    if(self.products){
        if([self.products count]<=0){
            self.buyProVersionHandler(self, [NSError errorWithDomain:@"404" code:123 userInfo:nil]);
        }
        SKProduct * product= [self productWithIdentifier:upgrades_GoProFeatureId];
        SKPayment * payment= [SKPayment paymentWithProduct:product];
        SKPaymentQueue * queue= [SKPaymentQueue defaultQueue];
        [queue addPayment:payment];
        [queue addTransactionObserver:self];
    }else{
        if(self.productRefreshHandler){
            [self reloadProductsWithHandler:self.productRefreshHandler];
        }else{
            [self reloadProductsWithHandler:NULL];
        }
    }
}

-(SKProduct *)productWithIdentifier:(NSString *)identifier{
    if([self.products count]<=0){
        return nil;
    }
    NSArray * filteredArray=[self.products filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(SKProduct * evaluatedObject, NSDictionary *bindings) {
        return [evaluatedObject.productIdentifier isEqualToString:identifier];
    }]];
    return filteredArray[0];
}

-(BOOL)didUserBuyProVersion{
    BOOL didBuyiAds=FALSE;
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    if([defaults objectForKey:didBuyGoProFeature]){
        didBuyiAds= [defaults boolForKey:didBuyGoProFeature];
    }
    return didBuyiAds;
}

-(void)setDidUserBuyProVersion:(BOOL)didBuyFeature{
    if(didBuyFeature){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"ShouldRunProVersion" object:nil];
    }
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    [defaults setBool:didBuyFeature forKey:didBuyGoProFeature];
    [defaults synchronize];
}

-(void)reloadProductsWithHandler:(InAppPurchasesManagerHandler)handler{
    if(req){
        req.delegate=nil;
        req=nil;
    }
    self.productRefreshHandler=handler;
    NSSet * _products= [NSSet setWithObjects:upgrades_GoProFeatureId,upgrades_Buy24PicsFeatureId,nil];
    req= [[SKProductsRequest alloc] initWithProductIdentifiers:_products];
    [req setDelegate:self];
    [req start];
}

#pragma -
#pragma StoreKit Delegate

-(void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response{
	BFLog(@"request %@", request);
    if(response.products){
        self.products= response.products;
    }
    NSNumberFormatter *currencyStyle = [self currencyFormatter];
        	
    for(SKProduct * product in response.products){
        [currencyStyle setLocale:product.priceLocale];
        BFLog(@"product %@ price %@ localizedPrice %@ %@", product.productIdentifier, product.price, [currencyStyle stringFromNumber:product.price], product.localizedTitle);
    }
    if(self.productRefreshHandler)
        self.productRefreshHandler(self, nil);
}

-(NSNumberFormatter *)currencyFormatter{
    NSNumberFormatter *currencyStyle = [[NSNumberFormatter alloc] init];
    [currencyStyle setFormatterBehavior:NSNumberFormatterBehavior10_4];
    [currencyStyle setNumberStyle:NSNumberFormatterCurrencyStyle];
    return currencyStyle;
}

-(void)lacompraFallo:(NSError *)error{
    if(self.buyProVersionHandler)
        self.buyProVersionHandler(self, error);
}

-(void)request:(SKRequest *)request didFailWithError:(NSError *)error{
    if(self.productRefreshHandler)
        self.productRefreshHandler(self, error);
}  

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    BFLog(@"number of transactions %@", @([transactions count]));
	for(SKPaymentTransaction * transaction in transactions){
        NSString * productId=[[transaction payment] productIdentifier];
        switch ([transaction transactionState]) {
            case SKPaymentTransactionStatePurchasing:
                BFLog(@"SKPaymentTransactionStatePurchasing");
                break;
            case SKPaymentTransactionStateRestored:                
            case SKPaymentTransactionStatePurchased:{
                BFLog(@"SKPaymentTransactionStatePurchased");
                [queue finishTransaction:transaction];                
                if([productId isEqualToString:upgrades_GoProFeatureId]){
                    [self setDidUserBuyProVersion:TRUE];
                    if(self.buyProVersionHandler)
                        self.buyProVersionHandler(self, nil);
                }else if([productId isEqualToString:upgrades_Buy24PicsFeatureId]){
                    if(self.buy24PicsHandler)
                        self.buy24PicsHandler(self, nil);
                }
                
            }
            break;
                
            case SKPaymentTransactionStateFailed:
            default:
                BFLog(@"SKPaymentTransactionStateFailed");
                BFLog(@"transaction %@", transaction.error);
                [queue finishTransaction:transaction];
                if([productId isEqualToString:upgrades_GoProFeatureId]){
                    if(self.buyProVersionHandler)
                        self.buyProVersionHandler(self, transaction.error);
                }else if([productId isEqualToString:upgrades_Buy24PicsFeatureId]){
                    if(self.buy24PicsHandler)
                        self.buy24PicsHandler(self, transaction.error);
                }
            break;
        }           
	}
}

-(void)restorePurchasesWithHandler:(InAppPurchasesManagerHandler)handler{
    self.buyProVersionHandler=handler;
    PurchasesRestorer * _sync= [PurchasesRestorer new];
    self.purchasesRestorer= _sync;
    self.purchasesRestorer.delegate=self;
    [self.purchasesRestorer showAlertToRestore];
}

-(void)errorHappened:(NSError *)error withRestorer:(PurchasesRestorer *)restorer{
    BFLog(@"error %@", error);
    self.buyProVersionHandler(self, error);
}

-(void)didEndedSync:(PurchasesRestorer *)restorer{
    [self setPurchasesRestorer:nil];
    self.buyProVersionHandler(self, nil);
}


@end
