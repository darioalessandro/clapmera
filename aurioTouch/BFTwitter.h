//
//  BFTwitter.h
//  Graphic tweets
//
//  Created by Dario Lencina on 10/20/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import "TwitterAccountPickerViewController.h"

typedef void(^BFTwitterEnablerHandler)(BOOL enabled, NSError *error);
typedef void(^BFTTwitterImageHandler)(UIImage * image, NSError *error);

@protocol BFTwitterMessage <NSObject>

-(NSData *)tweetImageData;
-(NSString *)tweetMessage;

@end

@interface BFTwitter : NSObject <TwitterAccountPickerViewControllerDelegate>
    +(BFTwitter *)sharedClient;
    -(void)tweet:(id)tweet withResponseHandler:(SLRequestHandler)handler;
    -(void)initIfEnabled;
    -(BOOL)isSharingEnabled;
    -(void)shouldEnableSharing:(BOOL)enable context:(UIViewController *)controller withHandler:(BFTwitterEnablerHandler)handler;
    -(void)imageForActiveUserProfile:(BFTTwitterImageHandler)handler;
    -(void)imageForUser:(ACAccount *)account withHandler:(BFTTwitterImageHandler)handler;
    @property(nonatomic,strong)ACAccount * activeAccount;
    @property(nonatomic, copy)BFTwitterEnablerHandler twitterPickerHandler;
@end

