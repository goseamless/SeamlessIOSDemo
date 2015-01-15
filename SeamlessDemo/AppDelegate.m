//
//  AppDelegate.m
//  SeamlessDemo
//
//  Created by Suzy Kang on 13/11/14.
//  Copyright (c) 2014 Suzy Kang. All rights reserved.
//

#import "AppDelegate.h"
#import "SDMainViewController.h"
#import <Seamless/Seamless.h>
#import "Define.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        //iPad token
        [[SLManager sharedManager] setAppToken:@"7f2ac74d-53b8-4768-9731-c8f7c76d9faf"];
    }else{
        //iPhone token
        [[SLManager sharedManager] setAppToken:@"07d4c7f4-bf30-4eba-a932-29dd7fed2993"];
    }
    [[SLManager sharedManager] setLocationEnabled:YES];
    
    SDMainViewController * homeVc = [[SDMainViewController alloc] initWithTitles:@[@"Asynchronous data fetch", @"paging and refresh", @"Multiple Interstitial Requests", @"Banner for all screens", @"Resizing view for banner", @"Banner with Auto Layout", @"MRE inside a scroll view", @"Simple Video Controller", @"Video Player in Custom View"] colors:@[COLOR1,COLOR2,COLOR3,COLOR4,COLOR5,COLOR6,COLOR7, COLOR8, COLOR7] contentIds:@[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9"]];
    UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:homeVc];
    self.window.rootViewController = nav;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
