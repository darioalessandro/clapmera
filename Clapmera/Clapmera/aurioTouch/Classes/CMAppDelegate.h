//
//  CMAppDelegate.h
//  Clapmera
//
//  Created by Dario on 11/04/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppRater.h"

@class ClapmeraViewController;

@interface CMAppDelegate : UIResponder <UIApplicationDelegate, AppRaterProvider>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ClapmeraViewController *viewController;

-(void)startGoogleAnalyticsTracker;
-(NSString *)appId;

@end