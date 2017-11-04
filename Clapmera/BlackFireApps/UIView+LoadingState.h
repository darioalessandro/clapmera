//
//  UIView+LoadingState.h
//  EcoHub
//
//  Created by Dario Lencina on 2/14/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIBlockButton.h"

typedef enum UIViewLoadingState{
    UIViewLoadingStateDone,
    UIViewLoadingStateInProgress,
    UIViewLoadingStateInProgressBlocking,
    UIViewLoadingStateFailed
} UIViewLoadingState;

typedef void (^UIViewLoadingStateHandler)(UIView * view);

@interface UIView (LoadingState)

-(void)setState:(UIViewLoadingState)viewLoadingState withHandler:(UIViewLoadingStateHandler)handler;
-(UIViewLoadingState)loadingState;
-(void)addFailureScreenWithMessage:(NSString *)message buttonHandler:(UIBlockButtonHandler)handler andTransitionHandler:(UIViewLoadingStateHandler)stateHandler;
@end
