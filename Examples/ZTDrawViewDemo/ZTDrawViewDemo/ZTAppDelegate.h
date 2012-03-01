//
//  ZTAppDelegate.h
//  ZTDrawViewDemo
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTViewController;

@interface ZTAppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ZTViewController *viewController;

@end
