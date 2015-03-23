//
//  SDFloatingViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 13/11/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDFloatingViewController.h"
#import "UIView+Toast.h"

@interface SDFloatingViewController ()
@property (nonatomic, strong) SLInterstitialAdManager * interstitialAdManager;
@property (nonatomic, strong) UIBarButtonItem * orientation;
@property (nonatomic, assign) BOOL isPortrait;
@end

@implementation SDFloatingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
        
    UIBarButtonItem * load = [[UIBarButtonItem alloc] initWithTitle:@"Load Now" style:UIBarButtonItemStyleBordered target:self action:@selector(requestInterstitialAd)];
    [load setTintColor:[UIColor blueColor]];
    
    self.isPortrait = YES;
    self.orientation = [[UIBarButtonItem alloc] initWithTitle:@"Landscape" style:UIBarButtonItemStyleBordered target:self action:@selector(changeInterstitialOrientation)];
    [self.orientation setTintColor:[UIColor blueColor]];
    
    [self setToolbarItems:@[load, self.orientation] animated:YES];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:YES];
    self.interstitialAdManager.delegate = nil;
}

-(void)changeInterstitialOrientation
{
    self.isPortrait = !self.isPortrait;
    if (self.isPortrait) {
        [self.orientation setTitle:@"Landscape"];
    }else{
        [self.orientation setTitle:@"Portrait"];
    }
}

-(void)requestInterstitialAd
{
    self.interstitialAdManager = [[SLInterstitialAdManager alloc] initWithEntity:@"floating-interstitial" category:SLCategoryNews];
    
    self.interstitialAdManager.delegate = self;
    
    if (self.isPortrait) {  // floating-interstitial-portrait
        self.interstitialAdManager.landscapeModeEnabled = NO;
    }else{
        self.interstitialAdManager.landscapeModeEnabled = YES;
    }
    [self.interstitialAdManager loadAd];
}

#pragma mark - interstitial ad delegate

- (void)interstitialDidLoad:(MPInterstitialAdController *)interstitial{
    [interstitial showFromViewController:self];
}

-(void)interstitialDidFailToLoad:(MPInterstitialAdController *)interstitial{
    [[Toast toast] makeToast:@"Interstitial Failed"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
