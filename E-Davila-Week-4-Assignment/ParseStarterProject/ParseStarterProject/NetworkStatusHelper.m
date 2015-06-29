//
//  NetworkStatusHelper.m
//  ParseStarterProject
//
//  Created by Omar Davila on 6/28/15.
//
//

#import "NetworkStatusHelper.h"
#import "Reachability.h"


@interface NetworkStatusHelper()
{
    Reachability* internetReachable;
    int reqCount;
}
@end

static NetworkStatusHelper* inst = NULL;

@implementation NetworkStatusHelper

+(void)initialize
{
    inst = [[NetworkStatusHelper alloc] init];
}
+ (NetworkStatusHelper *)sharedHelper
{
    return inst;
}


-(instancetype)init
{
    if(self = [super init]){
        self.isConnected = NO;
        reqCount = 0;
    }
    return self;
}

-(void)startUpdating
{
    if(reqCount++==0){
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:) name:kReachabilityChangedNotification object:nil];
        
        internetReachable = [Reachability reachabilityForInternetConnection];
        [internetReachable startNotifier];
        [self checkNetworkStatus:nil];
    }
}

-(void)stopUpdating
{
    if(reqCount>0){
        if(--reqCount==0) [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

-(void) checkNetworkStatus:(NSNotification *)notice
{
    switch ([internetReachable currentReachabilityStatus]) {
        case NotReachable:
            self.isConnected = NO;
            break;
        case ReachableViaWiFi:
        case ReachableViaWWAN:
            self.isConnected = YES;
            break;
    }
}

-(BOOL)ensureNetworking: (BOOL)notify
{
    if(!self.isConnected){
        if(notify){
            [[[UIAlertView alloc] initWithTitle:@"No network connection"
                                        message:@"Please connect to internet!"
                                       delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil] show];
        }
        return NO;
    }
    return YES;
}

@end
