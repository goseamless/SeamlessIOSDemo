//
//  SDBannerAutoLayoutViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 02/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDBannerAutoLayoutViewController.h"
#import <Seamless/Seamless.h>

@interface SDBannerAutoLayoutViewController ()

@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (nonatomic, strong) SLAdView * adView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightConstraint;

@end

@implementation SDBannerAutoLayoutViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://goseamless.com"]];
    [self.webView loadRequest:request];
    
    self.heightConstraint.constant = [[UIScreen mainScreen]bounds].size.height-20;
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
                                            adSize:SLAdSizeMMA
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
        frame.origin.x = (self.view.frame.size.width - SLAdSizeMMA.width)/2;
        frame.origin.y = self.view.frame.size.height - SLAdSizeMMA.height;
        self.adView.frame = frame;
        
        self.heightConstraint.constant = self.view.frame.size.height - SLAdSizeMMA.height - 20;
    }else{
        self.heightConstraint.constant = self.view.frame.size.height-20;
    }
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
        
    CGRect frame = self.adView.frame;
    frame.origin.x = (self.view.frame.size.width - SLAdSizeMMA.width)/2;
    frame.origin.y = self.view.frame.size.height - SLAdSizeMMA.height;
    self.adView.frame = frame;
    [self.view addSubview:self.adView];
    
    // Adjust the frame of the superview if needed.
    self.heightConstraint.constant = self.view.frame.size.height - SLAdSizeMMA.height - 20;
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    if ([self.view.subviews containsObject:self.adView]) {
        [self.adView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        self.heightConstraint.constant = self.view.frame.size.height;
    }
}

@end
