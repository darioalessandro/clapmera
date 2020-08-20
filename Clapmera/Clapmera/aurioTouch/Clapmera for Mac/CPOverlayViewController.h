//
//  CPOverlayViewController.h
//  Clapmera
//
//  Created by Dario Lencina on 5/8/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPSoundManager.h"
#import "CPConfiguration.h"
#import <Quartz/Quartz.h>
#import <AVFoundation/AVFoundation.h>
#import "ConfigurationView.h"
#import "CPConfiguration.h"
#import "ClapRecognizer.h"
#import "ClapmeraEngine.h"

static NSString * const CPOverlayViewControllerShowAccessToCameraError= @"CPOverlayViewControllerShowAccessToCameraError";
static NSString * const CPOverlayViewControllerHideAccessToCameraError= @"CPOverlayViewControllerHideAccessToCameraError";

@interface CPOverlayViewController : NSViewController <ClapRecognizerDelegate>

- (IBAction)onSensorStateClick:(NSButton *)sender;

- (IBAction)onTimerChanged:(NSSlider *)sender;
- (IBAction)showSettings:(NSButton *)sender;
- (IBAction)onSensitivityChanged:(NSSlider *)sender;
@property (strong) IBOutlet NSPopover *popOver;
@property (strong)  NSMutableArray * images;

@property (strong)              ClapmeraEngine * clapmeraEngine;
@property (strong) IBOutlet     NSSlider *sensitivitySlider;
@property (strong) IBOutlet     NSButton *sensorStateButton;
@property(nonatomic, retain)    AVCaptureStillImageOutput *stillImageOutput;
@property(nonatomic, assign)    IBOutlet NSView * cameraView;
@property (strong) IBOutlet NSSlider *timerSlider;
@property (strong) IBOutlet NSTextField *timerLabel;
@property (strong) IBOutlet ConfigurationView *configurationView;
@property (strong) IBOutlet NSCollectionView *gallery;
@property (strong) IBOutlet NSScrollView *galleryScrollView;
@property (strong) IBOutlet NSMenu *contextualMenu;


@end


