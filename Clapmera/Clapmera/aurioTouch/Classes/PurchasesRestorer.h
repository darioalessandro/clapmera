//  Created by Dario Lencina on 6/16/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import <StoreKit/StoreKit.h>

@interface PurchasesRestorer : NSObject <SKPaymentTransactionObserver> {

}

-(void)showSyncError:(NSError *)error;

@property(nonatomic, strong)    UIProgressView * progressView;
@property (strong)              NSMutableArray * queriesArray;
@property (assign)              id delegate;
@property(nonatomic, assign)    NSInteger numberOfLawsToRestore;

-(void)syncDBWithCompletedTransactionsQueue:(SKPaymentQueue *)queue;
-(void)showAlertToRestore;

@end

@protocol PurchasesRestorerDelegate <NSObject>
@required
    -(void)didEndedSync:(PurchasesRestorer *)restorer;
    -(void)errorHappened:(NSError *)error withRestorer:(PurchasesRestorer *)restorer ;
    -(void)setDidUserBuyProVersion:(BOOL)didBuyFeature;
@end

