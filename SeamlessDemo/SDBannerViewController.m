//
//  SDBannerViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDBannerViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"
#import "UIView+Toast.h"

@interface SDBannerViewController ()

@property (nonatomic, strong) SLAdView * adView;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation SDBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iphone's banner size is MMA (320x50), ipad's banner is LB (728x90)
    if (iPhone) {
        self.adSize = SLAdSizeMMA;
    }else{
        self.adSize = SLAdSizeLeaderboard;
    }
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(20.0, 100.0, 320.0, 40.0)];
    [label setText:@"Rotate the device"];
    [self.view addSubview:label];
    
    [self requestBannerAd];
    
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)requestBannerAd
{
    self.adView = [[SLAdView alloc] initWithEntity:@"floating-banner"
                                          category:SLCategoryNews
                                            adSize:self.adSize
                                rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
}

-(void)orientationChanged
{
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - self.adSize.width)/2;
    frame.origin.y = self.view.frame.size.height - self.adSize.height - self.navigationController.toolbar.frame.size.height;
    self.adView.frame = frame;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
    // adView can be in any size, MMA, LB or MRE
 
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - adView.frame.size.width)/2;
    frame.origin.y = self.view.frame.size.height - adView.frame.size.height - self.navigationController.toolbar.frame.size.height;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    
    // Adjust the frame of the superview if needed.
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    [[Toast toast] makeToast:@"Banner Failed to Load"];
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
    }
}

@end
