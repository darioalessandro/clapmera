//
//  UIViewController+DataLoading.h
//  EcoHub
//
//  Created by Dario Lencina on 2/27/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (DataLoading)
    -(void)addFailureScreenForError:(NSError *)error;
@end

@protocol UIViewControllerDataLoading <NSObject>
@required
-(void)reloadDataFromService;

@end
