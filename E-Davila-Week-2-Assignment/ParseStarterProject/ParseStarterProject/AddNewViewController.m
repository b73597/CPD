//
//  AddNewViewController.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import "AddNewViewController.h"
#import <Parse/Parse.h>

@implementation AddNewViewController
-(IBAction)save:(id)sender
{
    PFObject* detail = [PFObject objectWithClassName:@"Details"];
    [detail setValue:self.inputName.text forKey:@"name"];
    [detail setValue:self.inputEmail.text forKey:@"email"];
    [detail setValue:[NSNumber numberWithLongLong:[self.inputPhone.text longLongValue]] forKey:@"phone"];
    [detail saveInBackgroundWithBlock:^(BOOL success, NSError* error){
        if(success){
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error saving data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
        }
    }];
}
@end
