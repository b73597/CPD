//
//  DashboardViewController.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import "DashboardViewController.h"
#import <Parse/Parse.h>

@interface DashboardViewController()
@property (strong,atomic) NSMutableArray* details;
@property (strong,atomic) PFQuery* current_query;
@end

@implementation DashboardViewController

-(void)viewWillDisappear:(BOOL)animated
{
    if([self.navigationController.viewControllers indexOfObject:self]==NSNotFound){
        //this view controller isnt in navigationController anymore,
        // so this viewcontroller is disappearing due to back action
        [PFUser logOut];
    }
    [super viewWillDisappear:animated];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self reloadTable];
}

-(void)reloadTable
{
    if(self.current_query){
        [self.current_query cancel];
    }
    self.title = @"Loading...";
    self.current_query = [PFQuery queryWithClassName:@"Details"];
    [[self.current_query orderByAscending:@"name"] findObjectsInBackgroundWithBlock:^(NSArray* objects,NSError* error){
        self.title = @"Details";
        if(!error){
            self.details = [NSMutableArray arrayWithArray:objects];
            [self.tableView reloadData];
        }
    }];
}

#pragma mark UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.details.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(cell==nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    PFObject* row = [self.details objectAtIndex:indexPath.row];
    [((UILabel*)[cell viewWithTag:100]) setText:[row valueForKey:@"name"]];
    [((UILabel*)[cell viewWithTag:101]) setText:[row valueForKey:@"email"]];
    [((UILabel*)[cell viewWithTag:102]) setText:[NSString stringWithFormat:@"%@",[row valueForKey:@"phone"]]];
    return cell;
}

#pragma mark UITableViewDelegate
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(editingStyle == UITableViewCellEditingStyleDelete){
        PFObject* row = [self.details objectAtIndex:indexPath.row];
        [row deleteInBackground];
        [tableView beginUpdates];
        [self.details removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

@end
