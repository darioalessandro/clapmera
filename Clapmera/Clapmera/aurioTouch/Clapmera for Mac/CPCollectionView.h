//
//  CPCollectionView.h
//  Clapmera
//
//  Created by Dario Lencina on 5/31/13.
//
//

#import <Cocoa/Cocoa.h>
#import <QuickLook/QuickLook.h>
#import <Quartz/Quartz.h>

@interface CPCollectionView : NSCollectionView <QLPreviewPanelDataSource, QLPreviewPanelDelegate>

@end
