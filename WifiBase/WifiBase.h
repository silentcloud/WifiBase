//
//  WifiBase.h
//  WifiBase
//
//  Created by silentcloud on 11/24/13.
//  Copyright (c) 2013 silentcloud. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WifiBase : NSObject

+(WifiBase *)sharedInstance;

-(BOOL)isConnectWifi;

- (NSString *)getBSSID;

- (NSString *)getSSID;

@end
