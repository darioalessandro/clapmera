//
//  ClapEngine.m
//  Clapmera
//
//  Created by Dario Lencina on 6/30/13.
//
//

#import "ClapmeraEngine.h"
#import "CPSoundManager.h"
#import "CPConfiguration.h"
#import "InAppPurchasesManager.h"

@interface ClapmeraEngine  ()
    -(void)setState:(ClapmeraEngineState)state;
    @property(atomic, strong) RCTimer * timer;
    @property(nonatomic, strong) ClapRecognizer * clapRecognizer;
    @property(nonatomic, strong) CPSoundManager * player;
    @property(nonatomic, assign) ClapmeraEngineState _state;
    @property(nonatomic, assign) ClapmeraEngineState _pausedState;

@end

@implementation ClapmeraEngine

-(id)init{
    self=[super init];
    if(self){
        self.clapRecognizer=[ClapRecognizer new];
        self.clapRecognizer.delegate=self;
        self.player= [[CPSoundManager alloc] init];
        [self set_state:ClapmeraEngineStateListening];
        self.timer=[RCTimer new];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateSensitivity:) name:CPConfigurationSensitivityChanged object:nil];
        self.videoProcessor = [[CPAudioAndVideoProcessor alloc] init];
        self.videoProcessor.delegate = self;
        self.videoProcessor.audioDelegate=self.clapRecognizer;
    }
    return self;
}

-(void)setState:(ClapmeraEngineState)state{
    self._state=state;
    switch (state) {
        case ClapmeraEngineStateOff:
            [self.clapRecognizer stop];
            [UIApplication sharedApplication].idleTimerDisabled = NO;
            break;
            
        case ClapmeraEngineStateListening:
            [self.clapRecognizer start];
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            break;
            
        case ClapmeraEngineStateCounting:
            [self startCounting];
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            break;
            
        case ClapmeraEngineStateCapturing:
            [UIApplication sharedApplication].idleTimerDisabled = YES;
            break;
        case ClapmeraEngineStateUnknown:
        case ClapmeraEngineStateCanceledCapture:
        default:
            [self cancelCapture];
            break;
    }
    [self.clapmeraViewController stateChanged:self];
}

-(ClapmeraEngineState)state{
    return self._state;
}

-(void)toggleState{
    if (self._state==ClapmeraEngineStateListening) {
        [self stopListening];
    }else if(self._state==ClapmeraEngineStateOff){
        [self startListening];
    }else if(self._state==ClapmeraEngineStateCounting){
        [self cancelCapture];
        [self setState:ClapmeraEngineStateListening];
    }else if(self._state==ClapmeraEngineStateCapturing){
        [self cancelCapture];
        [self setState:ClapmeraEngineStateListening];
    }
}

-(void)cancelCapture{
    if([self.videoProcessor isRecording]){
        [self.videoProcessor stopRecording];
    }
    [self.timer cancel];
}

-(void)startListening{
    [self setState:ClapmeraEngineStateListening];
}

-(void)pause{
    [self.videoProcessor pauseCaptureSession];
    self._pausedState=self._state;
    [self stopListening];
}

-(void)resume{
    [self.videoProcessor resumeCaptureSession];
    if(self._pausedState==ClapmeraEngineStateUnknown){
        return;
    }else if(self._pausedState==ClapmeraEngineStateOff){
        [self stopListening];
    }else{
        [self startListening];
    }
}

-(void)stopListening{
    if([self.timer isCounting]){
        [self cancelCapture];
    }
    [self setState:ClapmeraEngineStateOff];
}

-(void)startCounting{
    [self.player playBeepSound:CPSoundManagerAudioTypeSlow];            
    [[self timer] startTimerWithDuration:[CPConfiguration delay] withTickHandler:^(RCTimer *timer) {
        if([timer timeRemaining]>2){
            [self.player playBeepSound:CPSoundManagerAudioTypeSlow];
        }else{
            if([timer timeRemaining]==2){
                [self.player playBeepSound:CPSoundManagerAudioTypeFast];
            }
        }
        [self.clapmeraViewController clapmeraEngine:self timerDidTic:timer];
    } cancelHandler:^(RCTimer *timer) {        
            [self.player playBeepSound:CPSoundManagerAudioTypeSlowDescendant];
    } andCompletionHandler:^(RCTimer *timer) {
        if(self._state!=ClapmeraEngineStateCanceledCapture && [self.timer wasCancel]==NO){
            [self setState:ClapmeraEngineStateCapturing];
            [self takeMediaBasedOnOperationMode];
        }else{
            [self setState:ClapmeraEngineStateListening];
        }
    }];
}

-(NSError *)errorForClapmeraError:(ClapmeraEngineError)clapmeraErrorCode{
    return [NSError errorWithDomain:@"Domain" code:clapmeraErrorCode userInfo:nil];
}

#pragma mark -
#pragma mark ClapRecognizerDelegate

-(void)clapRecognizer:(ClapRecognizer *)clapRecognizer error:(NSError *)error{
   [self.clapmeraViewController clapmeraEngine:self didThrowError:[self errorForClapmeraError:ClapmeraEngineErrorhighVolume]];
}

-(void)stateChanged:(ClapRecognizer *)clapRecognizer{
    if(self._state==ClapmeraEngineStateOff){
        BFLog(@"ignoring clap because engine is off");
        return;
    }
    
    if(self._state==ClapmeraEngineStateCapturing && clapRecognizer.state==ClapRecognizerStateSuccess){
        [self cancelCapture];
        [self setState:ClapmeraEngineStateListening];
        BFLog(@"ignoring clap because engine is ClapmeraEngineStateClickingPicture");
        return;
    }
    
    if(clapRecognizer.state==ClapRecognizerStateSuccess && self._state==ClapmeraEngineStateCanceledCapture){
        BFLog(@"ignoring clap because clapRecognizer.state==ClapRecognizerStateSuccess && self._state==ClapmeraEngineStateCanceledPicture");
        return;
    }
    
    if(clapRecognizer.state==ClapRecognizerStatePossible){
        [self.player playBeepSound:CPSoundManagerAudioTypePossibleDetection];
    }
    
    if(clapRecognizer.state==ClapRecognizerStateFailed){
        [self.player playBeepSound:CPSoundManagerAudioTypeFailedDetection];
    }
    
    if(self._state==ClapmeraEngineStateCounting && clapRecognizer.state==ClapRecognizerStateSuccess){
        [self setState:ClapmeraEngineStateCanceledCapture];
        [self setState:ClapmeraEngineStateListening];
    }else if(clapRecognizer.state==ClapRecognizerStateSuccess && self._state==ClapmeraEngineStateListening){
        [self setState:ClapmeraEngineStateCounting];
    }
}

#pragma mark -
#pragma mark TakePhotosMethods

-(void)takeMediaBasedOnOperationMode{
    if([CPConfiguration operationMode]==CPConfigurationOpeationModeVideo){
        [self takeVideo];
    }else{
        [self takePhoto];
    }
}

-(void)takePhoto{
    [self setState:ClapmeraEngineStateCapturing];
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.imageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	BFLog(@"about to request a capture from: %@", self.imageOutput);
	[self.imageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
         if([CPConfiguration operationMode]==CPConfigurationOperationModeBurst && [self.timer wasCancel]==NO){
             double delayInSeconds = 1;
             dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
             dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self setState:ClapmeraEngineStateCounting];
             });

         }else{
             [self setState:ClapmeraEngineStateListening];
         }
	 }];
}

-(void)takeVideo{
    if([self.videoProcessor isRecording]){
        [self.videoProcessor stopRecording];
    }
    [self.videoProcessor startRecording];
}

-(void)image: (UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void*)contextInfo{
    if (error){
        [self.clapmeraViewController clapmeraEngine:self didThrowError:[self errorForClapmeraError:ClapmeraEngineErrorAppHasNoAccessToPhotos]];
    }
}

#pragma mark -
#pragma video processor

- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer{
    
}

- (void)recordingWillStart{
    
}

- (void)recordingDidStart{
    
}

- (void)recordingWillStop{
    
}

- (void)recordingDidStop{
    
}


@end
