//
//  AddNewViewController.h
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddNewViewController : UIViewController

@property (nonatomic) NSString* objectID;
@property (nonatomic) NSString* startInputName;
@property (nonatomic) NSString* startInputEmail;
@property (nonatomic) NSString* startInputPhone;

@property (retain,nonatomic) IBOutlet UITextField* inputName;
@property (retain,nonatomic) IBOutlet UITextField* inputEmail;
@property (retain,nonatomic) IBOutlet UITextField* inputPhone;

@end
