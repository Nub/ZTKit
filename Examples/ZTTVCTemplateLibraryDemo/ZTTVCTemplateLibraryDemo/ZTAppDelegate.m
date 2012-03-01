//
//  ZTAppDelegate.m
//  ZTTVCTemplateLibraryDemo
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTAppDelegate.h"

#import "ZTViewController.h"

@implementation ZTAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
   
    self.viewController = [[ZTViewController alloc] initWithNibName:@"ZTViewController" bundle:nil];
    
    self.window.rootViewController = self.viewController;
    [self.window makeKeyAndVisible];
    return YES;
}

@end
