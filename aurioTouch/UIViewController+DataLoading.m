//
//  UIViewController+DataLoading.m
//  EcoHub
//
//  Created by Dario Lencina on 2/27/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "UIViewController+DataLoading.h"
#import "UIView+LoadingState.h"

@implementation UIViewController (DataLoading)

-(void)addFailureScreenForError:(NSError *)error{
    __block UIViewController <UIViewControllerDataLoading> * this=(id)self;
    NSString * errorString=[NSString stringWithFormat:@"Network Error, tap to refresh.(%ld)", (long)[error code]];
    [self.view addFailureScreenWithMessage:errorString buttonHandler:^(UIView *button) {
        __block id<UIViewControllerDataLoading> this2=this;
        [this.view setState:UIViewLoadingStateDone withHandler:^(UIView *view) {
            [this2 reloadDataFromService];
        }];
    } andTransitionHandler:NULL];
}

@end
