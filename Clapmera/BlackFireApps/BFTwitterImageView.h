//
//  BFTwitterImageView.h
//  Graphic tweets
//
//  Created by Dario Lencina on 10/20/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>

@interface BFTwitterImageView : UIImageView
    @property (nonatomic, strong) NSString * username;
    @property (nonatomic, strong) ACAccount * account;
    -(void)refreshImageProfile;
    -(void)refreshImage;
@end
