//
//  UIColor+Hex.m
//  BlackFireApps
//
//  Created by Dario Lencina on 4/27/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "UIColor+Hex.h"



@implementation UIColor (Hex)

+(UIColor *)UIColorFromRGB:(NSInteger)rgbValue{
    return  [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0];
}

@end
