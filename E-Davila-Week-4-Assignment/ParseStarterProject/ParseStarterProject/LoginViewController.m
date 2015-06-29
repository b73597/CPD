//
//  LoginViewController.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@implementation LoginViewController
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem =
    [[UIBarButtonItem alloc] initWithTitle:@"Log out"
                                      style:UIBarButtonItemStyleBordered
                                     target:nil
                                     action:nil];
}
-(void)viewDidAppear:(BOOL)animated
{
    [[NetworkStatusHelper sharedHelper] startUpdating];
    [super viewDidAppear:animated];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if(![[NetworkStatusHelper sharedHelper] ensureNetworking:YES]) return;
        if([PFUser currentUser]){
            [self performSegueWithIdentifier:@"gotoDashBoard" sender:self];
        }
    });
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetworkStatusHelper sharedHelper] stopUpdating];
}

-(IBAction)loginPressed:(id)sender
{
    if(![[NetworkStatusHelper sharedHelper] ensureNetworking:YES]) return;
    NSString* uname = self.inputUsername.text;
    NSString* pass  = self.inputPassword.text;
    [PFUser logInWithUsernameInBackground:uname password:pass
        block:^(PFUser* user, NSError* err){
            if(user){
                //success, user exists, logged in
                [self performSegueWithIdentifier:@"gotoDashBoard" sender:self];
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Invalid username or password" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    [alert show];
                    }
            }];
}

-(IBAction)signUpPressed:(id)sender
{
    if(![[NetworkStatusHelper sharedHelper] ensureNetworking:YES]) return;
    NSString* uname = self.inputUsername.text;
    NSString* pass  = self.inputPassword.text;
    //nope, try to create user
    PFUser* user = [[PFUser alloc] init];
        user.username = uname;
        user.password = pass;
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError* error){
            if(!error){
            //success, registered, logged in now
            [self performSegueWithIdentifier:@"gotoDashBoard" sender:self];
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error registering account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
            }
        }];
    
}




@end
