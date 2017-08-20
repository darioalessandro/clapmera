//
//  CPTheme.h
//  Clapmera
//
//  Created by Dario Lencina on 6/22/13.
//
//

#import <Foundation/Foundation.h>

@interface CPTheme : NSObject

+(UIColor *)colorforBgMenu;
+(UIImage *)imageForMenuButtonSensorOff;
+(UIImage *)imageForMenuButtonSensorOn;
+(UIImage *)imageForMenuButtonSensorProcessing;

+(UIImage *)imageForAVCaptureFlashModeAuto;
+(UIImage *)imageForAVCaptureFlashModeOn;
+(UIImage *)imageForAVCaptureFlashModeOff;

+(UIImage *)imageForNavigationBar;
+(NSDictionary *)navBarTitleTextAttributes;

+(NSDictionary *)navBarTitleTextAttributes;
+(NSDictionary *)tabBarItemTitleTextAttributes;
+(UILabel *)labelForTableViewSectionHeaderWithFrame:(CGRect)frame;

@end
