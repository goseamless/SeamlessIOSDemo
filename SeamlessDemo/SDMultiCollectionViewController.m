//
//  SDMultiCollectionViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 09/02/15.
//  Copyright (c) 2015 Suzy Kang. All rights reserved.
//

#import "SDMultiCollectionViewController.h"
#import "Define.h"
#import <Seamless/Seamless.h>

#define LANDSCAPE_CELLSIZE CGSizeMake(290.0, 250.0);
#define PORTRAIT_CELLSIZE CGSizeMake(320.0, 250.0);

@interface SDMultiCollectionViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SLCollectionViewAdManager * adManager;
@property (nonatomic, strong) NSMutableArray *dataSource;
@end

@implementation SDMultiCollectionViewController

static NSString * const reuseIdentifier = @"Cell";

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Register cell classes
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:20];
    for (int i = 0; i < 20; i++) {
        [self.dataSource addObject:[NSString stringWithFormat:@"%i", i]];
    }
    
    [self requestSeamless];
}

-(void)requestSeamless
{
    self.adManager = [[SLCollectionViewAdManager alloc] initWithCollectionView:self.collectionView dataSource:self.dataSource viewController:self];
   
    [self.adManager getAdsWithEntity:@"multi-column-collection" category:SLCategoryNews successBlock:^{
        NSLog(@"Ads loaded");
    } failureBlock:^(NSError *error) {
        NSLog(@"%@", error);
    }];
    
    SLAppearance *appearance = [[SLAppearance alloc] init];
    appearance.collectionViewLandscapeCellSize = LANDSCAPE_CELLSIZE;
    appearance.collectionViewPortraitCellSize = PORTRAIT_CELLSIZE;
    [self.adManager setAppearance:appearance];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.collectionView.collectionViewLayout invalidateLayout];
}

#pragma mark <UICollectionViewDataSource>

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
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    if (indexPath.row % 3 == 0) {
        [cell setBackgroundColor:[UIColor lightGrayColor]];
    }else if (indexPath.row % 3 == 1){
        [cell setBackgroundColor:[UIColor darkGrayColor]];
    }else{
        [cell setBackgroundColor:[UIColor grayColor]];
    }
    
    return cell;
}

#pragma mark - FlowLayout delegate

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        return [self.adManager sizeForItemAtIndexPath:indexPath];
    }
    
    if (LANDSCAPE) {
        return LANDSCAPE_CELLSIZE;
    }else{
        return PORTRAIT_CELLSIZE;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(30.0, 40.0, 30.0, 40.0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 30.0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 30.0;
}

#pragma mark - Collection view delegate

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        [self.adManager didSelectItemAtIndexPath:indexPath];
    }
    else{
        // your stuff here
    }
}

@end
