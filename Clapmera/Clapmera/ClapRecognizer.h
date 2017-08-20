//
//  ClapRecognizer.h
//  Clapmera
//
//  Created by Dario Lencina on 5/29/13.
//
//

#import <Foundation/Foundation.h>
#if TARGET_OS_IPHONE
#import <CoreMotion/CoreMotion.h>
#endif
#import "CPAudioAndVideoProcessor.h"

@class ClapRecognizer;
@protocol ClapRecognizerDelegate <NSObject>
@required
-(void)stateChanged:(ClapRecognizer *)clapRecognizer;
-(void)clapRecognizer:(ClapRecognizer *)clapRecognizer error:(NSError *)error;
@end

typedef enum ClapRecognizerError{
    ClapRecognizerErrorHighAverageVolume=0
} ClapRecognizerError;

typedef enum ClapRecognizerState{
    ClapRecognizerStateInitial=0,
    ClapRecognizerStatePossible,
    ClapRecognizerStateFailed,
    ClapRecognizerStateSuccess,
    ClapRecognizerStateCanceled,
    ClapRecognizerStateMovementDectected
} ClapRecognizerState;

@interface ClapRecognizer : NSObject <CPAudioAndVideoProcessorChannelDelegate>
-(void)start;
-(void)stop;
@property(nonatomic, assign)BOOL isRecognizing;
@property(nonatomic, assign)ClapRecognizerState state;
@property(nonatomic, assign)double sensitivity;
@property (nonatomic, assign) Float32 averagePower;
@property(nonatomic, assign) id <ClapRecognizerDelegate> delegate;
@property(nonatomic, strong) NSDate * date;

@end


