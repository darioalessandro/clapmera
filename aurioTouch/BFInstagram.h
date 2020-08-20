//
//  BFInstagram.h
//  BlackFireApps
//
//  Created by Dario Lencina on 3/3/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BFInstagram;

typedef void(^BFInstagramHandler)(BFInstagram * instagram, NSError *error);

@interface BFInstagram : NSObject <UIDocumentInteractionControllerDelegate>
@property(nonatomic, copy) BFInstagramHandler handler;

-(void)sharePictureOnInstagram:(UIImage *)picture withText:(NSString *)text onViewController:(UIViewController *)controller;

@end
