//
//  NetworkStatusHelper.h
//  ParseStarterProject
//
//  Created by Omar Davila on 6/28/15.
//
//

#import <Foundation/Foundation.h>

@interface NetworkStatusHelper : NSObject

@property(nonatomic) BOOL isConnected;

+(NetworkStatusHelper*)sharedHelper;

-(void)startUpdating;
-(void)stopUpdating;

-(BOOL)ensureNetworking:(BOOL)notify;

@end
