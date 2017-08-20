//
//  DetailViewController.m
//  AutoLayoutLessons
//
//  Created by Dario Lencina on 11/29/12.
//  Copyright (c) 2012 Dario Lencina. All rights reserved.
//

#import "ClapmeraViewController.h"
#import "ClapmeraViewController+iAds.h"
#import "CMConfigurationsViewController.h"
#import "UIViewController + Analytics.h"
#import "CMMenuViewController.h"
#import "TutoViewController.h"
#import "InAppPurchasesManager.h"
#import "DejalActivityView.h"
#import "CPTheme.h"
#import "UpgradesViewController.h"
#import "FadeAndScaleSiegue.h"
#import "ClapmeraEngine.h"
#import "BFGAssetsManager.h"
#import "UIView+LoadingState.h"

@interface ClapmeraViewController ()
-(void)showSettingsAsModalView:(id)sender;
-(void)updateMenuButtonWithState:(ClapmeraEngineState)state;
-(void)turnOnFlashForTimeInterval:(NSTimeInterval)interval;
@property(nonatomic, strong)ClapmeraEngine * clapmeraEngine;
@end

@implementation ClapmeraViewController{
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    
}

#pragma mark -
#pragma setup

-(void)addNotificationObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(userDeniedAccess:) name:kUserDeniedAccessToPics object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shouldRunProVersion:) name:kShouldRunProVersion object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updatePicCounter:) name:CPConfigurationNumberOfAvailablePicturesChanged object:nil];
}

-(void)userDeniedAccess:(NSNotification *)notification{
    UIView *noAccessToCamView;
    NSString * nibName=@"BFDeniedAccessToAssetsView";
    if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
        nibName= [NSString stringWithFormat:@"%@ipad", nibName];
    }
    noAccessToCamView= [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
    [noAccessToCamView setFrame:self.view.window.bounds];
    [self.view.window addSubview:noAccessToCamView];
}

-(void)configureUI{
    [self.menuView setBackgroundColor:[CPTheme colorforBgMenu]];
    [self updatePicCounter:nil];
}

-(void)updatePicCounter:(id)sender{
    [[NSOperationQueue mainQueue] addOperationWithBlock:^{
        self.numberOfAvailablePictures.text=@"∞";
    }];
}

-(void)clapmeraEngine:(ClapmeraEngine *)clapmeraEngine timerDidTic:(RCTimer *)timer{
    if(timer){
        self.sensorOnOffLabel.text = [NSString stringWithFormat:@"%d",timer.timeRemaining];
    }
    [self turnOnFlashForTimeInterval:1];
}

-(void)clapmeraEngine:(ClapmeraEngine *)clapmeraEngine didThrowError:(NSError *)error{
    if (error.code==ClapmeraEngineErrorUserRanOutOfPictures) {
        [self showUpgrades:nil];
        [[[GAI sharedInstance] defaultTracker] sendView:@"ClapmeraViewController/UserRanOutOfPics"];
    }else if(error.code==ClapmeraEngineErrorAppHasNoAccessToPhotos){
        
        BFLog(@"Error saving photo: %@", error);
        [[[GAI sharedInstance] defaultTracker] sendView:@"ClapmeraViewController/DidFailToSnapPhoto"];
    }else if(error.code==ClapmeraEngineErrorhighVolume){
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Environment is too noisy", nil)];
        [self removeActivityView];
    }
}

-(void)stateChanged:(ClapmeraEngine *)engine{
    [self updateMenuButtonWithState:[engine state]];
    if([engine state]==ClapmeraEngineStateCanceledCapture){
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Action canceled...", nil)];
        [self removeActivityView];
        [[[GAI sharedInstance] defaultTracker] sendView:@"ClapmeraViewController/cancelPic/FromClap"];
    }
    if(engine.state==ClapmeraEngineStateCounting){
        [DejalBezelActivityView activityViewForView:self.view withLabel:NSLocalizedString(@"Clap Detected...", nil)];
        [self removeActivityView];
    }
}

-(void)removeActivityView{
    double delayInSeconds = 1.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if([DejalActivityView currentActivityView]!=nil){
            [[DejalActivityView currentActivityView] animateRemove];
        }
    });
}

-(void)setupViewController{
    self.clapmeraEngine=[ClapmeraEngine new];
    self.clapmeraEngine.clapmeraViewController=self;
    if(![[InAppPurchasesManager sharedManager] didUserBuyProVersion]){
        [self setupiAdNetwork];
    }else{
        [self shouldHideBanner:nil];
    }
    [self setupSession];
    [self configureUI];
    [self addNotificationObservers];
    [self showInstructionsIfFirstRun];
    [self showCamera];
    [self configureFlash];
    [[self clapmeraEngine] startListening];
    
}

-(void)verifyCameraAccess{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError * error;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!deviceInput){
        [self showNoAccessToCameraError];
    }
}

-(void)verifyMicrophoneAccess{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        if (!granted) {
            [self showNoAccessToMicrophoneError];
        }
    }];
}

-(void)showNoAccessToCameraError{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIView *noAccessToCamView;
        NSString * nibName=@"BFDeniedAccessToCameraView";
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
            nibName= [NSString stringWithFormat:@"%@ipad", nibName];
        }
        noAccessToCamView= [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
        [noAccessToCamView setFrame:self.view.window.bounds];
        [self.view.window addSubview:noAccessToCamView];
    });
}

-(void)showNoAccessToMicrophoneError{
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        UIView *noAccessToCamView;
        NSString * nibName=@"BFDeniedAccessToMicrophoneView";
        if([[UIDevice currentDevice] userInterfaceIdiom]==UIUserInterfaceIdiomPad){
            nibName= [NSString stringWithFormat:@"%@ipad", nibName];
        }
        noAccessToCamView= [[NSBundle mainBundle] loadNibNamed:nibName owner:nil options:nil][0];
        [noAccessToCamView setFrame:self.view.window.bounds];
        [self.view.window addSubview:noAccessToCamView];
    });
}

#pragma mark -
#pragma mark ViewEvents

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setupViewController];
    [[BFGAssetsManager sharedInstance] readUserImagesFromLibrary]; //Verify access to pics.
    [self verifyMicrophoneAccess];
    [self verifyCameraAccess];
}

- (void)viewDidUnload {
    [super viewDidUnload];
    [self setMenuView:nil];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self GATrackPage];
    [self performSelector:@selector(layoutBanners) withObject:nil afterDelay:0.3];
}

-(void)resumeClapmeraEngine{
    [self.clapmeraEngine resume];
}

-(void)applicationDidEnterBackground:(UIApplication *)application{
    [self.clapmeraEngine pause];
}

-(void)applicationDidBecomeActive:(UIApplication *)application{
    [self.clapmeraEngine resume];
}

#pragma mark -
#pragma mark Rotation Management

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation{
    [self layoutBanners];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    [self rotateCameraToOrientation:toInterfaceOrientation];
}

-(void)showSettingsAsModalView:(id)sender{
    CMConfigurationsViewController * configurations = [[CMConfigurationsViewController alloc] init];
    configurations.clapmeraViewController=self;
    UINavigationController * navController=[[UINavigationController alloc] initWithRootViewController:configurations];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [configurations setModalPresentationStyle:UIModalPresentationPageSheet];
    [self presentViewController:navController animated:TRUE completion:NULL];
}

#pragma mark -
#pragma mark Banners

-(void)layoutBanners{
    if(!_iAdsBanner){
        [self rotateCameraToCurrentStatusBarOrientation];
        return;
    }
    
    if (_iAdsBanner.bannerLoaded) {
        [self shouldShowBanner:nil];
        [self shouldShowBanner:nil];
    }else{
        [self shouldHideBanner:nil];
        [self shouldHideBanner:nil];
    }
    [self rotateCameraToCurrentStatusBarOrientation];
}

#pragma mark -
#pragma mark Camera

-(void)configureFlash{
    AVCaptureDevice *device = [self cameraForPosition:[CPConfiguration defaultCamera]];
    [self setFlashMode:[CPConfiguration defaultFlashMode]];
    [[self flash] setHidden:![device hasFlash]];
}

-(void)rotateCameraToOrientation:(UIInterfaceOrientation)orientation{
    [_captureVideoPreviewLayer.connection setVideoOrientation:orientation];
    _captureVideoPreviewLayer.frame = self.cameraView.bounds;
    for(AVCaptureConnection * connection in [self.clapmeraEngine.imageOutput connections]){
        [connection setVideoOrientation:orientation];
    }
    [self.clapmeraEngine.videoProcessor updateVideoOrientation:orientation];
}

-(void)setupSession{
    self.clapmeraEngine.session = [[AVCaptureSession alloc] init];
    _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.clapmeraEngine.session];
    [self.cameraView.layer addSublayer:_captureVideoPreviewLayer];
    [_captureVideoPreviewLayer setHidden:NO];
    [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.clapmeraEngine.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.clapmeraEngine.imageOutput setOutputSettings:outputSettings];
    [self.clapmeraEngine.session addOutput:self.clapmeraEngine.imageOutput];
}

-(void)showCamera{
    [self.cameraView setState:UIViewLoadingStateInProgressBlocking withHandler:^(UIView *view) {
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if(_captureVideoPreviewLayer){
                _captureVideoPreviewLayer.hidden=TRUE;
                self.changeCameraButton.hidden=TRUE;
            }
        }];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if([self.clapmeraEngine.session inputs]){
                for (id input in [self.clapmeraEngine.session inputs]){
                    [self.clapmeraEngine.session removeInput:input];
                }
            }
            
            if([self.clapmeraEngine.session outputs]){
                for (id output in [self.clapmeraEngine.session outputs]){
                    if([output isEqual:self.clapmeraEngine.imageOutput]==FALSE){
                        [self.clapmeraEngine.session removeOutput:output];
                    }
                }
            }
            
            [self.clapmeraEngine.videoProcessor setupAndStartCaptureSessionWithSession:self.clapmeraEngine.session];
            
            if([self.clapmeraEngine.session isRunning]==FALSE){
                [self.clapmeraEngine.session startRunning];
            }
        }];
        
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            _captureVideoPreviewLayer.hidden=NO;
            self.changeCameraButton.hidden=NO;
            [self.cameraView setState:UIViewLoadingStateDone withHandler:^(UIView *view) {
                [self.clapmeraEngine.videoProcessor updateVideoOrientation:self.interfaceOrientation];
            }];
        }];
    }];
}

-(void)rotateCameraToCurrentStatusBarOrientation{
    [self rotateCameraToOrientation:self.interfaceOrientation];
}

-(AVCaptureDevice *)cameraForPosition:(AVCaptureDevicePosition)position{
    NSArray *videoDevices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    AVCaptureDevice *captureDevice = nil;
    for (AVCaptureDevice *device in videoDevices){
        if (device.position == position){
            captureDevice = device;
            break;
        }
    }
    
    if ( ! captureDevice){
        captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    }
    
    return captureDevice;
}

#pragma mark  -
#pragma mark Flash N Torch

-(void)setTorchLightMode:(AVCaptureTorchMode)mode{
    if([CPConfiguration defaultCamera]==AVCaptureDevicePositionFront)
        return;
    
    AVCaptureDevice * device=[self cameraForPosition:AVCaptureDevicePositionBack];
    if(device){
        if([device hasTorch]){
            [device lockForConfiguration:nil];
            if(mode==AVCaptureTorchModeOn){
                [device setTorchModeOnWithLevel:0.2 error:nil];
            }else{
                [device setTorchMode:AVCaptureTorchModeOff];
            }
            [device unlockForConfiguration];
        }
    }
}

-(void)setFlashMode:(AVCaptureFlashMode)mode{
    [CPConfiguration setDefaultFlashMode:mode];
    if([CPConfiguration defaultCamera]==AVCaptureDevicePositionFront)
        return;
    
    AVCaptureDevice * device=[self cameraForPosition:AVCaptureDevicePositionBack];
    if(device){
        if([device hasFlash]){
            [device lockForConfiguration:nil];
            [device setFlashMode:mode];
            [device unlockForConfiguration];
        }
    }
    [self updateFlashUIWithMode:mode];
}

-(void)updateFlashUIWithMode:(AVCaptureFlashMode)mode{
    UIImage * image=nil;
    switch (mode) {
        case AVCaptureFlashModeAuto:
            image=[CPTheme imageForAVCaptureFlashModeAuto];
            break;
            
        case AVCaptureFlashModeOn:
            image=[CPTheme imageForAVCaptureFlashModeOn];
            break;
            
        case AVCaptureFlashModeOff:
        default:
            image=[CPTheme imageForAVCaptureFlashModeOff];
            break;
            
    }
    [[self flash] setImage:image forState:UIControlStateNormal];
}

-(void)toggleFlashPreferences{
    AVCaptureFlashMode flashMode= [CPConfiguration defaultFlashMode];
    switch (flashMode) {
        case AVCaptureFlashModeAuto:
            [self setFlashMode:AVCaptureFlashModeOn];
            break;
            
        case AVCaptureFlashModeOn:
        default:
            [self setFlashMode:AVCaptureFlashModeOff];
            break;
            
        case AVCaptureFlashModeOff:
            [self setFlashMode:AVCaptureFlashModeAuto];
            break;
    }
}

-(void)turnOnFlashForTimeInterval:(NSTimeInterval)interval{
    [self setTorchLightMode:AVCaptureTorchModeOn];
    [self performSelector:@selector(turnFlashOff) withObject:nil afterDelay:interval/2];
}

-(void)turnFlashOff{
    [self setTorchLightMode:AVCaptureTorchModeOff];
}

#pragma mark -
#pragma mark UI Update

-(void)updateMenuButtonWithState:(ClapmeraEngineState)state{
    [self.changeCameraButton setHidden:NO];
    if (state == ClapmeraEngineStateOff){
        self.sensorOnOffLabel.text = NSLocalizedString(@"Off", nil);
        [self.onOffSensorButton setImage:[CPTheme imageForMenuButtonSensorOff] forState:UIControlStateNormal];
    } else if (state == ClapmeraEngineStateListening){
        self.sensorOnOffLabel.text = NSLocalizedString(@"Listening", nil);
        [self.onOffSensorButton setImage:[CPTheme imageForMenuButtonSensorOn] forState:UIControlStateNormal];
    } else if (state == ClapmeraEngineStateCounting){
        [self.changeCameraButton setHidden:TRUE];
        [self.onOffSensorButton setImage:[CPTheme imageForMenuButtonSensorProcessing] forState:UIControlStateNormal];
    } else if (state== ClapmeraEngineStateCapturing){
        [self.changeCameraButton setHidden:TRUE];
        if([CPConfiguration operationMode]==CPConfigurationOpeationModeVideo){
            self.sensorOnOffLabel.text = NSLocalizedString(@"Recording", nil);
        }else{
            self.sensorOnOffLabel.text = NSLocalizedString(@"Smile!", nil);
        }
    }
}

#pragma mark -
#pragma mark UI Actions

-(IBAction)showSettings:(id)sender{
    [self.clapmeraEngine pause];
    [self GATrackPageWithURL:@"/CMOverlayViewController/showSettings"];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        CMConfigurationsViewController * controller = [[CMConfigurationsViewController alloc] init];
        controller.clapmeraViewController=self;
        [self pushController:controller];
    }else{
        [self showSettingsAsModalView:sender];
    }
}

-(void)pushController:(UIViewController *)controller{
    UINavigationController * navController=[[UINavigationController alloc] initWithRootViewController:controller];
    FadeAndScaleSiegue * siegue=[[FadeAndScaleSiegue alloc] initWithIdentifier:@"Fade" source:self destination:navController];
    [siegue perform];
}

-(IBAction)showLastPhoto:(id)sender{
    [self.clapmeraEngine pause];
    CMMenuViewController * controller= [[CMMenuViewController alloc] initWithNibName:@"BFGalleryViewController" bundle:nil];
    controller.clapmeraViewController=self;
    [self pushController:controller];
    [self GATrackPageWithURL:@"/CMOverlayViewController/showLastPhoto"];
}

-(IBAction)changeCamera:(id)sender{
    [CPConfiguration toggleDefaultCamera];
    [self showCamera];
    [self configureFlash];
}

-(IBAction)flash:(UIButton *)sender {
    [self toggleFlashPreferences];
}

-(IBAction)onOffSensor:(id)sender{
    static BOOL histeresis=NO;
    if(histeresis==NO){
        histeresis=YES;
        [self.clapmeraEngine toggleState];
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            histeresis=NO;
        });
    }
}

-(IBAction)showUpgrades:(id)sender {
    UpgradesViewController * upgrades=[UpgradesViewController new];
    upgrades.clapmeraViewController=self;
    [self.clapmeraEngine pause];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        [self pushController:upgrades];
    }else{
        UINavigationController * navController=[[UINavigationController alloc] initWithRootViewController:upgrades];
        [navController setModalPresentationStyle:UIModalPresentationFormSheet];
        [upgrades setModalPresentationStyle:UIModalPresentationPageSheet];
        [self presentViewController:navController animated:TRUE completion:^{
            
        }];
    }
    
}

-(IBAction)showHelp:(UIButton *)sender {
    [self showInstructions];
}

#pragma mark -
#pragma mark Notifications

-(void)shouldRunProVersion:(NSNotification *)notification{
    [self updatePicCounter:nil];
    [self turnOffiAds];
}

#pragma mark -
#pragma mark Instructions

-(void)showInstructionsIfFirstRun{
    if([CPConfiguration isFirstRun]){
        [self performSelector:@selector(showInstructions) withObject:nil afterDelay:2];
        [CPConfiguration setFirstRunFlag:NO];
    }
}

-(void)showInstructions{
    TutoViewController * tuto= [TutoViewController new];
    tuto.clapmeraViewController=self;
    [self presentViewController:tuto animated:NO completion:NULL];
    double delayInSeconds = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [self.clapmeraEngine pause];
    });
}

-(BOOL)prefersStatusBarHidden{
    return YES;
}

@end
