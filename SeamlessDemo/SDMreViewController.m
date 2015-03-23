//
//  SDMreViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDMreViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"
#import "UIView+Toast.h"

@interface SDMreViewController ()

@property (nonatomic, strong) SLAdView * mreView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SDMreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.webView.scrollView setContentInset:UIEdgeInsetsMake(-20, 0, 0, 0)];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://google.com"]];
    [self.webView loadRequest:request];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    gesture.numberOfTouchesRequired = 1;
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gesture];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)dismissView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - webview delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    self.mreView = [[SLAdView alloc] initWithEntity:@"floating-mre-scroll"
                                           category:SLCategoryNews
                                             adSize:SLAdSizeMRect
                                 rootViewController:self];
    self.mreView.delegate = self;
    [self.mreView loadAd];
}

#pragma mark - banner ad delegate

-(void)adViewDidLoad:(SLAdView*)adView{
    // ad load success
    // adView can be in any size, MMA, LB or MRE
    
    [[Toast toast] makeToast:@"MRE loaded"];
    
    if (![self.webView.scrollView.subviews containsObject:self.mreView])
    {
        CGRect frame = self.mreView.frame;
        frame.origin.x = (self.view.frame.size.width - SLAdSizeMRect.width)/2;
        frame.origin.y = self.webView.scrollView.contentSize.height;
        self.mreView.frame = frame;
        [self.webView.scrollView addSubview:self.mreView];
        
        // Adjust the frame of the superview if needed.
        CGSize newSize = CGSizeMake(self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height + self.mreView.frame.size.height);
        [self.webView.scrollView setContentSize:newSize];
    }else{
        [self.webView.scrollView addSubview:self.mreView];
    }
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    [[Toast toast] makeToast:@"MRE failed to load"];
    
    if ([self.view.subviews containsObject:self.mreView]) {
        [self.mreView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        CGSize newSize = CGSizeMake(self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height - self.mreView.frame.size.height);
        self.webView.scrollView.contentSize = newSize;
    }
}


@end
