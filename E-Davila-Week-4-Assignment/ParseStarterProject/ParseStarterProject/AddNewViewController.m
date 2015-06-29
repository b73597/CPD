//
//  AddNewViewController.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import "AddNewViewController.h"
#import <Parse/Parse.h>

@implementation NSString (Validation)
-(BOOL)isValidEmail
{
    NSString *emailRegex = @"^[a-z0-9!#$%&'*+/=?^_`\\{|\\}~-]+(?:\\.[a-z0-9!#$%&'*+/=?^_`\\{|\\}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
-(BOOL)isValidPhone
{
    NSString *phoneRegex = @"^[0-9]{10}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phoneTest evaluateWithObject:self];
}
@end

@implementation AddNewViewController

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NetworkStatusHelper sharedHelper] stopUpdating];
}

-(BOOL)logoutIfNoNetwork
{
    if(![[NetworkStatusHelper sharedHelper] ensureNetworking:NO]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return YES;
    }
    return NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[NetworkStatusHelper sharedHelper] startUpdating];
    if(self.startInputName!=nil){
        self.inputName.text = self.startInputName;
        self.startInputName = nil;
    }
    if(self.startInputEmail!=nil){
        self.inputEmail.text = self.startInputEmail;
        self.startInputEmail = nil;
    }
    if(self.startInputPhone!=nil){
        self.inputPhone.text = self.startInputPhone;
        self.startInputPhone = nil;
    }
    [self logoutIfNoNetwork];
}


-(BOOL)validateInput
{
    if(self.inputName.text.length<1){
        [[[UIAlertView alloc] initWithTitle:@"Input Error"
                                    message:@"Invalid name."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    if(![self.inputEmail.text isValidEmail]){
        [[[UIAlertView alloc] initWithTitle:@"Input Error"
                                    message:@"Invalid email."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    if(![self.inputPhone.text isValidPhone]){
        [[[UIAlertView alloc] initWithTitle:@"Input Error"
                                    message:@"Invalid phone number."
                                   delegate:nil
                          cancelButtonTitle:@"OK"
                          otherButtonTitles:nil] show];
        return NO;
    }
    return YES;
}


-(IBAction)save:(id)sender
{
    if([self logoutIfNoNetwork]) return;
    if(![self validateInput])
        return;
    PFObject* detail;
    if(self.objectID==nil) detail = [PFObject objectWithClassName:@"Details"];
    else detail = [PFObject objectWithoutDataWithClassName:@"Details" objectId:self.objectID];
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
