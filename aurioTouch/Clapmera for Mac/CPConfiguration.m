//
//  CPConfiguration.m
//  Clapmera
//
//  Created by Dario Lencina on 8/31/12.
//
//

#import "CPConfiguration.h"
#define kCP_delay @"kCP_delay_4.2"
#define kCP_numberOfAvailablePics @"kCP_numberOfAvailablePics"
#define UD_FLash_Default @"UD_FLash_Default"
#define UD_Camera_DefaultCamera @"UD_Camera_DefaultCamera_AV"
#define UD_Camera_DefaultOperationMode @"UD_Camera_CPConfigurationOperationMode"
#define UD_Did_ShowNewFeatures @"UD_Did_ShowNewFeatures"
#define kDefaultDelay 5
#define kDefaultOfAvailablePictures 30
#import "GAI.h"


@implementation CPConfiguration

+(BOOL)shouldShowNewFeaturesScreen{
    BOOL shouldShowNewFeaturesScreen=YES;
    if([[NSUserDefaults standardUserDefaults] objectForKey:UD_Did_ShowNewFeatures]){
        shouldShowNewFeaturesScreen= ![[NSUserDefaults standardUserDefaults] boolForKey:UD_Did_ShowNewFeatures];
    }
    return shouldShowNewFeaturesScreen;
}


+(void)didShowNewFeaturesScreen{
    [[NSUserDefaults standardUserDefaults] setBool:TRUE forKey:UD_Did_ShowNewFeatures];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CPConfigurationOperationMode) operationMode{
    NSInteger operationMode=CPConfigurationOperationModeSingle;
    if([[NSUserDefaults standardUserDefaults] objectForKey:UD_Camera_DefaultOperationMode]){
        operationMode= [[NSUserDefaults standardUserDefaults] integerForKey:UD_Camera_DefaultOperationMode];
    }
    return operationMode;
}

+(void)setOperationMode:(CPConfigurationOperationMode) operationMode{
    [[[GAI sharedInstance] defaultTracker] set:@"CPConfigurationOperationMode"  value:[NSString stringWithFormat:@"operationMode: %d", operationMode]];
    [[NSUserDefaults standardUserDefaults] setInteger:operationMode forKey:UD_Camera_DefaultOperationMode];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(CGFloat)delay{
    NSInteger delay=kDefaultDelay;
    if([[NSUserDefaults standardUserDefaults] objectForKey:kCP_delay]){
        delay= [[NSUserDefaults standardUserDefaults] floatForKey:kCP_delay];
    }
    return delay;
}

+(void)setDelay:(CGFloat)delay{
    [[[GAI sharedInstance] defaultTracker] set:@"CPConfigurationOperationMode"  value:[NSString stringWithFormat:@"setDelay: %@", @(delay)]];
    [[NSUserDefaults standardUserDefaults] setFloat:delay forKey:kCP_delay];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+(BOOL)isFirstRun{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * firstRunFlag= [NSString stringWithFormat:@"%@_firstRun", version];
    if([userDefaults objectForKey:firstRunFlag]){
        return [userDefaults boolForKey:firstRunFlag];
    }
    return TRUE;
}

+(void)setFirstRunFlag:(BOOL)flag{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSString * version= [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
    NSString * firstRunFlag= [NSString stringWithFormat:@"%@_firstRun", version];
    [userDefaults setBool:flag forKey:firstRunFlag];
    [userDefaults synchronize];
}

+(void)toggleDefaultCamera{
    if([self defaultCamera]==AVCaptureDevicePositionBack){
        [self setDefaultCamera:AVCaptureDevicePositionFront];
    }else{
        [self setDefaultCamera:AVCaptureDevicePositionBack];
    }
}

+(AVCaptureDevicePosition)defaultCamera{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:UD_Camera_DefaultCamera]){
        return (AVCaptureDevicePosition) [userDefaults integerForKey:UD_Camera_DefaultCamera];
    }
    return AVCaptureDevicePositionFront;
}

+(void)setDefaultCamera:(AVCaptureDevicePosition)camera{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(NSInteger)camera forKey:UD_Camera_DefaultCamera];
    [userDefaults synchronize];
}

+(AVCaptureFlashMode)defaultFlashMode{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    
    if([userDefaults objectForKey:UD_FLash_Default]){
        return (AVCaptureFlashMode) [userDefaults integerForKey:UD_FLash_Default];
    }
    return AVCaptureFlashModeOff;
}

+(void)setDefaultFlashMode:(AVCaptureFlashMode)flashMode{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:(NSInteger)flashMode forKey:UD_FLash_Default];
    [userDefaults synchronize];
}


@end
