//
//  RMTabBarControllerViewController.h
//  Graphic tweets
//
//  Created by Dario Lencina on 9/9/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>
#define RMMenuView @"BFATabBarControllerMenuView"

@interface BFATabBarController : UITabBarController <UITableViewDataSource, UITableViewDelegate, UITabBarControllerDelegate>
    @property(strong, nonatomic) UITableView * menuOptions;
    @property(strong, nonatomic) UIButton * menuButton;
    @property(strong, nonatomic) UIView * menuBackground;
    -(void)toggleMenuOptions;
    -(void)setMenuVisible:(BOOL)visible;
@end
