//
//  FadeAndScaleSiegue.m
//  EcoHub
//
//  Created by Dario Lencina on 2/7/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "FadeAndScaleSiegue.h"

@implementation FadeAndScaleSiegue

- (void)perform{
    UIViewController *sourceViewController = (UIViewController *) self.sourceViewController;
    UIViewController *destinationViewController = (UIViewController *) self.destinationViewController;
    [sourceViewController presentViewController:destinationViewController animated:TRUE completion:^{
        

//    [destinationViewController dismissViewControllerAnimated:NO completion:^{
//    
//    }];
//    [sourceViewController.view addSubview:destinationViewController.view];
//    [destinationViewController.view setTransform:CGAffineTransformMakeScale(0.0,0.0)];
//    [destinationViewController.view setAlpha:0.0];
//    
//    [UIView animateWithDuration:0.5
//                          delay:0.0
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         [destinationViewController.view setTransform:CGAffineTransformMakeScale(1.0,1.0)];
//                         [destinationViewController.view setAlpha:1.0];
//                         UIViewController * controllerToShift;
//                         if(sourceViewController.tabBarController){
//                             controllerToShift=sourceViewController.tabBarController;
//                         }else if(sourceViewController.navigationController){
//                             controllerToShift=sourceViewController.navigationController;
//                         }else{
//                             controllerToShift=sourceViewController;
//                         }
//                     }
//                     completion:^(BOOL finished){
//                         [destinationViewController.view removeFromSuperview];
//                         [sourceViewController presentViewController:destinationViewController animated:NO completion:^{
//                    
//                         }];
//                     }];
        }];
    }

@end
