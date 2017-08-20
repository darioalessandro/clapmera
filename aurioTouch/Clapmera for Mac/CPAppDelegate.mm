//
//  CPAppDelegate.m
//  Clapmera for Mac
//
//  Created by Dario Lencina on 5/8/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "CPAppDelegate.h"
#import "CPOverlayViewController.h"
#import "UIWindow+FullScreen.h"

@implementation CPAppDelegate

@synthesize window = _window;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification{
    self.cameraViewController = [[CPOverlayViewController alloc] initWithNibName:@"CPOverlayViewController" bundle:nil];
    self.cameraViewController.view.frame=NSRectFromCGRect(CGRectMake(0, 0, self.window.frame.size.width, self.window.frame.size.height));
    [[self window] setContentView:self.cameraViewController.view];
    NSRect rect= self.cameraViewController.view.frame;
    rect.origin.x=-1;
    rect.size.width+=1;
    self.cameraViewController.view.frame=rect;
    self.window.delegate=self;
}

#pragma mark -
#pragma mark UIWindow delegate

- (void)windowDidResize:(NSNotification *)notification{
    NSRect rect= self.cameraViewController.view.frame;
    rect.size.width+=1;
    self.cameraViewController.view.frame=rect;
}

- (BOOL)windowShouldClose:(id)sender{
    [[NSApplication sharedApplication] terminate:self];
    return TRUE;
}

#pragma mark -
#pragma mark QL

- (IBAction)togglePreviewPanel:(id)previewPanel{
    if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
        [[QLPreviewPanel sharedPreviewPanel] orderOut:nil];
    } else {
        [[QLPreviewPanel sharedPreviewPanel] makeKeyAndOrderFront:nil];
    }
}

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem{
    SEL action = [menuItem action];
    if (action == @selector(togglePreviewPanel:)) {
        if ([QLPreviewPanel sharedPreviewPanelExists] && [[QLPreviewPanel sharedPreviewPanel] isVisible]) {
            [menuItem setTitle:@"Clapmera Pic"];
        } else {
            [menuItem setTitle:@"Clapmera Pic"];
        }
        return YES;
    }
    return NO;
}



@end
