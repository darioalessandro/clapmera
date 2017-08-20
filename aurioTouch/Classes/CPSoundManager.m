//
//  CPSoundManager.m
//  Clapmera
//
//  Created by Dario Lencina on 5/6/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "CPSoundManager.h"

@implementation CPSoundManager{
    __strong AVAudioPlayer * clickPlayer;
}


static NSURL * beepURL = nil;
static NSURL * fastBeepURL = nil;
static NSURL * beepCancel = nil;
static NSURL * beepPossible = nil;
static NSURL * beepFailed = nil;

-(NSURL*)beep:(CPSoundManagerAudioType)beepType{
    if (beepType == CPSoundManagerAudioTypeFast) {
        if(!fastBeepURL){
            fastBeepURL= [[NSBundle mainBundle] URLForResource:@"fastBeep" withExtension:@"aif"];
        }
        
        return fastBeepURL;
    } else if(beepType==CPSoundManagerAudioTypeSlow){
        if(!beepURL){
            beepURL = [[NSBundle mainBundle] URLForResource:@"beep" withExtension:@"aif"];
        }
        return beepURL;
    }
    if(beepType==CPSoundManagerAudioTypeSlowDescendant){
        if(!beepCancel){
            beepCancel = [[NSBundle mainBundle] URLForResource:@"beepCancel" withExtension:@"aif"];
        }
        return beepCancel;
    }
    if(beepType==CPSoundManagerAudioTypePossibleDetection){
        if(!beepPossible){
            beepPossible = [[NSBundle mainBundle] URLForResource:@"beepPossible" withExtension:@"aif"];
        }
        return beepPossible;
    }
    if(beepType==CPSoundManagerAudioTypeFailedDetection){
        if(!beepFailed){
            beepFailed = [[NSBundle mainBundle] URLForResource:@"beepFailed" withExtension:@"aif"];
        }
        return beepFailed;
    }
    return nil;
}

-(void)playCameraSound{
    clickPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[[NSBundle mainBundle] URLForResource:@"click" withExtension:@"wav"] error:nil];
    [clickPlayer play];
}

-(void)playBeepSound:(CPSoundManagerAudioType)audioId{
    [self stopPlayer];
    self.player = [[AVAudioPlayer alloc] initWithContentsOfURL:[self beep:audioId] error:nil];
    [self.player play];
}

-(void)stopPlayer{
    if(_player){
        [_player stop];
        _player = nil;
    }
}

-(void)vibrate:(id)sender{
    
//    AudioServicesPlaySystemSound (kSystemSoundID_Vibrate);
//    I think a vibration would be anoying becase if you put the iPhone just laying on its side, maybe it could fall with the movement
}

-(void)dealloc{
    if(_player){
        _player = nil;
    }
    
    if (fastBeepURL) {
        fastBeepURL = nil;
    }
    
    if (beepURL) {
        beepURL = nil;
    }
    
}

@end