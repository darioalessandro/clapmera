//
//  BFFacebook.m
//  Graphic tweets
//
//  Created by Dario Lencina on 10/15/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "BFFacebook.h"
static BFFacebook * fb=nil;

@implementation BFFacebook

+(BFFacebook *)sharedInstance{
    if(!fb){
        fb= [BFFacebook new];
    }
    return fb;
}
/*
-(BOOL)isSharingEnabled{
    return [[FBSession activeSession] isOpen];
}

-(void)shouldTurnConnectOrDisconnectSession:(BOOL)on handler:(FBSessionStateHandler)handler{
    if(on==FALSE){
        if ([FBSession activeSession].isOpen) {
            [[FBSession activeSession] closeAndClearTokenInformation];
        }
    }else{
        if ([FBSession activeSession].state != FBSessionStateCreated) {
            [FBSession setActiveSession:[FBSession new]];
        }
        [[FBSession activeSession] openWithBehavior:FBSessionLoginBehaviorUseSystemAccountIfPresent completionHandler:handler];
    }
}

-(BOOL)containsReadPermissions{
    return [[FBSession activeSession].permissions containsObject:@"user_photos"];
    
}

 */
-(NSArray *)fbPermissions{
    return @[@"user_photos",
    @"user_photo_video_tags",@"friends_photos"];
}

@end
