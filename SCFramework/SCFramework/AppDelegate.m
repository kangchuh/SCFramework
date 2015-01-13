//
//  AppDelegate.m
//  SCFramework
//
//  Created by Angzn on 3/4/14.
//  Copyright (c) 2014 Richer VC. All rights reserved.
//

#import "AppDelegate.h"

#import <AFNetworkActivityIndicatorManager.h>

#import "SCDemoListViewController.h"

#import "SCKeyValueStore.h"

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application willFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSDictionary *dictionary = @{@"user_id": @"123456",
                                 @"user_name": @"username",
                                 @"user_phone": @"13912345678"};
    NSString *string = @"字符串";
    NSNumber *number = @(9876543210);
    NSArray *array = @[@"array - 1",
                       @"array - 2",
                       @"array - 3",
                       @"array - 4",
                       @"array - 5",
                       @"array - 6",
                       @"array - 7",
                       @"array - 8",
                       @"array - 9",
                       @"array - 0"];
    
    static NSString *tableName = @"data";
    
    SCKeyValueStore *store = [[SCKeyValueStore alloc] init];
    
    [store createTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store putObject:dictionary
              forKey:@"1"
           intoTable:tableName];
    
    [store putString:string
              forKey:@"2"
           intoTable:tableName];
    
    [store putNumber:number
              forKey:@"3"
           intoTable:tableName];
    
    [store putObject:array
              forKey:@"4"
           intoTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    DLog(@"%@", [store queryItemForKey:@"1" fromTable:tableName]);
    
    [store deleteForKey:@"1" fromTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store deleteForKeys:@[@"3", @"4"] fromTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store putObject:dictionary
              forKey:@"Prefix_1"
           intoTable:tableName];
    
    [store putString:string
              forKey:@"Prefix_2"
           intoTable:tableName];
    
    [store putNumber:number
              forKey:@"Prefix_3"
           intoTable:tableName];
    
    [store putObject:array
              forKey:@"Prefix_4"
           intoTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store deleteForKeyContainPrefix:@"Prefix" fromTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store deleteFromTable:tableName];
    
    DLog(@"%@", [store queryFromTable:tableName]);
    
    [store dropTable:tableName];
    
    [store close];
    
    return YES;
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024
                                                         diskCapacity:20 * 1024 * 1024
                                                             diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    // -------------------------- <#Description#> -------------------------- //
    
    NSShadow *shadow = [[NSShadow alloc] init];
    shadow.shadowOffset = CGSizeMake(-1, -1);
    shadow.shadowColor = [UIColor whiteColor];
    NSDictionary *textAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor],
                                     NSShadowAttributeName: shadow,
                                     NSFontAttributeName: kSCBOLDSYSTEMFONT(18)};
    [[UINavigationBar appearance] setTitleTextAttributes:textAttributes];
    
    //[[UIBarButtonItem appearance] setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    
    if (kSC_iOS7_OR_LATER) {
        [[UINavigationBar appearance] setTintColor:[UIColor orangeColor]];
        [[UINavigationBar appearance] setBarTintColor:[UIColor brownColor]];
    } else {
        [[UIBarButtonItem appearance] setTintColor:[UIColor orangeColor]];
        //[[UINavigationBar appearance] setTintColor:[UIColor brownColor]];
    }
    
    // -------------------------- <#Description#> -------------------------- //
    
    SCDemoListViewController *tableViewController = [[SCDemoListViewController alloc] init];
    self.navigationController = [[SCCTNavigationController alloc] initWithRootViewController:
                                 tableViewController];
    //self.navigationController.navigationBarHidden = YES;
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    self.window.rootViewController = self.navigationController;
    //self.window.rootViewController = tableViewController;
    [self.window makeKeyAndVisible];
    
    /*
     NSError * error = [NSError errorWithDomain:@"Domain" code:0 userInfo:nil];
     NSError * * pError;
     NSError * * __strong pError1 ;
     NSError * __strong * pError2 ;
     NSError __strong * * pError3 ;
     __strong NSError * * pError4 ;
     //*/
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
