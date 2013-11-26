//
//  WifiBase.m
//  WifiBase
//
//  Created by silentcloud on 11/24/13.
//  Copyright (c) 2013 silentcloud. All rights reserved.
//

#import "WifiBase.h"
#import "Reachability.h"
#import <SystemConfiguration/CaptiveNetwork.h>

@implementation WifiBase

+(WifiBase *)sharedInstance
{
    static WifiBase *_sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _sharedInstance = [[WifiBase alloc] init];
    });
    return _sharedInstance;
}

- (BOOL)isConnectWifi{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    [reachability startNotifier];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    BOOL connectStatus;
    
    switch (status) {
        case NotReachable:
            NSLog(@"No internet connected!");
            connectStatus =  NO;
            break;
        case ReachableViaWiFi:
            NSLog(@"Current connect is WIFI");
            connectStatus = YES;
            break;
        case ReachableViaWWAN:
            NSLog(@"Current connect is WWAN");
            connectStatus = NO;
            break;
        default:
            break;
    }
    
    return connectStatus;
}

- (NSString *)getBSSID
{
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSString *bssid = [[ifs objectForKey:@"BSSID"] uppercaseString];
    NSString *bssidValue;
    if([bssid isEqualToString:@"UNSUPPORTED"]){
        NSLog(@"Simulator doesn't detect wifi, please connect your iPhone!");
        bssidValue = @"";
    }else{
        //第一位为0的时候会被省略掉
        //封装第一位为0的情况
        NSArray *array=[bssid componentsSeparatedByString:@":"];
        NSMutableArray *tempArray = [[NSMutableArray alloc]init];
        for(int i = 0; i < [array count]; i++){
            if([array[i] length]== 1){
                [tempArray addObject:[@"0" stringByAppendingString:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]]]];
                
            }else{
                [tempArray addObject:[NSString stringWithFormat:@"%@", [array objectAtIndex:i]]];
            }
        }
        bssidValue = [tempArray componentsJoinedByString:@":"];
    }
    return bssidValue;
}

- (NSString *)getSSID
{
    NSDictionary *ifs = [self fetchSSIDInfo];
    NSString *ssid = [ifs objectForKey:@"SSID"];
    NSString *ssidValue;
    if([[ssid uppercaseString] isEqualToString:@"UNSUPPORTED"]){
        NSLog(@"Simulator doesn't detect wifi, please connect your iPhone!");
        ssidValue = @"";
    }else{
        ssidValue = ssid;
    }
    
    return ssidValue;
}

- (id)fetchSSIDInfo
{    
    NSArray *ifs = (__bridge id)CNCopySupportedInterfaces();
    NSLog(@"Supported interfaces: %@", ifs);
    NSDictionary *info;
    if (!ifs) {
        info = [NSDictionary dictionaryWithObjectsAndKeys:
                    @"UNSUPPORTED", @"SSID",
                    @"UNSUPPORTED", @"BSSID", nil];
    } else{
        for (NSString *ifnam in ifs) {
            info = (__bridge_transfer id)CNCopyCurrentNetworkInfo((__bridge CFStringRef)ifnam);
            NSLog(@"%@ => %@", ifnam, info);
            if (info && [info count]) { break; }
        }
    }
    return info;
}

@end
