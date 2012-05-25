//
//  ZTInfinitePagedV.m
//  ZTKit
//
//  Created by Zachry Thayer on 9/30/11.
//  Copyright Zachry Thayer. All rights reserved.
//

#import "ZTInfinitePagedV.h"
#import "ZTHelpers.h"

@interface ZTInfinitePagedV ()

@property (nonatomic, strong) NSMutableArray*pagedViews;
@property (nonatomic, readwrite) NSInteger page;
@property (nonatomic) BOOL infinitePaging;


- (void)initialize;

- (void)gotoNextPage;
- (NSInteger)nextPageIndex;

- (void)gotoPreviousPage;
- (NSInteger)previousPageIndex;

@end

@implementation ZTInfinitePagedV

#pragma mark Private properties

@synthesize pagedViews;

#pragma mark Public properties

@synthesize delegate;
@synthesize dataSource;
@synthesize page;

@synthesize infinitePaging;

#pragma mark - Lifecycle

ZTKViewInitialize
{
    
    self.pagedViews = [NSMutableArray array];

    CGSize newSize = self.frame.size;
    newSize.width *= 3;//3 views max, each view should be the size of the container
    self.contentSize = newSize;
    
    self.infinitePaging = YES;
    self.page = 0;
    
    [super setDelegate: self];
    [super setPagingEnabled:YES];
    
}

- (void)dealloc
{
    self.pagedViews = nil;
    
}

#pragma mark Setters

- (void)setDataSource:(id<ZTInfinitePagedVDataSource>)newDataSource
{
    
    dataSource = newDataSource;
    
    if (!dataSource)
    {
        // Purge views
    }
    
    NSInteger pageCount = [dataSource numberOfPagesInPagedView:self];
    
    if (self.infinitePaging)
    {
        self.page = pageCount - 2;
    }
    
    NSAssert((pageCount >= 3), @"ZTInfinitePagedV Requires at least 3 subviews");
    CGFloat pageWidth = self.frame.size.width;
        
    // Load first 3 views
    for (NSInteger i = 0; i < 3; i++) 
    {
        self.page = [self nextPageIndex];
        UIView *aView = [dataSource pagedView:self viewForPage:self.page];
                
        CGRect adjustedFrame = aView.frame;
        adjustedFrame.origin.x = pageWidth * i;
        adjustedFrame.origin.y = 0;
        aView.frame = adjustedFrame;
        
        [self addSubview:aView];
        [self.pagedViews addObject:aView];
    }
    
    self.page = 0;
    
    [self setContentOffset:CGPointMake(pageWidth, 0)];
    [self setNeedsLayout];
    [self setNeedsDisplay];
}

#pragma mark - Layout

- (void)layoutSubviews
{
        
    CGFloat pageWidth = self.frame.size.width;
    
    NSInteger pageIndex = 0;
    
    for (UIView *subView in self.pagedViews) 
    {
        CGRect adjustedFrame = subView.frame;
        adjustedFrame.origin.x = pageWidth * pageIndex;
        subView.frame = adjustedFrame;
        
        pageIndex ++;   
    }
    
    
    [super layoutSubviews];
}


#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    NSInteger direction = floorf(self.contentOffset.x / pageWidth);
    
    switch (direction)
    {
        case 0:
            [self gotoPreviousPage];
            break;
        case 2:
            [self gotoNextPage];
            break;
    }
    
    [self setContentOffset:CGPointMake(pageWidth, 0)];
    [self setNeedsLayout];
    [self.delegate pagedView:self didFocusePage:self.page];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    CGFloat xOffset = self.contentOffset.x;
    
    if (xOffset < 0)
    {
        [self gotoPreviousPage];
        [self setContentOffset:CGPointMake(pageWidth, 0)];
    }
    
    if (xOffset > pageWidth * 2)
    {
        [self gotoNextPage];
        [self setContentOffset:CGPointMake(pageWidth, 0)];
    }

}

#pragma mark - Private Helpers

#define kZTInfinitePagedVLeftPageIndex   0
#define kZTInfinitePagedVFocusPageIndex  1
#define kZTInfinitePagedVRightPageIndex  2

- (void)gotoNextPage
{
    NSLog(@"NextPage");
    NSLog(@"currPage = %i", self.page);
    NSInteger removePageIndex = [self previousPageIndex];
    self.page = [self nextPageIndex];
    NSInteger addPageIndex = [self nextPageIndex];
    NSLog(@"newPage = %i", self.page);
    NSLog(@"addPage = %i", addPageIndex);
        
    UIView *removeView = [self.pagedViews objectAtIndex:0];
    
    [self.delegate pagedView:self willNeedPage:addPageIndex];
    UIView *addView = [self.dataSource pagedView:self viewForPage:addPageIndex];

    //Remove from front append to tail
    [self.delegate pagedView:self willNoLongerNeedPage:removePageIndex];
    [removeView removeFromSuperview];
    [self.pagedViews removeObjectAtIndex:0];

    [self addSubview:addView];
    [self.pagedViews addObject:addView];
    [self setNeedsLayout];
}

- (NSInteger)nextPageIndex
{
    NSInteger nextPage = self.page + 1;
    
    if (nextPage >= [self.dataSource numberOfPagesInPagedView:self])
    {
        if (self.infinitePaging)//Wrap
            nextPage = 0;
        else
            nextPage = self.page;
    }
    
    return nextPage;
}

- (void)gotoPreviousPage
{    
    NSLog(@"PreviousPage");
    NSLog(@"currPage = %i", self.page);
    NSInteger removePageIndex = [self nextPageIndex];
    self.page = [self previousPageIndex];
    NSInteger addPageIndex = [self previousPageIndex];
    NSLog(@"newPage = %i", self.page);
    NSLog(@"addPage = %i", addPageIndex);
    
    UIView *removeView = [self.pagedViews lastObject];  
    
    [self.delegate pagedView:self willNeedPage:addPageIndex];
    UIView *addView = [self.dataSource pagedView:self viewForPage:addPageIndex];
    
    //Remove view and add new view to front of stack
    [self.delegate pagedView:self willNoLongerNeedPage:removePageIndex];
    [removeView removeFromSuperview];
    [self.pagedViews removeLastObject];
    
    [self addSubview:addView];
    [self.pagedViews insertObject:addView atIndex:0];
    [self setNeedsLayout];
}

- (NSInteger)previousPageIndex
{
    NSInteger prevPage = self.page - 1;
    
    if (prevPage < 0) 
    {
        if (self.infinitePaging)//Wrap
            prevPage = [self.dataSource numberOfPagesInPagedView:self] - 1;
        else
            prevPage = self.page;
    }
    
    return prevPage;
}

@end
