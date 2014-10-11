//
//  PhotoCaptureViewController.h
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface PhotoCaptureViewController : UIViewController

@property (strong, nonatomic, readonly) AVCaptureSession* session;
@property (strong, nonatomic, readonly) AVCaptureVideoPreviewLayer* previewLayer;
@property (weak, nonatomic) IBOutlet UILabel *peopleCounter;

- (IBAction)takePicture:(id)sender; // grabs a still image and applies the most recent metadata

@end
