//
//  SDPortraitOnlyNavController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 10/02/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDPortraitOnlyNavController.h"

@interface SDPortraitOnlyNavController ()

@end

@implementation SDPortraitOnlyNavController

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
    return UIInterfaceOrientationMaskPortrait;
}

@end
