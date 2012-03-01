//
//  ZTViewController.m
//  ZTTVCTemplateLibraryDemo
//
//  Created by Zachry Thayer on 2/29/12.
//  Copyright (c) 2012 Zachry Thayer. All rights reserved.
//

#import "ZTViewController.h"
#import "ZTTVCTemplateLibrary.h"

@interface ZTViewController ()

@property (nonatomic, strong) ZTTVCTemplateLibrary *templateLibrary;

@end

@implementation ZTViewController

#pragma mark - Hidden Properties

@synthesize templateLibrary;

#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
}

#pragma mark - TableView Data Source

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* newCell;
    
    if (indexPath.row % 2)
    {
       newCell = [self.templateLibrary cellOfKind:@"TestJunk" forTable:tableView];
    }
    else
    {
        newCell = [self.templateLibrary cellOfKind:@"Ponies" forTable:tableView];
    }
    
    return newCell;
}

#pragma mark - Getters

//Lazy load template library
- (ZTTVCTemplateLibrary*)templateLibrary
{
    if (!templateLibrary) {
        
        templateLibrary = [[ZTTVCTemplateLibrary alloc] initWithNibNamed:@"CellTemplateLibrary"];
        
    }
    
    return templateLibrary;
}

@end
