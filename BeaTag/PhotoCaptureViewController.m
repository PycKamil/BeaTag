//
//  PhotoCaptureViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "PhotoCaptureViewController.h"

static char * const AVCaptureStillImageIsCapturingStillImageContext = "AVCaptureStillImageIsCapturingStillImageContext";


@interface PhotoCaptureViewController ()
@property (strong, nonatomic) AVCaptureSession* session;
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (strong, nonatomic) AVCaptureStillImageOutput *stillImageOutput;
@property (strong, nonatomic) IBOutlet UIView *previewView;

@end

@implementation PhotoCaptureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupAVCapture];
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
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspect];
    [self.previewLayer setFrame:[rootLayer bounds]];
    [rootLayer addSublayer:self.previewLayer];
    
    // this will allow us to sync freezing the preview when the image is being captured
    [self.stillImageOutput addObserver:self forKeyPath:@"capturingStillImage" options:NSKeyValueObservingOptionNew context:AVCaptureStillImageIsCapturingStillImageContext];
    
    [self.session startRunning];
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
