//
//  GMSession.h
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
//#import "SGVoltTicker.h"
@class GMSession, GMService;

typedef enum GMSessionAuthLevel{
    GMSessionAuthLevelNone,
    GMSessionAuthLevelSession,
    GMSessionAuthLevelPin
} GMSessionAuthLevel;

typedef void (^GMSessionCompletionHandler)(GMSession *session, NSError * error);

@interface GMSession : NSObject
    -(void)authenticateWithCompletionHandler:(GMSessionCompletionHandler)handler;
    +(GMSession *)activeSession;
    -(NSString *)APIKey;
    -(NSString *)APISecret;
    @property(nonatomic, assign) GMSessionAuthLevel authLevel;
    @property(readwrite, copy)   NSString *accessToken;
    @property(readwrite, copy)   NSDate *expirationDate;

@end
