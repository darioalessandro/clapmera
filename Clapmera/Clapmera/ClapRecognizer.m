//
//  ClapRecognizer.m
//  Clapmera
//
//  Created by Dario Lencina on 5/29/13.
//
//

#import "ClapRecognizer.h"

@implementation ClapRecognizer

-(id)init{
    self=[super init];
    if(self){
        self.state=ClapRecognizerStateInitial;
        self.sensitivity=0.3;
        self.averagePower=50;
    }
    return self;
}

-(void)start{
    self.isRecognizing=TRUE;
}

-(void)stop{
    self.isRecognizing=NO;
}

#define clapMaxLength 1.5

-(void)audioListener:(CPAudioAndVideoProcessor *)processor gotNewVolumeState:(AVCaptureAudioChannel *)state{
    if(self.isRecognizing==NO)
        return;
    
    if(self.averagePower==50){
        self.averagePower=state.averagePowerLevel;
        return;
    }
    
    if(self.state==ClapRecognizerStateSuccess)
        return;
    
    
    float deltaPower=state.peakHoldLevel-self.averagePower;
    if(deltaPower<0){
        
    }
    float requiredDelta=20;
    //    NSLog(@"********************");
    //    NSLog(@"average     %f", (self.averagePower));
    //    NSLog(@"peak        %f", state.peakHoldLevel);
    //    NSLog(@"difference  %f", deltaPower);
    
    if(self.averagePower<-50){
        requiredDelta=26;
    }else if(self.averagePower<-40){
        requiredDelta=25;
    }else if(self.averagePower<-30){
        requiredDelta=22;
    }else if(self.averagePower<-22){
        requiredDelta=18;
    }
    //    NSLog(@"req dif     %f", requiredDelta);
    //    NSLog(@"********************");
    if(deltaPower>requiredDelta && state.peakHoldLevel>-2){
        if(self.state==ClapRecognizerStateInitial){
            [self transitionToState:ClapRecognizerStatePossible];
            [self setDate:[NSDate date]];
        }else if(self.state==ClapRecognizerStatePossible){
            if([[NSDate date] timeIntervalSinceDate:self.date]>clapMaxLength){
                [self transitionToState:ClapRecognizerStateFailed];
                double delayInSeconds = 1;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    [self transitionToState:ClapRecognizerStateInitial];
                });
            }
        }
    }else if (self.state==ClapRecognizerStatePossible){
        if([[NSDate date] timeIntervalSinceDate:self.date]>clapMaxLength){
            [self transitionToState:ClapRecognizerStateSuccess];
            double delayInSeconds = 1;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self transitionToState:ClapRecognizerStateInitial];
            });
        }
    }
    self.averagePower=(state.averagePowerLevel+self.averagePower)/2;
}

-(void)transitionToState:(ClapRecognizerState)state{
    self.state=state;
    [self.delegate stateChanged:self];
}

@end
