//
//  AppDelegate.m
//  BeaTag
//
//  Created by Kamil Pyć on 10/10/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import <ParseFacebookUtils/PFFacebookUtils.h>
#import "AppManager.h"

@interface AppDelegate ()
{
    AppManager *appManager;
}
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [Parse setApplicationId:@"OZIPO1RjXP16EK2Q1Rl0nQGSfhM05rmBpzW60dAL"
                  clientKey:@"zH4PBf3VSNuvPpp7gvZ199pNdVDmKvUtBuuwTbbd"];
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    [PFFacebookUtils initializeFacebook];
    [[UITextField appearance] setTintColor:[UIColor whiteColor]];

    [AppManager sharedInstance];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:[PFFacebookUtils session]];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    [FBAppCall handleDidBecomeActiveWithSession:[PFFacebookUtils session]];
}

@end
