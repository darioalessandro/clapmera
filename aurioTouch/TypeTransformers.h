//
//  TypeTransformers.h
//  Clapmera
//
//  Created by Dario A Lencina Talarico on 11/3/17.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface TypeTransformers : NSObject
+(AVCaptureVideoOrientation)tansformToVideoOrientation:(UIInterfaceOrientation)orientation;
@end
