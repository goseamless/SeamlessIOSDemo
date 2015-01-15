//
//  SDVideoViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 15/01/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDVideoViewController.h"
#import <Seamless/Seamless.h>

@interface SDVideoViewController ()

@end

@implementation SDVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ford" withExtension:@"mp4"];
    NSString *entity = @"video-in-custom-view";
    
    [[SLPlayerManager sharedManager] addPlayerToView:self.view url:url entity:entity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
