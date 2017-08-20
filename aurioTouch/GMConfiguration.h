//
//  GMBlackboard.h
//  EcoHub
//
//  Created by Dario Lencina on 2/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NSString kGMConfigurationEnvironment;
static kGMConfigurationEnvironment * const kGMConfigurationEnvironmentProduction=@"production";
static kGMConfigurationEnvironment * const kGMConfigurationEnvironmentDevelopmentTests=@"development";
static kGMConfigurationEnvironment * const kGMConfigurationEnvironmentMock=@"mock";

typedef enum GMConfigurationEnvironmentDevelopmentScenario{
    GMConfigurationEnvironmentDevelopmentScenarioSuccess=0,
    GMConfigurationEnvironmentDevelopmentScenarioFailure,
    GMConfigurationEnvironmentDevelopmentScenarioFailureUnableToLocateFile,
    GMConfigurationEnvironmentDevelopmentScenarioFailureCantGetDataFromURL
}GMConfigurationEnvironmentDevelopmentScenario;

@interface GMConfiguration : NSObject
-(void)setEnvironment:(kGMConfigurationEnvironment *)environment;
-(kGMConfigurationEnvironment *)environment;
+(GMConfiguration *)sharedInstance;
-(NSURL *)urlForService:(id)service;

//Test code

@property(nonatomic, assign) GMConfigurationEnvironmentDevelopmentScenario testScenario;

@end
