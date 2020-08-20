//
//  DetailViewController.h
//  AutoLayoutLessons
//
//  Created by Dario Lencina on 11/29/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <iAd/iAd.h>
#import "CPConfiguration.h"
#import "ClapmeraEngine.h"
#import "ILTranslucentView.h"

#define kShouldRunProVersion @"ShouldRunProVersion"

@interface ClapmeraViewController : UIViewController <ADBannerViewDelegate, ClapmeraEngineProtocol>{
    ADBannerView *_iAdsBanner;
}

@property (weak,   nonatomic)   IBOutlet UIView *cameraView;
@property (weak,   nonatomic)   IBOutlet UIView *bannerView;
@property (strong, nonatomic)   IBOutlet NSLayoutConstraint *verticalSpacingOfBanner;
@property (weak,   nonatomic)   IBOutlet NSLayoutConstraint *bannerHeight;
@property (weak,   nonatomic)   IBOutlet UIView *menuView;
@property (strong, nonatomic)   IBOutlet UIButton *configsButton;
@property (strong, nonatomic)   IBOutlet UIButton *takePhotoButton;
@property (strong, nonatomic)   IBOutlet UIButton *changeCameraButton;
@property (strong, nonatomic)   IBOutlet UIButton *onOffSensorButton;
@property (strong, nonatomic)   IBOutlet UIButton *showLastPhotoButton;
@property (strong, nonatomic)   IBOutlet UILabel *sensorOnOffLabel;
@property (weak,   nonatomic)   IBOutlet UIButton *flash;
@property (strong, nonatomic)   IBOutlet UILabel *numberOfAvailablePictures;

-(IBAction)flash:(UIButton *)sender;

-(IBAction)showHelp:(UIButton *)sender;

-(IBAction)showSettings:(id)sender;

-(IBAction)showLastPhoto:(id)sender;

-(IBAction)changeCamera:(id)sender;

-(IBAction)onOffSensor:(id)sender;

-(IBAction)showUpgrades:(id)sender;

-(void)applicationDidEnterBackground:(UIApplication *)application;

-(void)applicationDidBecomeActive:(UIApplication *)application;

-(void)layoutBanners;

-(void)resumeClapmeraEngine;


@end
