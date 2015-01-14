//
//  SDMreViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDMreViewController.h"
#import <Seamless/Seamless.h>

@interface SDMreViewController ()

@property (nonatomic, strong) SLAdView * mreView;
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation SDMreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://goseamless.com"]];
    [self.webView loadRequest:request];
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
    
    CGRect frame = self.mreView.frame;
    frame.origin.x = (self.view.frame.size.width - SLAdSizeMRect.width)/2;
    frame.origin.y = self.webView.scrollView.contentSize.height;
    self.mreView.frame = frame;
    [self.webView.scrollView addSubview:self.mreView];
    
    // Adjust the frame of the superview if needed.
    CGSize newSize = CGSizeMake(self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height + self.mreView.frame.size.height);
    [self.webView.scrollView setContentSize:newSize];
}

-(void)adViewDidFailToLoad:(SLAdView*)adView{
    // ad load failed
    if ([self.view.subviews containsObject:self.mreView]) {
        [self.mreView removeFromSuperview];
        
        // Adjust the frame of the superview if needed.
        CGSize newSize = CGSizeMake(self.webView.scrollView.contentSize.width, self.webView.scrollView.contentSize.height - self.mreView.frame.size.height);
        self.webView.scrollView.contentSize = newSize;
    }
}

@end
