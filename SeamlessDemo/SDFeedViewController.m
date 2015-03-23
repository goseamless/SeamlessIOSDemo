//
//  SDFeedViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 13/11/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDFeedViewController.h"
#import <Seamless/Seamless.h>
#import <AFNetworking/AFNetworking.h>

@interface SDFeedViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) SLCollectionViewAdManager * adManager;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation SDFeedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataSource = [NSMutableArray array];
    [self.view setBackgroundColor:[UIColor lightGrayColor]];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"reuse"];
    
    [self fetchDataSourceAndSeamless];
    
    UIBarButtonItem * paging = [[UIBarButtonItem alloc] initWithTitle:@"Paging" style:UIBarButtonItemStyleBordered target:self action:@selector(fetchDataSource)];
    // do not request Seamless for paging because datasource hasn't been cleaned out.
    
    [paging setTintColor:[UIColor blueColor]];
    
    UIBarButtonItem * refresh = [[UIBarButtonItem alloc] initWithTitle:@"Refresh" style:UIBarButtonItemStyleBordered target:self action:@selector(refreshDatasource)];
    [refresh setTintColor:[UIColor blueColor]];
    
    [self setToolbarItems:@[paging, refresh] animated:YES];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setToolbarHidden:NO animated:YES];
    [self.navigationController.toolbar setBackgroundColor:[UIColor lightGrayColor]];
}

-(void)fetchDataSource
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://itunes.apple.com/tr/rss/topmusicvideos/limit=10/json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        [self processResponse:responseObject];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

-(void)fetchDataSourceAndSeamless
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://itunes.apple.com/tr/rss/topmusicvideos/limit=10/json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processResponse:responseObject];
        [self requestSeamlessAds];
        [self.collectionView reloadData];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (void)processResponse:(id)responseObject
{
    if (responseObject&&![responseObject isEqual:[NSNull null]]&&[responseObject objectForKey:@"feed"]&&![[responseObject objectForKey:@"feed"] isEqual:[NSNull null]]) {
        
        NSDictionary *feed = [responseObject objectForKey:@"feed"];
        NSArray *entry = [[NSArray alloc] initWithArray:[feed objectForKey:@"entry"]];
        
        for (int i = 0; i < entry.count; i++){
            NSDictionary *albumEntry = entry[i];
            if ([albumEntry objectForKey:@"title"] && [albumEntry objectForKey:@"link"]) {
                
                NSDictionary *dictionary = [albumEntry objectForKey:@"title"];
                if (dictionary) {
                    [self.dataSource addObject:[NSString stringWithFormat:@"%@", [dictionary objectForKey:@"label"]]];
                }
            }
        }
    }
}

-(void)requestSeamlessAds
{
    // dataSource must not be nil
    self.adManager = [[SLCollectionViewAdManager alloc] initWithCollectionView:self.collectionView dataSource:self.dataSource viewController:self];
    
    [self.adManager getAdsWithEntity:@"paging-refresh-collection" category:SLCategoryEntertainment successBlock:^{
        NSLog(@"ads loaded");
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

-(void)refreshDatasource
{
    [self.dataSource removeAllObjects];
    [self.adManager cleanDataSource];
    [self.adManager clean];
    self.adManager = nil;
    [self.collectionView reloadData];
    [self fetchDataSourceAndSeamless];
}

-(void)refreshView:(UIRefreshControl*)refresh
{
    [self fetchDataSource];
}

#pragma mark - collection view delegate & datasource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.dataSource.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        return [self.adManager cellForItemAtIndexPath:indexPath];
    }
    
    //your stuff here
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"reuse" forIndexPath:indexPath];
    
    UILabel *title = (UILabel *)[cell viewWithTag:200];
    if (!title) {
        title = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, cell.bounds.size.width-20, cell.bounds.size.height-20)];
        title.tag = 200;
        title.numberOfLines = 0;
        title.textAlignment = NSTextAlignmentCenter;
        [cell.contentView addSubview:title];
    }
    
    title.text = [self.dataSource objectAtIndex:indexPath.row];
    [cell.contentView setBackgroundColor:[UIColor whiteColor]];
  
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
