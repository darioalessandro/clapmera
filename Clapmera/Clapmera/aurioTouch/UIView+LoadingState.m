//
//  UIView+LoadingState.m
//  EcoHub
//
//  Created by Dario Lencina on 2/14/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "UIView+LoadingState.h"
#import <objc/runtime.h>
#import <QuartzCore/QuartzCore.h>
#import "NetworkActivityIndicatorManager.h"


#define SG_UIViewLoadingState @"SG_UIViewLoadingState"
#define SG_ReloadView          @"SG_ReloadView"
#define SG_LoadingView          @"SG_LoadingView"

@implementation UIView (LoadingState)

-(void)addFailureScreenWithMessage:(NSString *)message buttonHandler:(UIBlockButtonHandler)handler andTransitionHandler:(UIViewLoadingStateHandler)stateHandler{
    __block UIViewLoadingStateHandler _stateHandler=(stateHandler)?[stateHandler copy]:nil;
    UIView * view=[self errorView];
    UIBlockButton * reloadButton=(UIBlockButton *)[view subviews][0];
    [reloadButton handleControlEvent:UIControlEventTouchUpInside withBlock:handler];
    [self.superview addSubview:view];
    [reloadButton setTitle:message forState:UIControlStateNormal];
    view.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha=1;
        if(_stateHandler){
            _stateHandler(self);
        }
    }];
}

-(void)setState:(UIViewLoadingState)viewLoadingState withHandler:(UIViewLoadingStateHandler)handler{
    objc_setAssociatedObject(self, SG_UIViewLoadingState, [NSNumber numberWithInt:viewLoadingState], OBJC_ASSOCIATION_ASSIGN);
    switch (viewLoadingState) {
        case UIViewLoadingStateDone:
        {
            __block UIViewLoadingStateHandler _handler=handler;
            [self removeFailureScreenWithHandler:^(UIView *view) {
                [self removeLoadingScreenWithHandler:NULL];
                [[NetworkActivityIndicatorManager sharedManager] stopSpinning];
                _handler(self);
            }];

        }
            break;
        case UIViewLoadingStateInProgressBlocking:
            [self startLoadingWithHandler:handler];
            break;
        default:
            [[NetworkActivityIndicatorManager sharedManager] startSpinning];
            handler(self);
            break;
    }
}

-(void)removeFailureScreenWithHandler:(UIViewLoadingStateHandler)handler{
    __block UIViewLoadingStateHandler _handler=handler;
    UIView * errorView=[self errorView];
    [UIView animateWithDuration:0.5 animations:^{
        [errorView setAlpha:0];
    } completion:^(BOOL finished) {
        [errorView removeFromSuperview];
        objc_setAssociatedObject(self, SG_ReloadView, nil, OBJC_ASSOCIATION_RETAIN);
        if(_handler){
            _handler(self);
        }
    }];
}

-(void)removeLoadingScreenWithHandler:(UIViewLoadingStateHandler)handler{
    __block UIViewLoadingStateHandler _handler=handler;
    UIView * loadingView=[self loadingView];
    [UIView animateWithDuration:0.5 animations:^{
        [loadingView setAlpha:0];
    } completion:^(BOOL finished) {
        [loadingView removeFromSuperview];
        objc_setAssociatedObject(self, SG_LoadingView, nil, OBJC_ASSOCIATION_RETAIN);
        if(_handler){
            _handler(self);
        }
    }];
}

-(void)startLoadingWithHandler:(UIViewLoadingStateHandler)handler{
    __block UIViewLoadingStateHandler _handler=handler;
    UIView * view=[self loadingView];
    [self.superview addSubview:view];
    view.alpha=0;
    [UIView animateWithDuration:0.5 animations:^{
        view.alpha=0.6;
    } completion:^(BOOL finished) {
        _handler(self);
    }];
}

-(UIView *)errorView{
    UIView * errorView=objc_getAssociatedObject(self, SG_ReloadView);
    if(!errorView){
        errorView=[[NSBundle mainBundle] loadNibNamed:@"ReloadView" owner:nil options:nil][0];
        [errorView setFrame:self.frame];
        objc_setAssociatedObject(self, SG_ReloadView, errorView, OBJC_ASSOCIATION_RETAIN);
    }
    return errorView;
}

-(UIView *)loadingView{
    UIView * loadingView=objc_getAssociatedObject(self, SG_LoadingView);
    if(!loadingView){
        loadingView=[[NSBundle mainBundle] loadNibNamed:@"LoadingView" owner:nil options:nil][0];
        [loadingView setFrame:self.frame];
        objc_setAssociatedObject(self, SG_LoadingView, loadingView, OBJC_ASSOCIATION_RETAIN);
    }
    return loadingView;
}

-(UIViewLoadingState)loadingState{
    NSNumber * state=objc_getAssociatedObject(self, SG_UIViewLoadingState);
    return (state)?[state intValue]:UIViewLoadingStateDone;
}

@end
