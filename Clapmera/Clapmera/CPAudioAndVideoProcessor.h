

#import <AVFoundation/AVFoundation.h>
#import <CoreMedia/CMBufferQueue.h>
#import <UIKit/UIKit.h>

@protocol CPAudioAndVideoProcessorDelegate, CPAudioAndVideoProcessorChannelDelegate;

@interface CPAudioAndVideoProcessor : NSObject <AVCaptureAudioDataOutputSampleBufferDelegate, AVCaptureVideoDataOutputSampleBufferDelegate> 
{
	NSMutableArray *previousSecondTimestamps;
	Float64 videoFrameRate;
	CMVideoDimensions videoDimensions;
	CMVideoCodecType videoType;
	CMBufferQueueRef previewBufferQueue;
	
	
	AVAssetWriterInput *assetWriterAudioIn;
	AVAssetWriterInput *assetWriterVideoIn;
	dispatch_queue_t movieWritingQueue;

	// Only accessed on movie writing queue
    BOOL readyToRecordAudio; 
    BOOL readyToRecordVideo;
	BOOL recordingWillBeStarted;
	BOOL recordingWillBeStopped;

	BOOL recording;
}

@property (nonatomic, strong)AVAssetWriter *assetWriter;

@property (nonatomic, strong) NSURL *movieURL;
@property (nonatomic, strong) AVCaptureSession *captureSession;
@property (nonatomic, strong) AVCaptureConnection *audioConnection;
@property (nonatomic, strong) AVCaptureConnection *videoConnection;

@property (readwrite, assign) id <CPAudioAndVideoProcessorDelegate> delegate;
@property (readwrite, assign) id <CPAudioAndVideoProcessorChannelDelegate> audioDelegate;

@property (readonly) CMVideoDimensions videoDimensions;
@property (readonly) CMVideoCodecType videoType;

- (void)updateCaptureSession:(AVCaptureSession *)session;
- (void)updateVideoOrientation:(UIInterfaceOrientation)videoOrientation;

- (void) showError:(NSError*)error;

- (void) setupAndStartCaptureSessionWithSession:(AVCaptureSession *)session;
- (void) stopAndTearDownCaptureSession;

- (void) startRecording;
- (void) stopRecording;

- (void) pauseCaptureSession;
- (void) resumeCaptureSession;

@property(readonly, getter=isRecording) BOOL recording;

@end

@protocol CPAudioAndVideoProcessorChannelDelegate <NSObject>
@required
- (void)audioListener:(CPAudioAndVideoProcessor *)processor gotNewVolumeState:(AVCaptureAudioChannel *)state;
@end

@protocol CPAudioAndVideoProcessorDelegate <NSObject>
@required
- (void)pixelBufferReadyForDisplay:(CVPixelBufferRef)pixelBuffer; // This method is always called on the main thread.
- (void)recordingWillStart;
- (void)recordingDidStart;
- (void)recordingWillStop;
- (void)recordingDidStop;
@end
