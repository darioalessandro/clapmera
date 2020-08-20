//
//  UIWindow+FullScreen.m
//  Clapmera
//
//  Created by Dario Lencina on 5/28/13.
//
//

#import "UIWindow+FullScreen.h"

@implementation NSWindow (FullScreen)

- (BOOL)bfa_isFullScreen{
    return (([self styleMask] & NSFullScreenWindowMask) == NSFullScreenWindowMask);
}

@end
