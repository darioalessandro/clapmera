//
//  CMMenuViewController.h
//  Clapmera
//
//  Created by Dario Lencina on 7/29/12.
//
//


#import "BFGalleryViewController.h"
#import <QuickLook/QuickLook.h>
#import "ClapmeraViewController.h"

@interface CMMenuViewController : BFGalleryViewController <UIDocumentInteractionControllerDelegate>
    @property (strong, nonatomic)  UIDocumentInteractionController * docController;
    @property (weak, nonatomic) ClapmeraViewController * clapmeraViewController;
@end
