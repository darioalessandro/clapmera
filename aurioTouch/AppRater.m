//
//  AppRater.m
//  publictransportationroutes
//
//  Created by Dario Lencina on 8/29/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import "AppRater.h"
static AppRater * _rater=nil;

NSString *templateReviewURL = @"https://userpub.itunes.apple.com/WebObjects/MZUserPublishing.woa/wa/addUserReview?id=%@&type=Purple+Software";
#define kVersionKey @"CFBundleVersion"
#define kAppRaterUserDefaultsPath @"AppRater_DidAskedFlag_%@"
#define kAppRaterLaunchCounterUserDefaultsPath @"AppRater_LaunchCounter_%@"


@interface AppRater (PrivateStuff)

-(void)startMonitoringAppActivity;

@end

@implementation AppRater

@synthesize provider;

+(AppRater *)sharedInstance{
    if(_rater==nil){
        _rater= [AppRater new];
    }
    return _rater;
}

-(void)startMonitoringIfNeededOtherwiseCommitSuicide{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    NSNumber * number= [defaults objectForKey:[self nsUserDefaultsPathForDidShowAlertFlag]];
    if(number==nil){
        [self startMonitoringAppActivity];
    }else{
        _rater=nil;
    }
}

-(void)startMonitoringAppActivity{
    if(self.provider){
        [self increaseLaunchCounterAndPromptUserIfNeeded];
    }else{
        [NSException exceptionWithName:@"AppRater is crying" reason:@"AppRater has no delegate" userInfo:nil];
    }
}

-(NSInteger)launchCounter{
    NSInteger launchCounter= [[NSUserDefaults standardUserDefaults] integerForKey:[self nsUserDefaultsPathForLaunchCounter]];
    return launchCounter;
}

-(void)setLaunchCounter:(NSInteger)counter{
    NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
    [defaults setInteger:counter forKey:[self nsUserDefaultsPathForLaunchCounter]];
    [defaults synchronize];
}

-(void)increaseLaunchCounterAndPromptUserIfNeeded{
    NSInteger launchCounter= [self launchCounter];
    launchCounter++;
    if(launchCounter>=[self.provider maxAppRaterCounter]){
        [self monitorCallBack];
    }
    [self setLaunchCounter:launchCounter];
}

-(void)monitorCallBack{
    UIAlertView * alertView= [[UIAlertView alloc] initWithTitle:[self appName] message:NSLocalizedString(@"¡Gracias por usar nuestra App!", nil) delegate:self cancelButtonTitle: NSLocalizedString(@"No Gracias",nil) otherButtonTitles:  NSLocalizedString(@"Calificar en la AppStore", nil), nil];
    [alertView show];
}

#pragma mark - UIAlertViewDelegate



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if(buttonIndex==1){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:templateReviewURL, [self.provider appId]]]];
    }else if(buttonIndex==0){
        NSUserDefaults * defaults= [NSUserDefaults standardUserDefaults];
        NSNumber * number= [NSNumber numberWithBool:TRUE];
        [defaults setObject:number forKey: [self nsUserDefaultsPathForDidShowAlertFlag]];
        [defaults synchronize];
    }
    [self setLaunchCounter:0];
}

-(NSString *)nsUserDefaultsPathForDidShowAlertFlag{
    return [NSString stringWithFormat:kAppRaterUserDefaultsPath, [self version]];
}

-(NSString *)nsUserDefaultsPathForLaunchCounter{
    return [NSString stringWithFormat:kAppRaterLaunchCounterUserDefaultsPath, [self version]];
}
  
-(NSString *)version{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:kVersionKey];
}

-(NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}
       

@end
