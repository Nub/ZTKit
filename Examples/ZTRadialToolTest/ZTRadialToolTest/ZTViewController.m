//
//  ZTViewController.m
//  ZTRadialToolTest
//
//  Created by Zachry Thayer on 2/16/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTViewController.h"

#import "UIColor+Additions.h"

@implementation ZTViewController
@synthesize toolbar;
@synthesize barItem;
@synthesize testRadialTool;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    for (int i = 0; i < 4; i++) {
        UIButton *aToolTip = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        aToolTip.frame = CGRectMake(0, 0, 50, 50);
        aToolTip.backgroundColor = [UIColor randomColor];
        aToolTip.userInteractionEnabled = YES;
        
        [self.testRadialTool addSubview:aToolTip];
    }
    
}

- (void)viewDidUnload
{
    [self setTestRadialTool:nil];
    [self setToolbar:nil];
    [self setBarItem:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)removeTooltip:(id)sender {
    
    UIView *lastView = [self.testRadialTool.subviews lastObject];
    
    if (![lastView isMemberOfClass:[UIButton class]]) {
        
        [lastView removeFromSuperview];
        [self.testRadialTool setNeedsLayout];
    }
    
    
}

- (IBAction)addTooltip:(id)sender {
    
    UIView *aToolTip = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 50)];
    aToolTip.backgroundColor = [UIColor randomColor];
    
    [self.testRadialTool addSubview:aToolTip];
    [self.testRadialTool setNeedsLayout];
    
}

- (IBAction)presentNew:(id)sender {
   
    if (testRadialTool.isBeingPresented)
    {
        [testRadialTool dismiss];
    }
    else
    {

        NSLog(@"%@", [[toolbar subviews] objectAtIndex:1] );
        
        [testRadialTool presentFromView:[[toolbar subviews] objectAtIndex:1]];
    }
    
}

- (IBAction)decreaseSize:(id)sender {
    
    CGRect newFrame = self.testRadialTool.frame;
    
    newFrame.origin.x += 25;
    newFrame.origin.y += 25;
    
    newFrame.size.width -= 50;
    newFrame.size.height -= 50;
    
    self.testRadialTool.frame = newFrame;
    
}

- (IBAction)increaseSize:(id)sender {
    
    CGRect newFrame = self.testRadialTool.frame;
    
    newFrame.origin.x -= 25;
    newFrame.origin.y -= 25;
    
    newFrame.size.width += 50;
    newFrame.size.height += 50;
    
    self.testRadialTool.frame = newFrame;
    
}

- (IBAction)doHide:(UIButton*)sender 
{
    self.testRadialTool.hiddenTooltips = !self.testRadialTool.hiddenTooltips;
    
    if (self.testRadialTool.hidden) {
        sender.titleLabel.text = @"Show";
    }
    else
    {
        sender.titleLabel.text = @"Hide";
    }
}


@end
