//
//  SDBannerViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDBannerViewController.h"
#import <Seamless/Seamless.h>

@interface SDBannerViewController ()

@property (nonatomic, strong) SLAdView * adView;

@end

@implementation SDBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 100.0, 320.0, 40.0)];
    [label setText:@"Rotate the device"];
    [self.view addSubview:label];
    
    [self requestBannerAd];
    
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
    
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)requestBannerAd
{
    self.adView = [[SLAdView alloc] initWithEntity:@"floating-banner"
                                          category:SLCategoryNews
                                            adSize:SLAdSizeMMA
                                rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
}

-(void)orientationChanged
{
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - SLAdSizeMMA.width)/2;
    frame.origin.y = self.view.frame.size.height - SLAdSizeMMA.height - self.navigationController.toolbar.frame.size.height;
    self.adView.frame = frame;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
        
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - SLAdSizeMMA.width)/2;
    frame.origin.y = self.view.frame.size.height - SLAdSizeMMA.height - self.navigationController.toolbar.frame.size.height;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    
    // Adjust the frame of the superview if needed.
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
    }
}

@end
