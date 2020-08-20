//
//  BFAlienSwitch.h
//  BFAlienSwitch
//
//  Created by Dario Lencina on 11/10/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BFAlienSwitch;
typedef void(^BFAlienSwitchHandler)(BFAlienSwitch * alienSwitch);

typedef enum BFAlienSwitchTransitionState {
        BFAlienSwitchTransitionStateStarted,
        BFAlienSwitchTransitionStateInProgress,
        BFAlienSwitchTransitionStateDone
    } BFAlienSwitchTransitionState;

@interface BFAlienSwitch : UIView

+(BFAlienSwitch *)alienSwitchWithHandler:(BFAlienSwitchHandler) handler;
-(void)setHandler:(BFAlienSwitchHandler) handler;
@property(nonatomic, getter=isOn)BOOL on;

@end
