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
    [self refresh:self.refreshControl];
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
    [[AppManager sharedInstance] setSelectedEvent:event];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.events.count;
}

-(IBAction)refresh:(UIRefreshControl *)sender
{
    
    [Event getListOfEventsWithBlock:^(NSArray *objects, NSError *error) {
        self.events = objects;
       dispatch_async(dispatch_get_main_queue(), ^{
           
           [self.tableView reloadData];
           
           [sender endRefreshing];
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
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backFromAddingEvent:(UIStoryboardSegue *)sender { }


@end
