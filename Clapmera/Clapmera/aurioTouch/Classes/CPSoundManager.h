//
//  CPSoundManager.h
//  Clapmera
//
//  Created by Dario Lencina on 5/6/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import <Foundation/Foundation.h>
#include <AVFoundation/AVFoundation.h>
#include <AudioToolbox/AudioToolbox.h>

typedef enum CPSoundManagerAudioType {
    CPSoundManagerAudioTypeSlow=0,
    CPSoundManagerAudioTypeFast,
    CPSoundManagerAudioTypeSlowDescendant,
    CPSoundManagerAudioTypeFailedDetection,
    CPSoundManagerAudioTypePossibleDetection
    } CPSoundManagerAudioType;

@interface CPSoundManager : NSObject

@property(nonatomic, strong)AVAudioPlayer * player;

-(void)stopPlayer;

-(void)playBeepSound:(CPSoundManagerAudioType)audioId;

-(void)vibrate:(id)sender;

-(void)playCameraSound;

@end