//
//  SystemSpinnerManager.m
//  EcoHub
//
//  Created by Dario Lencina on 3/1/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "NetworkActivityIndicatorManager.h"
static NetworkActivityIndicatorManager * _manager;

@interface NetworkActivityIndicatorManager  ()
@property(nonatomic, assign) NSInteger votes;
@end


@implementation NetworkActivityIndicatorManager

+(NetworkActivityIndicatorManager *)sharedManager{
    if(!_manager){
        _manager=[NetworkActivityIndicatorManager new];
    }
    return _manager;
}

-(void)startSpinning{
    self.votes++;
    [self updateSpinner];
}

-(void)stopSpinning{
    self.votes--;
    if(self.votes<0)
        self.votes=0;
    [self updateSpinner];
}

-(void)updateSpinner{
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:self.votes>0];
}

@end
