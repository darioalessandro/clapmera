//
//  CPAppDelegate.h
//  Clapmera for Mac
//
//  Created by Dario Lencina on 5/8/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "CPSoundManager.h"
#import <AppKit/AppKit.h>
#import <QuickLook/QuickLook.h>

@class CPOverlayViewController;

@interface CPAppDelegate : NSObject <NSApplicationDelegate, NSWindowDelegate>

- (IBAction)togglePreviewPanel:(id)previewPanel;
@property (weak) IBOutlet NSWindow *window;
@property(strong)CPOverlayViewController* cameraViewController;

@end
