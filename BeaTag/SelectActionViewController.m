//
//  SelectActionViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//


#import "SelectActionViewController.h"
#import "PhotoGalleryViewController.h"

@interface SelectActionViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *photos;

@end

@implementation SelectActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.photos  = @[[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3629/3339128908_7aecabc34b.jpg"]],[MWPhoto photoWithURL:[NSURL URLWithString:@"http://farm4.static.flickr.com/3590/3329114220_5fbc5bc92b.jpg"]] ];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSString *const gallerySegue = @"gallerySegue";
    if ([segue.identifier isEqualToString:gallerySegue]) {
        PhotoGalleryViewController *galleryVC = (PhotoGalleryViewController *)segue.destinationViewController;
        galleryVC.displayNavArrows = YES;
        galleryVC.enableGrid = YES;
        galleryVC.delegate = self;
        galleryVC.startOnGrid = YES;
    }
}


-(IBAction)backFromCamera:(UIStoryboardSegue *)sender { }

-(NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    return self.photos [index];
}

-(id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index
{
    return self.photos [index];
}


@end
