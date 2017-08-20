//
//  CMAppDelegate.m
//  Clapmera
//
//  Created by Dario on 11/04/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "CMAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
#import "CMConfigurationsViewController.h"
#import "TutoViewController.h"
#import "InAppPurchasesManager.h"
#import "ClapmeraViewController.h"
#import "GAI.h"
#import "CPNotifications.h"
#define kFBURLSchema @"fb302317129848474"
#import <FacebookSDK/FacebookSDK.h>
#import "CPTheme.h"

//Analytics config.
#define GoogleAnalyticsAccount @"UA-30917267-1"
#define kGANDispatchPeriodSec 30

//AppRater settings.
#define kMaxLaunchCounter 5

@implementation CMAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

#pragma mark 
#pragma UIApplicationDelegate

-(BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions{
    [self.window setBounds:[[UIScreen mainScreen] bounds]];
    [self initFacebook];
    [self showClapmeraMainController];
    [self startGoogleAnalyticsTracker];
    [self startInAppPurchasesEngine];
    [self startRateManager];
//    [self setCustomNavBarTheme];
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation{
    BOOL openURL=NO;
    if([[url scheme] isEqualToString:kFBURLSchema]){
        openURL= [[FBSession activeSession] handleOpenURL:url];
    }
    return openURL;
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    BFLog(@"applicationDidEnterBackground");
    [((ClapmeraViewController *)self.viewController) applicationDidEnterBackground:application];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidBecomeActive object:nil];
    [((ClapmeraViewController *)self.viewController) applicationDidBecomeActive:application];
    [FBSession.activeSession handleDidBecomeActive];
}

- (void)applicationWillTerminate:(UIApplication *)application{
    [[FBSession activeSession] close];
}

#pragma mark -
#pragma mark Key initializers

-(void)startRateManager{
    [[AppRater sharedInstance] setProvider:self];
    [[AppRater sharedInstance] startMonitoringIfNeededOtherwiseCommitSuicide];
}

-(void)startInAppPurchasesEngine{
    [[InAppPurchasesManager sharedManager] reloadProductsWithHandler:NULL];
}

- (void)showClapmeraMainController{
    ClapmeraViewController * clapmeraViewController=[ClapmeraViewController new];
    self.viewController=clapmeraViewController;
    UINavigationController * controller= [[UINavigationController alloc] initWithRootViewController:self.viewController];
    [controller setNavigationBarHidden:TRUE];
    self.window.rootViewController = controller;
    [self.window makeKeyAndVisible];
}

#pragma mark -
#pragma mark Tracker code

-(void)startGoogleAnalyticsTracker{
    BFLog(@"GoogleAnalyticsAccount %@", GoogleAnalyticsAccount);
    [[GAI sharedInstance] setDispatchInterval:kGANDispatchPeriodSec];
    [[GAI sharedInstance] setDebug:NO];
    [[GAI sharedInstance] trackerWithTrackingId:GoogleAnalyticsAccount];
}

- (void)hitDispatched:(NSString *)hitString{
    BFLog(@"hitDispatched %@", hitString);
}

- (void)trackerDispatchDidComplete:(GAI *)tracker
                  eventsDispatched:(NSUInteger)eventsDispatched
              eventsFailedDispatch:(NSUInteger)eventsFailedDispatch {
    BFLog(@"events dispatched: %d, events failed: %d", eventsDispatched, eventsFailedDispatch);
}

#pragma mark -
#pragma Facebook

-(void)initFacebook{
    if ([FBSession activeSession].state == FBSessionStateCreatedTokenLoaded) {        
        [[FBSession activeSession] openWithCompletionHandler:^(FBSession *session,
                                                               FBSessionState status,
                                                               NSError *error) {
            
        }];
    }
}

-(void)setCustomNavBarTheme{
    UIImage * navBar= [CPTheme imageForNavigationBar];
    [[UINavigationBar appearance] setBackgroundImage:navBar forBarMetrics:UIBarMetricsDefault];
    navBar= [CPTheme imageForNavigationBar];
    [[UIToolbar appearance] setBackgroundImage:navBar forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    
    UIImage * img= [UIImage imageNamed:@"navigationBarButton"];
    [[UISegmentedControl appearance] setBackgroundImage:img forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UISegmentedControl appearance] setBackgroundImage:[UIImage imageNamed:@"navigationBarButtonPressed"] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    UIImage * button=[[UIImage imageNamed:@"navigationBarButton"] resizableImageWithCapInsets:UIEdgeInsetsMake(5, 5, 5, 5)];
    UIImage * button_pressed=[UIImage imageNamed:@"navigationBarButtonPressed"];
    [[UIBarButtonItem appearance] setBackgroundImage:button forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackgroundImage:button_pressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    UIImage * _backButton=[[UIImage imageNamed:@"navigationBarBack"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 14, 12, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:_backButton forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage * _backButtonPressed=[[UIImage imageNamed:@"navigationBarBackPressed"] resizableImageWithCapInsets:UIEdgeInsetsMake(0, 16, 4, 4)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:_backButtonPressed forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:[CPTheme navBarTitleTextAttributes]];
    [[UIBarButtonItem appearance] setTitleTextAttributes:[CPTheme tabBarItemTitleTextAttributes] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark AppTracker Provider

-(NSString *)appId{
    NSString * appId= @"519363613";
    return appId;
};

-(NSString *)contactEmail{
    return @"mailto://clapmera@gmail.com";
}

-(NSInteger)maxAppRaterCounter{
    return kMaxLaunchCounter;
}

@end
