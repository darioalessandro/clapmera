//
//  ConfigurationView.m
//  Clapmera
//
//  Created by Dario Lencina on 5/29/13.
//
//

#import "ConfigurationView.h"

@implementation ConfigurationView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
    // set any NSColor for filling, say white:
    [[NSColor colorWithCalibratedRed:0.2 green:0.2 blue:0.2 alpha:1] setFill];
    NSRectFill(dirtyRect);
    [super drawRect:dirtyRect];
}

- (void)keyDown:(NSEvent *)theEvent
{
    NSString* key = [theEvent charactersIgnoringModifiers];
    if([key isEqual:@" "]) {
        [[NSApp delegate] performSelector:@selector(togglePreviewPanel:) withObject:self];
    } else {
        [super keyDown:theEvent];
    }
}

@end
