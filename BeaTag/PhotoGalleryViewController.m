//
//  PhotoGalleryViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "PhotoGalleryViewController.h"
#import <MWPhotoBrowser/MWPhotoBrowserPrivate.h>
#import "AppManager.h"

@interface PhotoGalleryViewController ()

@property (nonatomic, assign) BOOL filteredMode;

@end

@implementation PhotoGalleryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = [NSString stringWithFormat:@"%@ Gallery",[[[AppManager sharedInstance] selectedEvent] name] ];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch target:self action:@selector(filterPhotos)];
    
}

-(void)reloadData
{
    [super reloadData];
    [[[self valueForKey:@"_gridController"]collectionView] reloadData ];

    [self performLayout];
    [self.view setNeedsLayout];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self performLayout];
    [self.view setNeedsLayout];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)filterPhotos
{
    self.filteredMode =! self.filteredMode;
    
    if (self.filteredMode) {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor greenColor];
        self.navigationController.navigationBar.tintColor = [UIColor greenColor];
    } else {
        self.navigationItem.rightBarButtonItem.tintColor = [UIColor whiteColor];
        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    }
    [self.delegate filterPhotos:self.filteredMode];
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
