//
//  RMNavigationController.m
//  GraphicTweets
//
//  Created by Dario Lencina on 2/23/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "RMNavigationController.h"

@interface RMNavigationController ()

@end

@implementation RMNavigationController

-(id)initWithRootViewController:(UIViewController *)rootViewController{
    return [super initWithRootViewController:rootViewController];
}

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    UIInterfaceOrientation orientation=([[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation]);
    return orientation;
}

@end
