//
//  PhotoCaptureViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "PhotoCaptureViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "AppManager.h"
#import <THObserversAndBinders/THObserver.h>
#import "BeaconManager.h"
#import "ErrorHelper.h"
#import <WBSuccessNoticeView.h>

static char * const AVCaptureStillImageIsCapturingStillImageContext = "AVCaptureStillImageIsCapturingStillImageContext";



@interface PhotoCaptureViewController ()
{
    UIView *flashView;
    THObserver *beaconsObserver;
}

@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IBOutlet UIView *previewView;
@property (nonatomic) AVCaptureDevice *videoDevice;

@end

@implementation PhotoCaptureViewController


-(IBAction)changeFlashSetting:(UIButton *)sender
{
    AVCaptureDevice *currentDevice = self.videoDevice;
    
    if([currentDevice isFlashAvailable]){
        NSError *error = nil;
        [currentDevice lockForConfiguration:&error];
        if(!error){
            if (currentDevice.torchMode == AVCaptureTorchModeOff)
            {
                [currentDevice setTorchMode:AVCaptureTorchModeOn];
                [currentDevice setFlashMode:AVCaptureFlashModeOn];
            }
            else
            {
                [currentDevice setTorchMode:AVCaptureTorchModeOff];
                [currentDevice setFlashMode:AVCaptureFlashModeOff];
            }
            [currentDevice unlockForConfiguration];
        }
    }

}

-(void)tapToFocus:(UITapGestureRecognizer *)singleTap{
    CGPoint touchPoint = [singleTap locationInView:self.previewView];
    CGPoint convertedPoint = [self.previewLayer captureDevicePointOfInterestForPoint:touchPoint];
    AVCaptureDevice *currentDevice = self.videoDevice;
    
    if([currentDevice isFocusPointOfInterestSupported] && [currentDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]){
        NSError *error = nil;
        [currentDevice lockForConfiguration:&error];
        if(!error){
            [currentDevice setFocusPointOfInterest:convertedPoint];
            [currentDevice setFocusMode:AVCaptureFocusModeAutoFocus];
            [currentDevice unlockForConfiguration];
        }
    }
}

// converts UIDeviceOrientation to AVCaptureVideoOrientation
static AVCaptureVideoOrientation avOrientationForDeviceOrientation(UIDeviceOrientation deviceOrientation)
{
    AVCaptureVideoOrientation result = AVCaptureVideoOrientationPortrait;
    if ( deviceOrientation == UIDeviceOrientationLandscapeLeft )
        result = AVCaptureVideoOrientationLandscapeRight;
    else if ( deviceOrientation == UIDeviceOrientationLandscapeRight )
        result = AVCaptureVideoOrientationLandscapeLeft;
    return result;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAVCapture];
    [self setupFlash];
    [self setupObserver];
}

-(void)setupObserver
{
    beaconsObserver = [THObserver observerForObject:[AppManager sharedInstance].beaconManager keyPath:NSStringFromSelector(@selector(beaconsArray)) block:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            self.peopleCounter.text = [NSString stringWithFormat:@"People: %d", [AppManager sharedInstance].beaconManager.beaconsArray.count];
        });
    }];
}

- (void)setupFlash
{
    flashView = [[UIView alloc] initWithFrame:self.previewView.frame];
    flashView.backgroundColor = [UIColor whiteColor];
    flashView.alpha = 0;
}

- (void)setupAVCapture
{
    self.session = [AVCaptureSession new];
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto]; // high-res stills, screen-size video
    
    [self updateCameraSelection];
    
    // For displaying live feed to screen
    CALayer *rootLayer = self.previewView.layer;
    [rootLayer setMasksToBounds:YES];
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [self.previewLayer setBackgroundColor:[[UIColor blackColor] CGColor]];
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    [self.previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:self.previewLayer];
    
    [self.session startRunning];
    
    self.stillImageOutput = [AVCaptureStillImageOutput new];
    if ( [self.session canAddOutput:self.stillImageOutput] ) {
        [self.session addOutput:self.stillImageOutput];
    } else {
        self.stillImageOutput = nil;
    }
    
    // this will allow us to sync freezing the preview when the image is being captured
    [self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:AVCaptureStillImageIsCapturingStillImageContext];
    
    
    UITapGestureRecognizer *tapGR = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapToFocus:)];
    [tapGR setNumberOfTapsRequired:1];
    [tapGR setNumberOfTouchesRequired:1];
    [self.previewView addGestureRecognizer:tapGR];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self updatePreviewBounds];
}

-(void)updatePreviewBounds
{
    CALayer *rootLayer = self.previewView.layer;
    [self.previewLayer setFrame:[rootLayer bounds]];
    
    if ([self.previewLayer.connection isVideoOrientationSupported])
    {
        UIDeviceOrientation curDeviceOrientation = [UIDevice currentDevice].orientation;
        AVCaptureVideoOrientation avcaptureOrientation = avOrientationForDeviceOrientation(curDeviceOrientation);
        [self.previewLayer.connection setVideoOrientation:avcaptureOrientation];
    }
    flashView.frame = self.previewView.frame;
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator
{
    
    [coordinator animateAlongsideTransition:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self     updatePreviewBounds];
    } completion:^(id<UIViewControllerTransitionCoordinatorContext> context) {
        [self     updatePreviewBounds];
    }];
    
    [super viewWillTransitionToSize: size withTransitionCoordinator: coordinator];
}



- (void) updateCameraSelection
{
    // Changing the camera device will reset connection state, so we call the
    // update*Detection functions to resync them.  When making multiple
    // session changes, wrap in a beginConfiguration / commitConfiguration.
    // This will avoid consecutive session restarts for each configuration
    // change (noticeable delay and camera flickering)
    
    [self.session beginConfiguration];
    
    // have to remove old inputs before we test if we can add a new input
    NSArray* oldInputs = [self.session inputs];
    for (AVCaptureInput *oldInput in oldInputs)
        [self.session removeInput:oldInput];
    
    AVCaptureDeviceInput* input = [self pickCamera];
    if ( ! input ) {
        // failed, restore old inputs
        for (AVCaptureInput *oldInput in oldInputs)
            [self.session addInput:oldInput];
    } else {
        // succeeded, set input and update connection states
        [self.session addInput:input];
    }
    [self.session commitConfiguration];
}

// this will freeze the preview when a still image is captured, we will unfreeze it when the graphics code is finished processing the image
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ( context == AVCaptureStillImageIsCapturingStillImageContext ) {
        BOOL isCapturingStillImage = [[change objectForKey:NSKeyValueChangeNewKey] boolValue];
        
        if ( isCapturingStillImage ) {
            [self.previewView.superview addSubview:flashView];
            [UIView animateWithDuration:.4f
                             animations:^{ flashView.alpha=0.65f; }
             ];
            self.previewLayer.connection.enabled = NO;
        }
    }
}

// Graphics code will call this when still image capture processing is complete
- (void) unfreezePreview
{
    self.previewLayer.connection.enabled = YES;
    [UIView animateWithDuration:.4f
                     animations:^{ flashView.alpha=0; }
                     completion:^(BOOL finished){ [flashView removeFromSuperview]; }
     ];
}


#pragma mark - View lifecycle

- (void)dealloc
{
    [self teardownAVCapture];
    flashView = nil;
}


- (void)teardownAVCapture
{
    [self.session stopRunning];
    
    [self.stillImageOutput removeObserver:self forKeyPath:@"capturingStillImage"];
    
    [self.previewLayer removeFromSuperlayer];
    self.previewLayer = nil;
    
    self.session = nil;
}

- (AVCaptureDeviceInput*) pickCamera
{
    AVCaptureDevicePosition desiredPosition = AVCaptureDevicePositionBack;
    BOOL hadError = NO;
    for (AVCaptureDevice *d in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([d position] == desiredPosition) {
            NSError *error = nil;
            AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:d error:&error];
            self.videoDevice = d;
            if (error) {
                hadError = YES;
            } else if ( [self.session canAddInput:input] ) {
                return input;
            }
        }
    }
    if ( ! hadError ) {
        // no errors, simply couldn't find a matching camera
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


// writes the image to the asset library
void writeJPEGDataToCameraRoll(NSData* data, NSDictionary* metadata)
{
    ALAssetsLibrary *library = [ALAssetsLibrary new];
    [library writeImageDataToSavedPhotosAlbum:data metadata:metadata completionBlock:^(NSURL *assetURL, NSError *error) {
        if (error) {
            displayErrorOnMainQueue(error, @"Save to camera roll failed");
        }
    }];
}

- (IBAction)takePicture:(id)sender
{
    // Find out the current orientation and tell the still image output.
    AVCaptureConnection *stillImageConnection = [self.stillImageOutput connectionWithMediaType:AVMediaTypeVideo];
    UIDeviceOrientation curDeviceOrientation = [[UIDevice currentDevice] orientation];
    AVCaptureVideoOrientation avcaptureOrientation = avOrientationForDeviceOrientation(curDeviceOrientation);
    [stillImageConnection setVideoOrientation:avcaptureOrientation];
    [stillImageConnection setAutomaticallyAdjustsVideoMirroring:NO];
    [stillImageConnection setVideoMirrored:[self.previewLayer.connection isVideoMirrored]];
    [self.stillImageOutput setOutputSettings:[NSDictionary dictionaryWithObject:AVVideoCodecJPEG
                                                                             forKey:AVVideoCodecKey]];
    
    [self.stillImageOutput captureStillImageAsynchronouslyFromConnection:stillImageConnection completionHandler:
     ^(CMSampleBufferRef imageDataSampleBuffer, NSError *error) {
         if (error) {
             displayErrorOnMainQueue(error, @"Take picture failed");
         } else if ( ! imageDataSampleBuffer ) {
             displayErrorOnMainQueue(nil, @"Take picture failed: received null sample buffer");
         } else {
             
                 // Simple JPEG case, just save it
                NSData *jpegData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
                UIImage *image = [[UIImage alloc] initWithData:jpegData];
             UIImage *scaledImage = nil;
             CGSize targetSize = CGSizeMake(image.size.width * 0.25f,image.size.height * 0.25f);
             UIGraphicsBeginImageContext(targetSize);
             
             CGRect thumbnailRect = CGRectMake(0, 0, 0, 0);
             thumbnailRect.origin = CGPointMake(0.0,0.0);
             thumbnailRect.size.width  = targetSize.width;
             thumbnailRect.size.height = targetSize.height;
             
             [image drawInRect:thumbnailRect];
             
             scaledImage = UIGraphicsGetImageFromCurrentImageContext();
             
             UIGraphicsEndImageContext();
             [[AppManager sharedInstance] uploadImage:scaledImage withCompletitionBlock:^(BOOL succeeded, NSError *error) {
                 dispatch_async(dispatch_get_main_queue(), ^{
                     WBSuccessNoticeView *success = [WBSuccessNoticeView successNoticeInView:self.view title:@"Image uploaded!"];
                     [success show];
                 });
             }];
                 NSDictionary* attachments = (__bridge_transfer NSDictionary*) CMCopyDictionaryOfAttachments(kCFAllocatorDefault, imageDataSampleBuffer, kCMAttachmentMode_ShouldPropagate);
                 writeJPEGDataToCameraRoll(jpegData, attachments);
                 
            }
         // We used KVO in the main StacheCamViewController to freeze the preview when a still image was captured.
         // Now we are ready to take another image, unfreeze the preview
         dispatch_async(dispatch_get_main_queue(), ^(void) {
             [self unfreezePreview];
         });
     }];
}




/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


- (BOOL)prefersStatusBarHidden
{
    return YES;
}

@end
