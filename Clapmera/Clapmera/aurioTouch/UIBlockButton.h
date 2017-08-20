//
//  UIBlockButton.h
//  EcoHub
//
//  Created by Dario Lencina on 2/25/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UIBlockButton;
typedef void (^UIBlockButtonHandler)(UIBlockButton * button);

@interface UIBlockButton : UIButton
@property(nonatomic, copy) UIBlockButtonHandler handler;
-(void) handleControlEvent:(UIControlEvents)event
                 withBlock:(UIBlockButtonHandler) handler;
@end
