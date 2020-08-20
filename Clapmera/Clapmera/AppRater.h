//
//  AppRater.h
//  publictransportationroutes
//
//  Created by Dario Lencina on 8/29/11.
//  Copyright 2011 BlackFireApps. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AppRaterProvider <NSObject>

-(NSString *)appId;
-(NSString *)contactEmail;
-(NSInteger)maxAppRaterCounter;

@end

@interface AppRater : NSObject <UIAlertViewDelegate>{
    id <AppRaterProvider> __weak provider;
}

@property(nonatomic,weak) id <AppRaterProvider> provider;

+(AppRater *)sharedInstance;
-(NSString *)version;
-(void)startMonitoringIfNeededOtherwiseCommitSuicide;

@end

