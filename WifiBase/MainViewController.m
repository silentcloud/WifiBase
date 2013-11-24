//
//  MainViewController.m
//  WifiBase
//
//  Created by silentcloud on 11/24/13.
//  Copyright (c) 2013 silentcloud. All rights reserved.
//

#import "MainViewController.h"
#import "WifiBase.h"

@interface MainViewController ()<UIAlertViewDelegate>

@property (nonatomic,strong) UILabel *bssidLabel;
@property (nonatomic,strong) UILabel *ssidLabel;

@end

@implementation MainViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    _bssidLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 40, 200, 40)];
    _bssidLabel.text = [[WifiBase sharedInstance] getBSSID];
    [self.view addSubview:_bssidLabel];
    
    _ssidLabel=[[UILabel alloc]initWithFrame:CGRectMake(50, 100, 200, 40)];
    _ssidLabel.text = [[WifiBase sharedInstance] getSSID];
    [self.view addSubview:_ssidLabel];
   
    if([[WifiBase sharedInstance] isConnectWifi]){
        NSLog(@"wifi");
    }else{
        NSLog(@"other");
    }
}


@end
