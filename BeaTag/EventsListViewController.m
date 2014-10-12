//
//  ViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "EventsListViewController.h"
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "Event.h"
#import "EventTableViewCell.h"
#import "AppManager.h"
#import "ErrorHelper.h"
#import "Beacon.h"

@interface EventsListViewController ()

@property (nonatomic, strong) NSArray *events;

@end

@implementation EventsListViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loginUser];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.refreshControl beginRefreshing];
    [self refreshRequested:self.refreshControl];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *const cellID = @"eventCell";
    
    EventTableViewCell *eventCell = [tableView dequeueReusableCellWithIdentifier:cellID];
    
    Event *event = [[Event alloc]initWithParseObject:self.events[indexPath.row]];

    eventCell.titleLabel.text = event.name;
    eventCell.subTitleLabel.text = event.dateString;
    eventCell.logoImageView.image = [UIImage imageNamed:event.photoAddress];
    
    return eventCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Event *event = [[Event alloc]initWithParseObject:self.events[indexPath.row]];
    AppManager *manager = [AppManager sharedInstance];
    
    if (!manager.selectedEvent) {
        [[AppManager sharedInstance] setSelectedEvent:event];

    }
    
    if (manager.selectedEvent == event && [AppManager sharedInstance].usersBeacon) {
        [self performSegueWithIdentifier:@"goToEventBoard" sender:tableView];
    } else {
        [[AppManager sharedInstance] setSelectedEvent:event];
        [AppManager sharedInstance].usersBeacon = nil;
        
        PFObjectResultBlock beaconFetchingCompletionBlock = ^(PFObject *object, NSError *error) {
            if (!error && object) {
                Beacon *beacon = [[Beacon alloc] initWithParseObject:object];
                [AppManager sharedInstance].usersBeacon = beacon;
                [self performSegueWithIdentifier:@"goToEventBoard" sender:self];

            } else {
                [self performSegueWithIdentifier:@"goToBeaconSelection" sender:self];

            }
            
        };
    
        PFArrayResultBlock fetchBeaconsForEventCompletionBlock = ^(NSArray *objects, NSError *error) {
            if (!error && objects && [objects count] > 0) {
                NSString *beaconId = [self retrieveBeaconIdFromPFObjectArray:objects];
                [Beacon findBeaconByObjectId:beaconId WithBlock:beaconFetchingCompletionBlock];
            } else {
                [self performSegueWithIdentifier:@"goToBeaconSelection" sender:self];
            }
            
        };
        
        [Beacon getBeaconForEvent:event AssignedToUser:[PFUser currentUser] WithBlock:fetchBeaconsForEventCompletionBlock];
    }
}


-(NSString *)retrieveBeaconIdFromPFObjectArray:(NSArray *)objects
{
    PFObject *object = [objects objectAtIndex:0][@"beacon"];
    return object.objectId;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

-(IBAction)refresh:(UIRefreshControl *)sender
{
    [AppManager sharedInstance].currentAppCachePolicy = kPFCachePolicyNetworkElseCache;
    [self refreshRequested:sender];
}

-(void)refreshRequested:(UIRefreshControl *)control
{
    [Event getListOfEventsWithBlock:^(NSArray *objects, NSError *error) {
        self.events = objects;
        if (error) {
            displayErrorOnMainQueue(error, @"Events download failed!");
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.tableView reloadData];
            
            [control endRefreshing];
        });
    }];
}

-(void)loginUser
{
    [PFFacebookUtils logInWithPermissions:@[@"email"] block:^(PFUser *user, NSError *error) {
        if (!user) {
            NSLog(@"Uh oh. The user cancelled the Facebook login.");
        } else if (user.isNew) {
            NSLog(@"User signed up and logged in through Facebook!");
        } else {
            NSLog(@"User logged in through Facebook!");
        }
        if (error) {
            displayErrorOnMainQueue(error, @"User login failed!");
        }
        
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backFromAddingEvent:(UIStoryboardSegue *)sender { }


@end
