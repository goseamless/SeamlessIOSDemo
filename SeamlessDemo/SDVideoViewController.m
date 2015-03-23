//
//  SDVideoViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 09/02/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDVideoViewController.h"
#import <Seamless/Seamless.h>

@interface SDVideoViewController ()

@end

@implementation SDVideoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)playVideo:(id)sender
{
    NSURL *url = [[NSBundle mainBundle] URLForResource:@"ford" withExtension:@"mp4"];
    NSString *entity = @"simple-modal-video";
    
    [[SLPlayerManager sharedManager] presentPlayerWithUrl:url entity:entity];
    
    // ****** Other examples ****** //
    
    /*
    // 1
    [[SLPlayerManager sharedManager] presentPlayerWithUrl:url entity:entity attachmentView:[SLDefaultVideoControllerView new] share:nil handler:nil];
    
    // 2
    [[SLPlayerManager sharedManager] presentPlayerWithUrl:url entity:entity attachmentView:[SLDefaultVideoControllerView new] shareText:nil shareUrls:nil shareImages:nil shareTitle:nil shareRecipientsMail:nil shareRecipientsSms:nil presentationHandler:^{
        NSLog(@"present video");
    } startHandler:^{
        NSLog(@"Video started");
    } progressHandler:nil finishHandler:nil errorHandler:^{
        [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
    }];
     */

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
