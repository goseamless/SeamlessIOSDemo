//
//  SDMainViewController.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 13/11/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "SDMainViewController.h"
#import "SDFeedViewController.h"
#import "SDFloatingViewController.h"
#import "SDTableViewController.h"
#import "SDBannerViewController.h"
#import "SDMreViewController.h"
#import "SDResizeForBannerViewController.h"
#import "SDBannerAutoLayoutViewController.h"
#import "SDVideoViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"

@interface SDMainViewController ()
@property (nonatomic, strong) NSArray * titles;
@property (nonatomic ,strong) NSArray * colors;
@property (nonatomic, strong) NSArray * contentIds;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation SDMainViewController


- (id)initWithTitles:(NSArray*)titles colors:(NSArray*)colors contentIds:(NSArray*)contentIds{
    self = [super initWithNibName:@"SDMainViewController" bundle:nil];
    if (self) {
        // Custom initialization
        self.titles = titles;
        self.colors = colors;
        self.contentIds = contentIds;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"reuse"];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    
    UIButton* myInfoButton = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [myInfoButton addTarget:self action:@selector(showCurrentVersion) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:myInfoButton];
    [self.navigationItem setTitle:@"Seamless Demo"];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController setToolbarHidden:YES animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)showCurrentVersion
{
    [[[UIAlertView alloc] initWithTitle:@"Info" message:@"The version of Seamless framework used in this demo is v1.4.0" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

-(BOOL)prefersStatusBarHidden
{
    return YES;
}

-(BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - table view delegates

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.titles count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"reuse"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString * title = [self.titles objectAtIndex:indexPath.row];
    UIColor * color = [self.colors objectAtIndex:indexPath.row];
    [cell setBackgroundColor:color];
    [cell.textLabel setTextColor:[UIColor whiteColor]];
    [cell.textLabel setText:[title uppercaseString]];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return 200.0;
    }else{
        return 100.0;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * contentId = [self.contentIds objectAtIndex:indexPath.row];

    switch ([contentId integerValue]) {
            
        case 1:{ // Collection View with Asynchronous data fetch
            SDTableViewController *controller = [[SDTableViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 2:{ // Table View with paging and refresh
            SDFeedViewController *controller = [[SDFeedViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 3:{ // Interstitial
            SDFloatingViewController *controller = [[SDFloatingViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 4:{ // Banner for all screens
            SDBannerViewController *controller = [[SDBannerViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 5:{ // Resizing view for banner
            SDResizeForBannerViewController *controller = [[SDResizeForBannerViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 6:{ // Banner with Auto layout
            SDBannerAutoLayoutViewController *controller = [[SDBannerAutoLayoutViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 7:{ // MRE inside a scroll view
            SDMreViewController *controller = [[SDMreViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 8:{ // Simple Video as Modal View Controller
            
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"ford" withExtension:@"mp4"];
            NSString *entity = @"simple-modal-view-video";
            
            [[SLPlayerManager sharedManager] presentPlayerWithUrl:url entity:entity];
        }
            break;
        case 9:{ // Adding Video Player to Custom view
            SDVideoViewController *controller = [[SDVideoViewController alloc] init];
            [self.navigationController pushViewController:controller animated:YES];
        }
            break;
        case 10:{ // Video Player with Error Handler

            NSURL *url = [[NSBundle mainBundle] URLForResource:@"ford" withExtension:@"mp4"];
            NSString *entity = @"video-with-error-handler";
            
            UIView *attachmentView = [SLDefaultVideoControllerView new];
            [[SLPlayerManager sharedManager] presentPlayerWithUrl:url entity:entity attachmentView:attachmentView shareText:nil shareUrls:nil shareImages:nil shareTitle:nil shareRecipientsMail:nil shareRecipientsSms:nil presentationHandler:nil startHandler:nil progressHandler:nil finishHandler:nil errorHandler:^{
                [[[UIAlertView alloc] initWithTitle:@"Error" message:@"Something went wrong." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
            }];
        }
            break;
            
        default:
            break;
    }
}


@end
