//
//  BFTwitterImageView.m
//  Graphic tweets
//
//  Created by Dario Lencina on 10/20/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "BFTwitterImageView.h"
#import "BFTwitter.h"
#import <Accounts/Accounts.h>
#import "BFLog.h"

@implementation BFTwitterImageView

-(void)awakeFromNib{
  //  [self refreshImageProfile];
}

-(void)refreshImage{
    BFLog(@"self.account %@", self.account.username);
    [[BFTwitter sharedClient] imageForUser:self.account withHandler:^(UIImage *image, NSError *error) {
        UIImage * img= image;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self setImage:img];
        }];
    }];
}

-(void)refreshImageProfile{
    if([self isRefreshRequiredForUsername:[[[BFTwitter sharedClient] activeAccount] username]]){
        if([[BFTwitter sharedClient] isSharingEnabled]){
            [[BFTwitter sharedClient] imageForActiveUserProfile:^(UIImage * image, NSError * error){
                if (image) {
                    [self setUsername:[[[BFTwitter sharedClient] activeAccount] username]];
                }
                UIImage * img= image;
                [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                    [self setImage:img];
                }];
            }];
        }
    }
}

-(BOOL)isRefreshRequiredForUsername:(NSString *)username{
    BOOL isRefreshRequired=NO;
    if (![self image]) {
        isRefreshRequired=YES;
    }else if(![self username]){
        isRefreshRequired=YES;
    }else if(![[self username] isEqualToString:username]){
        isRefreshRequired=YES;
    }
    return isRefreshRequired;
}

@end
