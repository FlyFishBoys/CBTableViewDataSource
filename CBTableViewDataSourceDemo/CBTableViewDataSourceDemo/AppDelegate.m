//
//  AppDelegate.m
//  CBTableViewDataSourceDemo
//
//  Created by Cocbin on 16/6/4.
//  Copyright © 2016年 Cocbin. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"
#import "CBIconfont.h"
#import "ClassA.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    [[CBIconfont instance] initWithConfig:@{
                                            @(IFFontPath):@"iconfont.ttf",
                                            @(IFFontIdentify):
            @{
                    @"ic_following":@"\ue602",
                    @"ic_follower":@"\ue603",
                    @"ic_star":@"\ue600",
                    @"ic_setting":@"\ue601",
                    @"ic_share":@"\ue604",
                    @"ic_demo1":@"\ue605",
                    @"ic_demo2":@"\ue606",
                    @"ic_demo3":@"\ue607",
                    @"ic_demo4":@"\ue608",
                    @"ic_demo5":@"\ue609"
            }}];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = [[MainViewController alloc] init];
    [self.window makeKeyAndVisible];
    
    
    // 最后我们可以这样做
    ClassA * a = [ClassA new];
    a.aaa(YES);
    a.ttt(NO, @"zhansan", @[@"man1",@"man2"]);
  
    a.aaa(YES).bbb(@"HelloWorld!").ccc(@"Objective-C").ddd(NO);
    
    
    return YES;
}


@end
