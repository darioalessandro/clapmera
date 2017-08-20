//
//  CPConfiguration.h
//  Clapmera
//
//  Created by Dario Lencina on 8/31/12.
//
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

typedef enum CPConfigurationOperationMode {
    CPConfigurationOperationModeSingle = 0,
    CPConfigurationOperationModeBurst = 1,
    CPConfigurationOpeationModeVideo= 2
    } CPConfigurationOperationMode;

static NSString * const CPConfigurationSensitivityChanged=@"CPConfigurationSensitivityChanged";
static NSString * const CPConfigurationNumberOfAvailablePicturesChanged=@"CPConfigurationNumberOfAvailablePicturesChanged";

@interface CPConfiguration : NSObject

+(CPConfigurationOperationMode) operationMode;
+(void)setOperationMode:(CPConfigurationOperationMode) operationMode;

+(CGFloat)delay;
+(void)setDelay:(CGFloat)delay;

+(void)setFirstRunFlag:(BOOL)flag;
+(BOOL)isFirstRun;

+(AVCaptureDevicePosition)defaultCamera;
+(void)setDefaultCamera:(AVCaptureDevicePosition)camera;
+(void)toggleDefaultCamera;

+(AVCaptureFlashMode)defaultFlashMode;
+(void)setDefaultFlashMode:(AVCaptureFlashMode)flashMode;

+(BOOL)shouldShowNewFeaturesScreen;
+(void)didShowNewFeaturesScreen;

@end
