//
//  TwitterAccountPickerViewController.h
//  GraphicTweets
//
//  Created by Dario Lencina on 2/23/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>

@interface TwitterAccountPickerViewController : UITableViewController
    @property(nonatomic, strong) NSArray * twitterAccounts;
    @property(nonatomic, weak) id delegate;
@end

@protocol TwitterAccountPickerViewControllerDelegate <NSObject>
    -(void)userDidSelectedTwitterAccount:(ACAccount *)account;
@end