//
//  CPCollectionView.m
//  Clapmera
//
//  Created by Dario Lencina on 5/31/13.
//
//

#import "CPCollectionView.h"
#import <AppKit/AppKit.h>
#import "NSDictionary+QuickLook.h"

@implementation CPCollectionView

#pragma mark Overrides

-(void)awakeFromNib{

}

#pragma mark -
// Quick Look panel data source

- (NSInteger)numberOfPreviewItemsInPreviewPanel:(QLPreviewPanel *)panel
{
    return 1;
}

- (id <QLPreviewItem>)previewPanel:(QLPreviewPanel *)panel previewItemAtIndex:(NSInteger)index
{
    return [self content][[self.selectionIndexes firstIndex]];
}

- (BOOL)acceptsPreviewPanelControl:(QLPreviewPanel *)panel;
{
    return YES;
}

- (void)beginPreviewPanelControl:(QLPreviewPanel *)panel
{
    [[QLPreviewPanel sharedPreviewPanel] setDataSource:self];
}

- (void)endPreviewPanelControl:(QLPreviewPanel *)panel
{

}

- (BOOL)acceptsFirstResponder{
    return YES;
}

- (BOOL)becomeFirstResponder{
    return YES;
}

- (BOOL)resignFirstResponder{
    return YES;
}

- (void)mouseDown:(NSEvent *)theEvent{
    [super mouseDown:theEvent];
}

- (void)rightMouseUp:(NSEvent *)theEvent{
    [super rightMouseUp:theEvent];
    [self.delegate performSelector:@selector(didSelectRow:) withObject:self];
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
