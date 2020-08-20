//
//  GMService.h
//  GMSDKForiOS
//
//  Created by Dario Lencina on 1/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GMSession.h"
#import "GMURLConnection.h"
@class GMService;

@interface GMService : NSOperation
@property(atomic)BOOL connectionFinishedLoading;
@property(strong)GMURLConnection * connection;
@property(strong)NSError * error;
@property (nonatomic, strong) id jsonResponse;
@end
