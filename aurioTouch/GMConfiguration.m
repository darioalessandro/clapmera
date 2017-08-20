//
//  GMBlackboard.m
//  EcoHub
//
//  Created by Dario Lencina on 2/12/13.
//  Copyright (c) 2013 Dario Lencina. All rights reserved.
//

#import "GMConfiguration.h"
#import "GMService.h"

static GMConfiguration * _configuration;

@interface GMConfiguration ()
    @property(nonatomic, strong) NSDictionary * configurationPlist;
@end

@implementation GMConfiguration{
    __strong kGMConfigurationEnvironment * _environment;
}

#pragma mark -
#pragma mark creation of GMConfiguration

+(GMConfiguration *)sharedInstance{
    if(!_configuration){
        _configuration=[GMConfiguration new];
    }
    return _configuration;
}

-(id)init{
    self=[super init];
    if(self){
        self.configurationPlist=[NSDictionary dictionaryWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"GMConfiguration" withExtension:@"plist"]];
        _environment=kGMConfigurationEnvironmentProduction;
    }
    return self;
}

#pragma mark -
#pragma mark environment

-(void)setEnvironment:(kGMConfigurationEnvironment *)environment{
    if(environment==nil){
        [NSException raise:@"Invalid parameter" format:@"trying to set environment to nil"];
    }
    _environment=environment;
}

-(kGMConfigurationEnvironment *)environment{
    return _environment;
}

#pragma mark -
#pragma mark Access to the plist.

-(NSString *)stringForKeyPath:(NSString *)keyPath{
    return [self.configurationPlist objectForKey:keyPath];
}

-(NSURL *)urlForKeyPath:(NSString *)keyPath{
    NSString * url= [self stringForKeyPath:keyPath];
    if(!url || [url isEqualToString:@""]){
        [NSException raise:@"Could not find URL" format:@"Could not find URL for path %@", keyPath];
    }
    return [NSURL URLWithString:url];
}

-(NSURL *)urlForService:(id)service{
    NSURL * url;
    if([service isKindOfClass:[GMService class]]){
        if ([self.environment isEqualToString:kGMConfigurationEnvironmentDevelopmentTests]) {
            NSDictionary * developmentDict;
                if(self.testScenario==GMConfigurationEnvironmentDevelopmentScenarioSuccess){
                developmentDict=@{@"SGGetVoltTickerService": @"GetVoltTickerDataSuccess", @"SGCostService": @"CostDataSuccess", @"SGConsumptionService": @"ConsumptionDataSuccess"};
                }else if(self.testScenario==GMConfigurationEnvironmentDevelopmentScenarioFailure){
                    developmentDict=@{@"SGGetVoltTickerService": @"GetVoltTickerDataFailure", @"SGCostService": @"CostDataFailure", @"SGConsumptionService": @"ConsumptionDataFailure"};
                }else if(self.testScenario==GMConfigurationEnvironmentDevelopmentScenarioFailureUnableToLocateFile){
                    developmentDict=@{@"SGGetVoltTickerService": @"mock", @"SGCostService": @"mock", @"SGConsumptionService": @"mock"};
                }else if(self.testScenario==GMConfigurationEnvironmentDevelopmentScenarioFailureCantGetDataFromURL){
                    developmentDict=@{@"SGGetVoltTickerService": @"http://www.google.com", @"SGCostService": @"http://www.google.com", @"SGConsumptionService": @"http://www.google.com"};
                    NSString * className= NSStringFromClass([service class]);
                    NSString * serviceURL=[developmentDict objectForKey:className];
                    return [NSURL URLWithString:serviceURL];
                }
            NSString * className= NSStringFromClass([service class]);
            NSBundle * mainBundle=[NSBundle bundleForClass:[self class]];
            NSString * serviceURL=[developmentDict objectForKey:className];
            url=[mainBundle URLForResource:serviceURL withExtension:nil];
        }else{
            url=[self urlForKeyPath:[NSString stringWithFormat:@"Services.%@.%@",_environment, [service class]]];            
        }
    }else{
        [NSException raise:@"Invalid parameter" format:@"service should be a member of GMService, but it's not, %@", [service class]];
    }
    return url;
}

@end
