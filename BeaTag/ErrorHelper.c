//
//  ErrorHelper.c
//  BeaTag
//
//  Created by Kamil Pyć on 10/11/14.
//  Copyright (c) 2014 Kamil Pyć. All rights reserved.
//

#include <stdio.h>
#import "ErrorHelper.h"

void displayErrorOnMainQueue(NSError *error, NSString *message)
{
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        UIAlertView* alert = [UIAlertView new];
        if(error) {
            alert.title = [NSString stringWithFormat:@"%@ (%zd)", message, error.code];
            alert.message = [error localizedDescription];
        } else {
            alert.title = message;
        }
        [alert addButtonWithTitle:@"Dismiss"];
        [alert show];
    });
}