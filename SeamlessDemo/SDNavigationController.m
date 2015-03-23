//
//  SDNavigationController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 09/02/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDNavigationController.h"

@interface SDNavigationController ()

@end

@implementation SDNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)shouldAutorotate
{
    return YES;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskAll;
}

@end
