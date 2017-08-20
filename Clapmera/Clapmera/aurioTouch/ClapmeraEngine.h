//
//  ClapEngine.h
//  Clapmera
//
//  Created by Dario Lencina on 6/30/13.
//
//

#import <Foundation/Foundation.h>
#import "ClapRecognizer.h"
#import "RCTimer.h"
#import <AVFoundation/AVFoundation.h>
#import "CPAudioAndVideoProcessor.h"

typedef enum ClapmeraEngineState{
    ClapmeraEngineStateUnknown=0,
    ClapmeraEngineStateOff,
    ClapmeraEngineStateListening,
    ClapmeraEngineStateCounting,
    ClapmeraEngineStateCapturing,
    ClapmeraEngineStateCanceledCapture,
    
} ClapmeraEngineState;

typedef enum ClapmeraEngineError{
    ClapmeraEngineErrorUserRanOutOfPictures=0,
    ClapmeraEngineErrorAppHasNoAccessToPhotos,
    ClapmeraEngineErrorhighVolume
}ClapmeraEngineError;

@class ClapmeraEngine;
@protocol ClapmeraEngineProtocol <NSObject>
@required
-(void)stateChanged:(ClapmeraEngine *)clapmeraEngine;
-(void)clapmeraEngine:(ClapmeraEngine *)clapmeraEngine timerDidTic:(RCTimer *)timer;
-(void)clapmeraEngine:(ClapmeraEngine *)clapmeraEngine didThrowError:(NSError *)error;
@end

@interface ClapmeraEngine : NSObject <ClapRecognizerDelegate, CPAudioAndVideoProcessorDelegate>
    -(void)startListening;
    -(void)stopListening;
    -(void)cancelCapture;
    -(void)toggleState;
    -(void)pause;
    -(void)resume;
    -(ClapmeraEngineState)state;
    @property(weak, nonatomic)      id<ClapmeraEngineProtocol>  clapmeraViewController;
    @property (nonatomic, retain)   AVCaptureStillImageOutput * imageOutput;
    @property (nonatomic, strong)   AVCaptureSession * session;
    @property(nonatomic, strong) CPAudioAndVideoProcessor * videoProcessor;
@end


