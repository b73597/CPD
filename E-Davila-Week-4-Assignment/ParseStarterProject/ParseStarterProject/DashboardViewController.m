//
//  DashboardViewController.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/8/15.
//  Copyright (c) 2015 Omar Davila. All rights reserved.
//

#import "DashboardViewController.h"
#import "AddNewViewController.h"
#import <Parse/Parse.h>

@interface DashboardViewController()
@property (strong,nonatomic) NSTimer* updatingTimer;
@property (strong,atomic) NSMutableArray* details;
@property (strong,atomic) PFQuery* current_query;
@end

@interface CRUDObject: NSObject
@property(atomic) NSString* objectID;
@property(atomic) NSString* name;
@property(atomic) NSString* email;
@property(atomic) NSString* phone;
@property(atomic) NSDate* lastUpdateTime;
@end

@implementation CRUDObject
-(id)initWithPFObject: (PFObject*)obj
{
    if(self = [super init]){
        self.objectID = obj.objectId;
        self.lastUpdateTime = obj.updatedAt;
        self.name = [obj valueForKey:@"name"];
        self.email = [obj valueForKey:@"email"];
        self.phone = [NSString stringWithFormat:@"%@",[obj valueForKey:@"phone"]];
    }
    return self;
}

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
    [self.updatingTimer invalidate];
    [[NetworkStatusHelper sharedHelper] stopUpdating];
}

-(void)viewWillAppear:(BOOL)animated
{
    [[NetworkStatusHelper sharedHelper] startUpdating];
    [super viewWillAppear:animated];
    [self reloadTable];
}

-(BOOL)logoutIfNoNetwork
{
    if(![[NetworkStatusHelper sharedHelper] ensureNetworking:NO]){
        [self.navigationController popToRootViewControllerAnimated:YES];
        return YES;
    }
    return NO;
}


-(void)reloadTable
{
    [self.updatingTimer invalidate];
    [self logoutIfNoNetwork];
    if([[NetworkStatusHelper sharedHelper] ensureNetworking:NO]){
        if(self.current_query){
            [self.current_query cancel];
        }
        self.title = @"Loading...";
        self.current_query = [PFQuery queryWithClassName:@"Details"];
        [[self.current_query orderByAscending:@"name"] findObjectsInBackgroundWithBlock:^(NSArray* objects,NSError* error){
            self.title = @"Details";
            if(!error){
                BOOL shouldUpdate = NO;
                if(self.details.count!=objects.count) shouldUpdate = YES;
                else{
                    for(int i=0;!shouldUpdate && i<self.details.count;i++){
                        PFObject* row_pf = [objects objectAtIndex:i];
                        CRUDObject* row_cr = [self.details objectAtIndex:i];
                        shouldUpdate = [row_pf.objectId compare:row_cr.objectID]!=NSOrderedSame || [row_pf.updatedAt compare:row_cr.lastUpdateTime]>0;
                    }
                }
                if(shouldUpdate){
                    self.details = [[NSMutableArray alloc] init];
                    for(PFObject* obj in objects){
                        [self.details addObject:[[CRUDObject alloc] initWithPFObject:obj]];
                    }
                    [self.tableView reloadData];
                }
            }
        }];
    }
    //update again after 10 seconds
    self.updatingTimer = [NSTimer scheduledTimerWithTimeInterval:10 target:self selector:@selector(reloadTable) userInfo:nil repeats:NO];
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
        if(![[NetworkStatusHelper sharedHelper] ensureNetworking:YES]) return;
        PFObject* row = [PFObject objectWithoutDataWithClassName:@"Details" objectId:((CRUDObject*)[self.details objectAtIndex:indexPath.row]).objectID];
        [row deleteInBackground];
        [tableView beginUpdates];
        [self.details removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        [tableView endUpdates];
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(![[NetworkStatusHelper sharedHelper] ensureNetworking:YES]) return;
    [self performSegueWithIdentifier:@"new_record" sender:[self.details objectAtIndex:indexPath.row]];
}


#pragma mark segue

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    AddNewViewController* targetVC = segue.destinationViewController;
    if([sender isKindOfClass:[UIBarButtonItem class]]){
        //it's New button
        targetVC.objectID = nil;
        targetVC.startInputName = @"";
        targetVC.startInputEmail = @"";
        targetVC.startInputPhone = @"";
    }else if([sender isKindOfClass:[CRUDObject class]]){
        //
        CRUDObject* obj = (CRUDObject*)sender;
        targetVC.objectID = obj.objectID;
        targetVC.startInputName = obj.name;
        targetVC.startInputEmail = obj.email;
        targetVC.startInputPhone = obj.phone;
    }
}

@end
