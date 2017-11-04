//
//  UIImageView+UIImageExtensions.m
//  LeRandomizer
//
//  Created by Dario Lencina on 1/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "UIImageView+UIImageExtensions.h"

@implementation UIImageView (UIImageExtensions)

-(CGRect)frameForImage:(UIImage*)image{
    float imageRatio = image.size.width / image.size.height;
    float viewRatio = self.frame.size.width / self.frame.size.height;
    
    if(imageRatio < viewRatio){
        float scale = self.frame.size.height / image.size.height;
        float width = scale * image.size.width;
        float topLeftX = (self.frame.size.width - width) * 0.5;
        return CGRectMake(topLeftX, 0, width, self.frame.size.height);
    }else{
        float scale = self.frame.size.width / image.size.width;
        float height = scale * image.size.height;
        float topLeftY = (self.frame.size.height - height) * 0.5;
        return CGRectMake(0, topLeftY, self.frame.size.width, height);
    }
}


@end
