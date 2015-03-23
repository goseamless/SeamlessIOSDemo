//
//  SDBannerAutoLayoutViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 02/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDBannerAutoLayoutViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"
#import "UIView+Toast.h"

@interface SDBannerAutoLayoutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) SLAdView * adView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation SDBannerAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iphone's banner size is MMA (320x50), ipad's banner is LB (728x90)
    if (iPhone) {
        self.adSize = SLAdSizeMMA;
    }else{
        self.adSize = SLAdSizeLeaderboard;
    }
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://goseamless.com"]];
    [self.webView loadRequest:request];
    
    
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    
    [self requestBannerAd];
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
}

-(void)requestBannerAd
{
    self.adView = [[SLAdView alloc] initWithEntity:@"autolayout-banner"
                                          category:SLCategoryNews
                                            adSize:self.adSize
                                rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.heightConstraint.constant = self.view.bounds.size.height-20;
}

-(BOOL)prefersStatusBarHidden
{
    return NO;
}

-(void)orientationChanged
{
    if ([self.view.subviews containsObject:self.adView]) {
        
        CGRect frame = self.adView.frame;
        frame.origin.x = (self.view.frame.size.width - self.adSize.width)/2;
        frame.origin.y = self.view.frame.size.height - self.adSize.height;
        self.adView.frame = frame;
        
        self.heightConstraint.constant = self.view.frame.size.height - self.adSize.height - 20;
    }else{
        self.heightConstraint.constant = self.view.frame.size.height - 20;
    }
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
    // adView can be in any size, MMA, LB or MRE
        
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - adView.frame.size.width)/2;
    frame.origin.y = self.view.frame.size.height - adView.frame.size.height;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    
    // Adjust the frame of the superview if needed.
    self.heightConstraint.constant = self.view.frame.size.height - adView.frame.size.height - 20;
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    [[Toast toast] makeToast:@"Banner Failed to Load"];
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        self.heightConstraint.constant = self.view.frame.size.height - 20;
    }
}

@end
