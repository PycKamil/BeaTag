//
//  PhotoGalleryViewController.h
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MWPhotoBrowser/MWPhotoBrowser.h>

@protocol PhotoGalleryFiltering <NSObject>

-(void)filterPhotos:(BOOL)filter;

@end

@interface PhotoGalleryViewController : MWPhotoBrowser

@property (nonatomic, weak) id <MWPhotoBrowserDelegate,PhotoGalleryFiltering> delegate;

@end
