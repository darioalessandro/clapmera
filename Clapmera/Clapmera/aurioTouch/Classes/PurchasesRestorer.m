//  Created by Dario Lencina on 6/16/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import "PurchasesRestorer.h"
#import "SharedConstants.h"


@implementation PurchasesRestorer
@synthesize numberOfLawsToRestore;

#pragma -
#pragma Constructor

-(id)init{
	self= [super init];
	if(self){
		self.queriesArray= [NSMutableArray array];
	}
	return self;
}

#pragma mark - UIAlertViewDelegate

-(void)showSyncError:(NSError *)error{
    NSString * format= NSLocalizedString(@"%@, ¿Desea intentar nuevamente?",nil);
    NSString * message= [NSString stringWithFormat:format, [error localizedDescription]];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Si", nil) otherButtonTitles:NSLocalizedString(@"No", nil), nil];
    [alert setDelegate:self];
    [alert show];
}


-(void)errorHappened:(NSError *)error withRestorer:(PurchasesRestorer *)restorer{
    BFLog(@"error %@", error);
}

-(void)syncDBWithCompletedTransactionsQueue:(SKPaymentQueue *)queue{
    BFLog(@"queue %@", queue.transactions);
    for(SKPaymentTransaction * transaction in queue.transactions){
        [queue removeTransactionObserver:self];
    }
    [self.delegate didEndedSync:self];
}

-(void)showAlertToRestore{
    NSString * message= [NSString stringWithFormat:NSLocalizedString(@"¿Desea sincronizar su %@ con los productos previamente comprados en la AppStore (gratuitamente)?",nil), [[UIDevice currentDevice] model]];
    UIAlertView * alert= [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"AppName", nil) message:message delegate:self cancelButtonTitle:NSLocalizedString(@"Si", nil) otherButtonTitles:NSLocalizedString(@"No",nil), nil];
    [alert setDelegate:self];
    [alert show];
}

-(void)processTransactions:(NSArray *)transactions{
    if(transactions==nil || [transactions count]<=0)
        return;
    
    BFLog(@"number of transactions %d", [transactions count]);
    for(SKPaymentTransaction * transaction in transactions){
        switch ([transaction transactionState]) {
            case SKPaymentTransactionStateRestored:
                BFLog(@"SKPaymentTransactionStateRestored");
                BFLog(@"producto %@", transaction.payment.productIdentifier);
                if([transaction.payment.productIdentifier isEqualToString:upgrades_GoProFeatureId]){
                    [self.delegate setDidUserBuyProVersion:TRUE];
                }
                break;
                
            default:
                break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue{
    [self.progressView setProgress:0.5];
    [queue removeTransactionObserver:self];
    
    NSArray * transactions= queue.transactions;
    [self processTransactions:transactions];
    [self syncDBWithCompletedTransactionsQueue:queue];
}

-(void)paymentQueue:(SKPaymentQueue *)queue restoreCompletedTransactionsFailedWithError:(NSError *)error{
    [self showSyncError:error];
}

-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions{
    [self.progressView setProgress:0.5];
    [self processTransactions:transactions];
}

#pragma mark - UIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        SKPaymentQueue * queue= [SKPaymentQueue defaultQueue];
        [queue restoreCompletedTransactions];
        [queue addTransactionObserver:self];
    }else{
        SKPaymentQueue * queue= [SKPaymentQueue defaultQueue];
        [queue removeTransactionObserver:self];
        [self.delegate didEndedSync:self];
    }
}


@end
