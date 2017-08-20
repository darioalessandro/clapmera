//
//  CPTheme.m
//  Clapmera
//
//  Created by Dario Lencina on 6/22/13.
//
//

#import "CPTheme.h"

@implementation CPTheme

+(UIColor *)colorforBgMenu{
    return [UIColor colorWithPatternImage:[UIImage imageNamed:@"menu_fondo"]];
}

+(UIImage *)imageForNavigationBar{
    return[UIImage imageNamed:@"navBar_fondo"];
}

+(UIImage *)imageForMenuButtonSensorOff{
    return [UIImage imageNamed:@"menu_button_sensor_off.png"];
}

+(UIImage *)imageForMenuButtonSensorOn{
    return [UIImage imageNamed:@"menu_button_sensor_on.png"];
}

+(UIImage *)imageForMenuButtonSensorProcessing{
    return [UIImage imageNamed:@"menu_button_sensor_on2.png"];
}

+(UIImage *)imageForAVCaptureFlashModeAuto{
    return [UIImage imageNamed:@"menu_button_flash_auto.png"];
}

+(UIImage *)imageForAVCaptureFlashModeOn{
    return [UIImage imageNamed:@"menu_button_flash.png"];
}

+(UIImage *)imageForAVCaptureFlashModeOff{
    return [UIImage imageNamed:@"menu_button_flash_off.png"];
}

+(NSDictionary *)navBarTitleTextAttributes{ 
    return @{   UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Bold" size:17.0f],
                UITextAttributeTextColor: [UIColor blackColor],
                UITextAttributeTextShadowColor: [UIColor whiteColor],
                UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 1.0f)]};
}

+(NSDictionary *)tabBarItemTitleTextAttributes{
    return @{   UITextAttributeFont: [UIFont fontWithName:@"Helvetica-Light" size:13.0f],
                UITextAttributeTextColor: [UIColor blackColor],
                UITextAttributeTextShadowColor: [UIColor grayColor],
                UITextAttributeTextShadowOffset:[NSValue valueWithUIOffset:UIOffsetMake(0.0f, 0.0f)]};
}

+(UILabel *)labelForTableViewSectionHeaderWithFrame:(CGRect)frame{
    UILabel * header= [[UILabel alloc] initWithFrame:frame];
    [header setBackgroundColor:[UIColor colorWithWhite:0.9 alpha:1]];
    [header setFont:[UIFont fontWithName:@"Helvetica-Light" size:13]];
    [header setMinimumScaleFactor:0.5];
    [header setAdjustsFontSizeToFitWidth:TRUE];
    return header;
}


@end
