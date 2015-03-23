//
//  SDResizeForBannerViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDResizeForBannerViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"
#import "UIView+Toast.h"

@interface SDResizeForBannerViewController () <UIWebViewDelegate>

@property (nonatomic, strong) SLAdView * adView;
@property (strong, nonatomic) UIWebView *webView;
@property (strong, nonatomic) UIBarButtonItem *load;
@property (nonatomic, assign) CGSize adSize;

@end

@implementation SDResizeForBannerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // iphone's banner size is MMA (320x50), ipad's banner is LB (728x90)
    if (iPhone) {
        self.adSize = SLAdSizeMMA;
    }else{
        self.adSize = SLAdSizeLeaderboard;
    }
    
    // initialize webview
    self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20)];
    self.webView.delegate = self;
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    [self.webView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:self.webView];
    
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://goseamless.com"]];
    [self.webView loadRequest:request];
    
    [self requestBannerAd];
    
    // setup bar button
    self.load = [[UIBarButtonItem alloc] initWithTitle:@"Unload" style:UIBarButtonItemStyleBordered target:self action:@selector(bannerSwitch)];
    [self.load setTintColor:[UIColor blueColor]];
    
    [self setToolbarItems:@[self.load] animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    
    UIDevice *device = [UIDevice currentDevice];
    [device beginGeneratingDeviceOrientationNotifications];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientationChanged) name:UIDeviceOrientationDidChangeNotification object:device];
}

-(void)bannerSwitch
{
    if ([self.load.title isEqualToString:@"Unload"]) {
        [self.load setTitle:@"Load"];
        [self removeBannerAd];
    }else{
        [self.load setTitle:@"Unload"];
        [self requestBannerAd];
    }
}

-(void)removeBannerAd
{
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        [self.webView setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20- self.navigationController.toolbar.frame.size.height)];
    }
}

-(void)requestBannerAd
{
    self.adView = [[SLAdView alloc] initWithEntity:@"resize-banner"
                                          category:SLCategoryNews
                                            adSize:self.adSize
                                rootViewController:self];
    self.adView.delegate = self;
    [self.adView loadAd];
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
        frame.origin.y = self.view.frame.size.height - self.adSize.height - self.navigationController.toolbar.frame.size.height;
        self.adView.frame = frame;
       
        [self.webView setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20- self.adSize.height - self.navigationController.navigationBar.frame.size.height)];
        UIEdgeInsets insets = self.webView.scrollView.contentInset;
        [self.webView.scrollView setContentInset:UIEdgeInsetsMake(insets.top, 0, 0, 0)];
  
    }else{
        [self.webView setFrame:CGRectMake(0, 20, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-20)];
    }
    
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
    // adView can be in any size, MMA, LB or MRE
    
    if ([self.load.title isEqualToString:@"Unload"]) {
        
        CGRect frame = self.adView.frame;
        frame.origin.x = (self.view.frame.size.width - adView.frame.size.width)/2;
        frame.origin.y = self.view.frame.size.height - adView.frame.size.height - self.navigationController.toolbar.frame.size.height;
        self.adView.frame = frame;
        [self.view addSubview:self.adView];
        
        // Adjust the frame of the superview if needed.
        [self.webView setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20- adView.frame.size.height - self.navigationController.navigationBar.frame.size.height)];
        UIEdgeInsets insets = self.webView.scrollView.contentInset;
        [self.webView.scrollView setContentInset:UIEdgeInsetsMake(insets.top, 0, 0, 0)];

    }
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    [[Toast toast] makeToast:@"Banner Failed to Load"];
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        [self.webView setFrame:CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20)];
    }
}

@end
