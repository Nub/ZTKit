//
//  ZTViewController.m
//  ZTDrawViewDemo
//
//  Created by Zachry Thayer on 2/21/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTViewController.h"

#import "ZTDrawView.h"

@interface ZTViewController ()

@property (strong, nonatomic) IBOutlet ZTDrawView *drawingView;
@property (strong, nonatomic) IBOutlet UITextView *SCGTextView;

- (IBAction)toSVG:(id)sender;

@end

@implementation ZTViewController
@synthesize drawingView;
@synthesize SCGTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [self setDrawingView:nil];
    [self setSCGTextView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
    } else {
        return YES;
    }
}

- (IBAction)toSVG:(id)sender 
{
    self.SCGTextView.text = [drawingView SVGRepresentation];
}

@end
