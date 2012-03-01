//
//  ZTViewController.h
//  ZTRadialToolTest
//
//  Created by Zachry Thayer on 2/16/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ZTRadialTool.h"

@interface ZTViewController : UIViewController

@property (strong, nonatomic) IBOutlet ZTRadialTool *testRadialTool;
- (IBAction)removeTooltip:(id)sender;
- (IBAction)addTooltip:(id)sender;

- (IBAction)presentNew:(id)sender;

- (IBAction)decreaseSize:(id)sender;
- (IBAction)increaseSize:(id)sender;
- (IBAction)doHide:(id)sender;
@property (strong, nonatomic) IBOutlet UIToolbar *toolbar;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *barItem;
@end
