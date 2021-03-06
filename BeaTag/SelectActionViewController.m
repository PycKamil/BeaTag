//
//  SelectActionViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//


#import "SelectActionViewController.h"
#import "PhotoGalleryViewController.h"
#import "AppManager.h"
#import "Image.h"
#import "ErrorHelper.h"
#import <MBProgressHUD/MBProgressHUD.h>

@interface SelectActionViewController () <MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSArray *photos;
@property (nonatomic, weak) PhotoGalleryViewController *galleryVC;

@end

@implementation SelectActionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [[[AppManager sharedInstance] selectedEvent] name];
    // Do any additional setup after loading the view.
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self loadPhotos:NO];

}

-(void)loadPhotos:(BOOL)filtered
{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    PFArrayResultBlock completition = ^(NSArray *objects, NSError *error) {
        if (error) {
            displayErrorOnMainQueue(error, @"Loading photos failed!");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self processPhotos:objects];
            [self.galleryVC reloadData];
            [MBProgressHUD hideHUDForView:self.view animated:YES];
        });
    };
    if(filtered){
        [Image findImagesInEvent:[[[AppManager sharedInstance] selectedEvent] parseObject] ForBeacon:[[[AppManager sharedInstance] usersBeacon] parseObject] WithBlock:completition];
         } else {
        [Image findImagesInEvent:[[[AppManager sharedInstance] selectedEvent] parseObject] WithBlock:completition];
    }
    
    
}

-(void)processPhotos:(NSArray *)photos{
    NSMutableArray *photosArray = [NSMutableArray new];
    for (PFObject * pfobject in photos) {
        PFFile *file = [pfobject valueForKey:@"imageFile"];
        
        PFRelation *relation = [pfobject relationForKey:@"beacons"];
        PFQuery *query = [relation query];
        
        MWPhoto *photo = [MWPhoto photoWithURL:[NSURL URLWithString:file.url]];
        [[query findObjects] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            PFObject *beacon = obj;
            if([beacon[@"beaconId"] integerValue] == [[[[AppManager sharedInstance] usersBeacon] beaconId] integerValue])
            {
                photo.isUserOnIt = YES;
                *stop = YES;
            }
        }];
        [photosArray addObject:photo];
    }
    self.photos = [photosArray copy];
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
        self.galleryVC = (PhotoGalleryViewController *)segue.destinationViewController;
        self.galleryVC.displayNavArrows = YES;
        self.galleryVC.enableGrid = YES;
        self.galleryVC.delegate = self;
        self.galleryVC.startOnGrid = YES;
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

-(BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index
{
    return [self.photos [index] isUserOnIt];
}

-(void)filterPhotos:(BOOL)filter
{
    [self loadPhotos:filter];
}


@end
