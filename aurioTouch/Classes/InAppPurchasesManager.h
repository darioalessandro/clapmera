//
//  InAppPurchasesManager.h
//  Clapmera
//
//  Created by Dario Lencina on 5/4/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//
/*
 * @description: The job of this guy is to make sure that our controllers are clean from purchases code, all the request to the AppStore should go through this
 guy.
 
 This guy talks to the Controllers through Notifications, those notifications are defined in the SharedControllers
 */

#import <Foundation/Foundation.h>
#import "SharedConstants.h"
#import <StoreKit/StoreKit.h>
#import "PurchasesRestorer.h"

@class InAppPurchasesManager;
typedef void(^InAppPurchasesManagerHandler)(InAppPurchasesManager * purchasesManager, NSError *error);

@interface InAppPurchasesManager : NSObject <SKProductsRequestDelegate, SKPaymentTransactionObserver, PurchasesRestorerDelegate>
    @property(nonatomic, strong)    NSArray * products;
    @property(nonatomic, strong)    PurchasesRestorer * purchasesRestorer;
    @property(nonatomic, copy)  InAppPurchasesManagerHandler productRefreshHandler;

    +(InAppPurchasesManager *)sharedManager;
    -(void)userWantsToBuyGoProFeature:(InAppPurchasesManagerHandler)handler;
    -(BOOL)didUserBuyProVersion;
    -(SKProduct *)productWithIdentifier:(NSString *)identifier;
    -(void)reloadProductsWithHandler:(InAppPurchasesManagerHandler)handler;
    -(NSNumberFormatter *)currencyFormatter;
    -(void)restorePurchasesWithHandler:(InAppPurchasesManagerHandler)handler;
    -(BOOL)isInProgress;
@end
