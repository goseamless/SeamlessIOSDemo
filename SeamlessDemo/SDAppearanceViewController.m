//
//  SDAppearanceViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 13/02/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDAppearanceViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"

@interface SDAppearanceViewController ()
@property (nonatomic, strong) SLCollectionViewAdManager * adManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SDAppearanceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    
    UISwipeGestureRecognizer *gesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(dismissView)];
    gesture.numberOfTouchesRequired = 1;
    gesture.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:gesture];
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:10];
    for (int i = 0; i < 10; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%i", i]];
    }
    [self requestSeamless];
}

-(void)requestSeamless
{
    self.adManager = [[SLCollectionViewAdManager alloc] initWithCollectionView:self.collectionView dataSource:self.dataSource viewController:self];
    
    [self.adManager getAdsWithEntity:@"feed-appearance" category:SLCategoryNews successBlock:^{
        NSLog(@"Ads loaded");
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    [self setSeamlessAppearance];
}

-(void)setSeamlessAppearance
{
    // container 107, 194, 230
    // header, button 26, 151, 208
    // footer 246 247 249     245 247 255
    SLAppearance *appearance = [[SLAppearance alloc] init];
    
    // Appearnace of MRE
    appearance.displayAdTopInset = 10.0;
    appearance.displayAdBottomInset = 10.0;
    
    // Appearance of MAIA
    appearance.maiaAdHeaderBackgroundColor = [UIColor colorWithRed:0.120 green:0.592 blue:0.816 alpha:1];
    appearance.maiaAdFooterBackgroundColor = [UIColor colorWithRed:0.961 green:0.969 blue:1.0 alpha:1];
    appearance.maiaAdBorderLineColor = [UIColor whiteColor];
    appearance.maiaAdBorderWidth = 5.0;
    appearance.maiaContainerTitleFont = [UIFont systemFontOfSize:15.0];
    appearance.maiaContainerTitleTextColor = [UIColor whiteColor];
    appearance.maiaAppNameFont = [UIFont systemFontOfSize:14.0];
    appearance.maiaAppNameTextColor = [UIColor whiteColor];
    appearance.maiaSponsorFont = [UIFont systemFontOfSize:11.0];
    appearance.maiaSponsorTextColor = [UIColor whiteColor];
    appearance.maiaDescriptionFont = [UIFont systemFontOfSize:14.0];
    appearance.maiaDescriptionTextColor = [UIColor whiteColor];
    
    // Appearance of the container (affects both Maia and MRE)
    appearance.cellBackgroundColor = [UIColor colorWithRed:0.961 green:0.969 blue:1.0 alpha:1];
    appearance.containerCornerRadius = 10.0;
    appearance.containerEdgeInsets = UIEdgeInsetsMake(10.0, 0, 10.0, 0);
    appearance.containerBackgroundColor = [UIColor colorWithRed:0.420 green:0.76 blue:0.901 alpha:1];
    
    [self.adManager setAppearance:appearance];
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

#pragma mark UICollectionViewDataSource, delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        return [self.adManager cellForItemAtIndexPath:indexPath];
    }
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    if (indexPath.row % 3 == 0) {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }else if (indexPath.row % 3 == 1){
        [cell setBackgroundColor:[UIColor darkGrayColor]];
    }else{
        [cell setBackgroundColor:[UIColor grayColor]];
    }
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        return [self.adManager sizeForItemAtIndexPath:indexPath];
    }
    
    //your stuff here
    return CGSizeMake(collectionView.frame.size.width - 20, 100);
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        [self.adManager didSelectItemAtIndexPath:indexPath];
    }
    else{
        //your stuff here
    }
    
}

@end
