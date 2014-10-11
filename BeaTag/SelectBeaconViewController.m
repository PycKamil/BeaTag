//
//  SelectBeaconViewController.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "SelectBeaconViewController.h"
#import "Beacon.h"
#import "AppManager.h"

@interface SelectBeaconViewController ()

@property (nonatomic, weak) IBOutlet UITextField *textField;

@end

@implementation SelectBeaconViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.textField becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)beaconSelectedPressed
{
    if (self.textField.text.length) {
        [Beacon findByBeaconId:@(self.textField.text.integerValue) WithBlock:^(NSArray *objects, NSError *error) {
            if (objects.count) {
                [AppManager sharedInstance].usersBeacon = [[Beacon alloc]initWithParseObject:objects.firstObject];
                [self performSegueWithIdentifier:@"actionSelection" sender:self];
            } else {
                [self performSelectorOnMainThread:@selector(showErrorMessage) withObject:NO waitUntilDone:NO];
            }
        }];
    } else {
        [self showErrorMessage];
    }
}

-(void)showErrorMessage
{
      [[[UIAlertView alloc]initWithTitle:@"Error" message:@"You need to select proper beacon id!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
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
