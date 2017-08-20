//
//  BFFacebook.h
//  Graphic tweets
//
//  Created by Dario Lencina on 10/15/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import <FacebookSDK/FacebookSDK.h>

@interface BFFacebook : NSObject
//-(BOOL)isSharingEnabled;
+(BFFacebook *)sharedInstance;
//-(void)shouldTurnConnectOrDisconnectSession:(BOOL)on handler:(FBSessionStateHandler)handler;
@end