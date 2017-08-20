//
//  CPOverlayViewController.m
//  Clapmera
//
//  Created by Dario Lencina on 5/8/12.
//  Copyright (c) 2012 BlackFireApps. All rights reserved.
//

#import "CPOverlayViewController.h"
#define kCP_MenuButtonOff @"off.png"
#define kCP_MenuButtonOn @"listening.png"
#define kCP_MenuButtonProcessing @"processing.png"
#import "RCTimer.h"
#define KEY_IMAGE	@"icon"
#define KEY_NAME	@"name"


@interface CPOverlayViewController ()
    @property(nonatomic, strong) RCTimer * timer;
    @property(nonatomic, strong) ClapRecognizer * clapRecognizer;
    @property(nonatomic, strong) CPSoundManager * player;
@end

@implementation CPOverlayViewController{
    AVCaptureVideoPreviewLayer *_captureVideoPreviewLayer;
    AVCaptureSession * _session;
    NSInteger timerCounter;
}
@synthesize sensitivitySlider;
@synthesize sensorStateButton;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.player=[CPSoundManager new];
        self.clapRecognizer=[ClapRecognizer new];
        self.clapRecognizer.delegate=self;
        self.timer=[RCTimer new];
        self.clapmeraEngine=[ClapmeraEngine new];
    }

    
    return self;
}

-(void)stateChanged:(ClapRecognizer *)clapRecognizer{
    static BOOL isTriggering=NO;
    if(clapRecognizer.state==ClapRecognizerStateSuccess && isTriggering==NO){
        isTriggering=TRUE;
        [self.clapmeraEngine setClapmeraState:ClapmeraStateWaiting];
        [self updateClapmeraState:[CPConfiguration clapmeraState] updateUI:TRUE];
        [self.timer startTimerWithDuration:self.clapmeraConfiguration.timer withTickHandler:^(RCTimer *timer) {
            [self.player playBeepSound:CPSoundManagerAudioTypeSlow];
            [self.sensorStateButton setTitle:[NSString stringWithFormat:@"%ld", timer.timeRemaining]];
        } cancelHandler:^(RCTimer *timer) {
            isTriggering=NO;
        } andCompletionHandler:^(RCTimer *timer) {
            [self.player playBeepSound:CPSoundManagerAudioTypeFast];
            [self.sensorStateButton setTitle:NSLocalizedString(@"Smile!", nil)];            
            double delayInSeconds = 2.5;
            dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
            dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                [self snapPhoto];
                [self.sensorStateButton setTitle:NSLocalizedString(@"Processing", nil)];            
                [[self player] playCameraSound];
                double delayInSeconds = 2.0;
                dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
                dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
                    isTriggering=NO;
                    [CPConfiguration setClapmeraState:ClapmeraStateOn];
                    [self updateClapmeraState:[CPConfiguration clapmeraState] updateUI:TRUE];
                });
            });
        }];
    }
}

-(void)awakeFromNib{
    [super awakeFromNib];
    [CPConfiguration setClapmeraState:ClapmeraStateOn];
    [self updateClapmeraState:ClapmeraStateOn updateUI:TRUE];
    [self showCamera];
    [self.timerSlider setDoubleValue:self.clapmeraConfiguration.timer];
    [self setTimerValue:self.clapmeraConfiguration.timer];
    [self.sensitivitySlider setDoubleValue:self.clapmeraConfiguration.sensitivity];
    [self reloadImages];
    [self.gallery setDraggingSourceOperationMask:NSDragOperationCopy forLocal:NO];
    [self scrollToBottom:nil];    
}

-(void)reloadImages{
    NSString * documentsPath= [NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    documentsPath=[NSString stringWithFormat:@"%@/Clapmera", documentsPath];
    
    NSArray			*iconEntries = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:nil];
    NSMutableArray	*tempArray = [[NSMutableArray alloc] init];
    
    // read the list of icons from disk in 'icons.plist'
    if (iconEntries != nil)
    {
        NSInteger idx;
        NSInteger count = [iconEntries count];
        for (idx = 0; idx < count; idx++)
        {
            NSString *entry = [iconEntries objectAtIndex:idx];
            if (entry != nil)
            {
                
                NSString * path= [NSString stringWithFormat:@"%@/%@", documentsPath, entry];
                NSURL * url= [NSURL fileURLWithPath:path];
                NSImage *picture = [[NSImage alloc]initWithContentsOfFile:path];
                if(picture){
                    [tempArray addObject: [NSMutableDictionary dictionaryWithObjectsAndKeys:
                                       picture, KEY_IMAGE,
                                       entry, KEY_NAME,
                                       url, @"previewItemURL",
                                       nil]];
                }
            }
        }
    }
    [self setImages:[NSMutableArray arrayWithArray:tempArray]];
}

- (IBAction)onSensorStateClick:(NSButton *)sender {
    if(self.timer){
        [self.timer cancel];
    }
    self.timer=[RCTimer new];

    ClapmeraState state= [CPConfiguration clapmeraState];
    switch (state) {
        case ClapmeraStateOn:
            [CPConfiguration setClapmeraState:ClapmeraStateOff];
            break;
        case ClapmeraStateOff:
            [CPConfiguration setClapmeraState:ClapmeraStateOn];
            break;
        case ClapmeraStateWaiting:
            [CPConfiguration setClapmeraState:ClapmeraStateOn];
            break;
        default:
            break;
    }
    [self updateClapmeraState:[CPConfiguration clapmeraState] updateUI:TRUE];
}

-(void)snapPhoto{
    [self takePictureFromActiveSession];
}

- (void)updateClapmeraState:(ClapmeraState)state updateUI:(BOOL)updateUI{
    switch (state) {
        case ClapmeraStateOff:
            [self.sensorStateButton setImage:[NSImage imageNamed:kCP_MenuButtonOff]];
            [self.sensorStateButton setTitle:NSLocalizedString(@"Off", nil)];
            [self.clapRecognizer stop];
            break;
        case ClapmeraStateOn:
            [self.sensorStateButton setImage:[NSImage imageNamed:kCP_MenuButtonOn]];
            [self.sensorStateButton setTitle:NSLocalizedString(@"Listening", nil)];
            [self.clapRecognizer start];
            break;
        case ClapmeraStateWaiting:
            [self.sensorStateButton setImage:[NSImage imageNamed:kCP_MenuButtonProcessing]];
//            [self.sensorStateButton setTitle:NSLocalizedString(@"Off", nil)];
//            [self.clapRecognizer stop];
            break;
            
        default:
            break;
    }

}

#pragma mark -
#pragma mark ShowCamera

-(void)showCamera{
    if(!_captureVideoPreviewLayer){
        _session = [[AVCaptureSession alloc] init];
        _session.sessionPreset = AVCaptureSessionPresetHigh;
        _captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:_session];
        [self.cameraView.layer addSublayer:_captureVideoPreviewLayer];
        [_captureVideoPreviewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
        [_captureVideoPreviewLayer setGeometryFlipped:YES];
    }
    
	AVCaptureDevice *device = [self camera];
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if(!error){
        [[NSNotificationCenter defaultCenter] postNotificationName:CPOverlayViewControllerHideAccessToCameraError object:nil];
        if([_session inputs]){
            for (id input in [_session inputs]){
                [_session removeInput:input];
            }
        }
        [_session addInput:input];
        [_session startRunning];
        
        if(!self.stillImageOutput){
            self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
            NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
            [self.stillImageOutput setOutputSettings:outputSettings];
            [_session addOutput:self.stillImageOutput];
        }
        [self rotateCamera];
    }else{
        [[NSNotificationCenter defaultCenter] postNotificationName:CPOverlayViewControllerShowAccessToCameraError object:nil];
    }
}

-(AVCaptureDevice *)camera{
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];;
}

-(void)rotateCamera{
    _captureVideoPreviewLayer.frame = self.cameraView.bounds;
	[_captureVideoPreviewLayer setAutoresizingMask:kCALayerWidthSizable | kCALayerHeightSizable];
}

-(void)takePictureFromActiveSession{
    AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
                [videoConnection setAutomaticallyAdjustsVideoMirroring:YES];
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	BFLog(@"about to request a capture from: %@", self.stillImageOutput);
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         NSString * documentsPath= [self clapmeraPicturesDirectory];
         [[NSFileManager defaultManager] createDirectoryAtPath:documentsPath withIntermediateDirectories:NO attributes:nil error:nil];
         
         if([imageData writeToFile:[NSString stringWithFormat:@"%@/%@.jpg", documentsPath, [NSDate date]] atomically:TRUE]){
             BFLog(@"TRUE");
         }else{
            BFLog(@"False");
         }
         [[NSOperationQueue mainQueue] addOperationWithBlock:^{
             [self reloadImages];
             [self scrollToBottom:nil];
         }];
	 }];
}

-(NSString *)clapmeraPicturesDirectory{
    NSString * documentsPath= NSSearchPathForDirectoriesInDomains(NSPicturesDirectory, NSUserDomainMask, YES)[0];
    documentsPath=[NSString stringWithFormat:@"%@/Clapmera", documentsPath];
    return documentsPath;
}

- (void)scrollToBottom:sender{
    NSPoint newScrollOrigin;
    

    newScrollOrigin=NSMakePoint(NSMaxX([[self.galleryScrollView  documentView] frame])
                                    -NSWidth([[self.galleryScrollView  contentView] bounds]), 0.0);
    
    [[self.galleryScrollView  documentView] scrollPoint:newScrollOrigin];
    
}

-(IBAction)onTimerChanged:(NSSlider *)sender {
    [self setTimerValue:(NSInteger)round([sender doubleValue])];
}

-(IBAction)showSettings:(NSButton *)sender {
    if([[self popOver] isShown]){
        [[self popOver] close];
    }else{
        [[self popOver] showRelativeToRect:sender.bounds ofView:sender preferredEdge:NSMaxXEdge];
    }
}

-(void)setTimerValue:(NSInteger)delayValue{
    BOOL shouldUseS=[self shouldUseS];
    self.timerLabel.stringValue = [NSString stringWithFormat:@"%ld %@", (long)delayValue, NSLocalizedString(@"timeunit", nil)];
    if(shouldUseS){
        self.timerLabel.stringValue=[NSString stringWithFormat:@"%@%@", self.timerLabel.stringValue, (delayValue == 1) ?@"": @"s"];
    }
    self.clapmeraConfiguration.timer=(NSInteger)delayValue;
    [self.clapmeraConfiguration save];
}

-(IBAction)onSensitivityChanged:(NSSlider *)sender {
    self.clapmeraConfiguration.sensitivity=[sender doubleValue];
    self.clapRecognizer.sensitivity=self.clapmeraConfiguration.sensitivity;
    [self.clapmeraConfiguration save];
}

-(BOOL)shouldUseS{
    NSString * timeUnit= NSLocalizedString(@"timeunit", nil);
    BOOL shouldUseS=NO;
    NSRange range=[timeUnit rangeOfString:@"se"];
    NSRange notFound={NSNotFound, 0};
    if(!NSEqualRanges(range, notFound)){
        shouldUseS=YES;
    }
    return shouldUseS;
}

-(void)didSelectRow:(NSCollectionView *)sender{
    NSIndexSet * set=[sender selectionIndexes];
    NSInteger index= [set firstIndex];
    NSDictionary * image= [self.images objectAtIndex:index];
    NSString * fileURL1= [image objectForKey:@"name"];
    fileURL1= [NSString stringWithFormat:@"%@/%@", [self clapmeraPicturesDirectory], fileURL1];
    NSArray *fileURLs = @[[NSURL fileURLWithPath:fileURL1]];
    [[NSWorkspace sharedWorkspace] activateFileViewerSelectingURLs:fileURLs];
}

- (BOOL)collectionView:(NSCollectionView *)cv writeItemsAtIndexes:(NSIndexSet *)indexes toPasteboard:(NSPasteboard *)pasteboard
{
    NSMutableArray *urls = [NSMutableArray array];
    NSURL *temporaryDirectoryURL = [NSURL fileURLWithPath:NSTemporaryDirectory() isDirectory:YES];
    [indexes enumerateIndexesUsingBlock:^(NSUInteger idx, BOOL *stop)
     {
         NSDictionary *dictionary = [[cv content] objectAtIndex:idx];
         NSImage *image = [dictionary objectForKey:KEY_IMAGE];
         NSString *name = [dictionary objectForKey:KEY_NAME];
         NSBitmapImageRep *bitmapRep;
         if (image && name)
         {
             NSURL *url = [temporaryDirectoryURL URLByAppendingPathComponent:[NSString stringWithFormat:@"%@", name]];
             [urls addObject:url];
             [image lockFocus];
             bitmapRep = [[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0, 0, image.size.width, image.size.height)];
             [image unlockFocus];
             [[bitmapRep representationUsingType:NSPNGFileType properties:nil] writeToURL:url atomically:YES];
         }
     }];
    if ([urls count] > 0)
    {
        [pasteboard clearContents];
        return [pasteboard writeObjects:urls];
    }
    return NO;
}

@end
