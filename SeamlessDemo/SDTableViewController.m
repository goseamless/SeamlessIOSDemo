//
//  SDTableViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 01/12/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDTableViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <Seamless/Seamless.h>

@interface SDTableViewController ()

@property (nonatomic, strong) NSMutableArray * dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) SLTableViewAdManager * adManager;

@end

@implementation SDTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"Cell"];
    
    self.dataSource = [NSMutableArray array];
    [self fetchDataSource];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)fetchDataSource
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:@"https://itunes.apple.com/tr/rss/topmusicvideos/limit=10/json" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self processResponse:responseObject];
        [self requestSeamlessAds];
        [self.tableView reloadData];
        
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
    self.adManager = [[SLTableViewAdManager alloc] initWithTableView:self.tableView dataSource:self.dataSource viewController:self];
    
    [self.adManager getAdsWithEntity:@"async-data-table" category:SLCategoryEntertainment successBlock:^{
        NSLog(@"ads loaded");
    } failureBlock:^(NSError *error) {
        NSLog(@"%@",error);
    }];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.dataSource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.adManager shouldShowAdAtIndexPath:indexPath]){
        return [self.adManager cellForRowAtIndexPath:indexPath];
    }
    
    // your stuff here
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if ([self.adManager shouldShowAdAtIndexPath:indexPath])
    {
        return [self.adManager heightForRowAtIndexPath:indexPath];
    }
    
    // your stuff here
    return 100;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if([self.adManager shouldShowAdAtIndexPath:indexPath])
    {
        [self.adManager didSelectRowAtIndexPath:indexPath];
    }
    else
    {
        // your stuff here
    }
}

@end
