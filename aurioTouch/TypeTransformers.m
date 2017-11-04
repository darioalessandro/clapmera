//
//  TypeTransformers.m
//  Clapmera
//
//  Created by Dario A Lencina Talarico on 11/3/17.
//

#import "TypeTransformers.h"

@implementation TypeTransformers

+(AVCaptureVideoOrientation)tansformToVideoOrientation:(UIInterfaceOrientation)orientation {
    switch (orientation) {
        case UIInterfaceOrientationPortraitUpsideDown:
            return AVCaptureVideoOrientationPortraitUpsideDown;
        case UIInterfaceOrientationLandscapeLeft:
            return AVCaptureVideoOrientationLandscapeLeft;
        case UIInterfaceOrientationLandscapeRight:
            return AVCaptureVideoOrientationLandscapeRight;
        case UIInterfaceOrientationUnknown:
        case UIInterfaceOrientationPortrait:
        default:
            return AVCaptureVideoOrientationPortrait;
    }
}
@end
