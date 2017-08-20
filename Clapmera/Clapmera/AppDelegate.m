//
//  AppDelegate.m
//  Clapmera
//
//  Created by Dario Lencina on 8/20/17.
//  Copyright © 2017 BlackFireApps. All rights reserved.
//

#import "AppDelegate.h"
#define kFBURLSchema @"fb302317129848474"
#import "CPTheme.h"

//Analytics config.
#define GoogleAnalyticsAccount @"UA-30917267-1"
#define kGANDispatchPeriodSec 30

//AppRater settings.
#define kMaxLaunchCounter 5

#import "ClapmeraViewController.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import "BFLog.h"
#import "CPNotifications.h"
#import "GAI.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [self initFacebook:application withOptions:launchOptions];
    [self showClapmeraMainController];
    [self startGoogleAnalyticsTracker];
    [self startInAppPurchasesEngine];
    [self startRateManager];
    return YES;
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBSDKAppEvents activateApp];
    [[NSNotificationCenter defaultCenter] postNotificationName:AppDidBecomeActive object:nil];
    [((ClapmeraViewController *)self.viewController) applicationDidBecomeActive:application];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                sourceApplication:sourceApplication
                                                       annotation:annotation];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    BFLog(@"applicationDidEnterBackground");
    [((ClapmeraViewController *)self.viewController) applicationDidEnterBackground:application];
}


- (void)applicationWillTerminate:(UIApplication *)application{
 
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

-(void)initFacebook:(UIApplication *)application withOptions:(NSDictionary *)launchOptions {
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
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
