//
//  SystemSpinnerManager.h
//  EcoHub
//
//  Created by Dario Lencina on 3/1/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NetworkActivityIndicatorManager : NSObject
-(void)updateSpinner;
-(void)startSpinning;
-(void)stopSpinning;
+(NetworkActivityIndicatorManager *)sharedManager;
@end
