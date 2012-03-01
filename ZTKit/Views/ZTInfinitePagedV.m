//
//  ZTInfinitePagedV.m
//  ZTKit
//
//  Created by Zachry Thayer on 9/30/11.
//  Copyright Zachry Thayer. All rights reserved.
//

#import "ZTInfinitePagedV.h"

#define PerformSafeSelectorWithObject(Target, Selector, Object) (([Target respondsToSelector:Selector])?[Target performSelector:Selector withObject:Object]:nil)

#define PerformSafeSelector(Target, Selector) (([Target respondsToSelector:Selector])?[Target performSelector:Selector]:nil)

@interface ZTInfinitePagedV ()

- (void)initialize;


- (void)gotoNextPage;
- (NSInteger)nextPageIndex;

- (void)gotoPreviousPage;
- (NSInteger)previousPageIndex;

@end

@implementation ZTInfinitePagedV

@synthesize delegate = delegate;
@synthesize dataSource = dataSource;

@synthesize pageViewControllers = pageViewControllers;
@synthesize page = page;

@synthesize infinitePaging;

#pragma mark - Lifecycle

- (id)initWithCoder:(NSCoder *)aDecoder{
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initialize];
        
    }
    
    return self;
    
}

- (id)initWithFrame:(CGRect)frame{
    
    self = [super initWithFrame:frame];
    if (self) {
        
        [self initialize];
        
    }
    
    return self;
    
}

- (id)init
{
    self = [super init];
    if (self) {

        [self initialize];
        
    }
    
    return self;
}

- (void)dealloc{
    
    [pageViewControllers release], pageViewControllers = nil;
    
    [super dealloc];
    
}

- (void)setDataSource:(id<ZTInfinitePagedVDataSource>)newDataSource{
    
    dataSource = newDataSource;
    
    NSInteger pageCount = [dataSource numberOfPagesInPagedView:self];
    
    NSAssert((pageCount >= 3), @"ZTInfinitePagedV Requires at least 3 subviews");
    
    CGFloat pageWidth = self.frame.size.width;
    
    for (NSInteger i = 0; i < 3; i++) {
        
        UIViewController *newController = [dataSource pagedView:self viewControllerForPage:i];
        
        CGRect adjustedFrame = newController.view.frame;
        adjustedFrame.origin.x = pageWidth * i;
        adjustedFrame.origin.y = 0;
        newController.view.frame = adjustedFrame;
        
        [self addSubview:newController.view];
        
        [self.pageViewControllers addObject:newController];
        
    }
    
     [self setContentOffset:CGPointMake(pageWidth, 0)];
    
     _internalPage = 1;
    
}

#pragma mark - Layout

- (void)layoutSubviews{
        
    CGFloat pageWidth = self.frame.size.width;
    
    NSInteger pageIndex = 0;
    
    for (UIView *subView in self.subviews) {
        // if (subView.frame.size.width != 7) {//If not scrollbar
            
            CGRect adjustedFrame = subView.frame;
            adjustedFrame.origin.x = pageWidth * pageIndex;
            subView.frame = adjustedFrame;
            
            pageIndex ++;
            
        //  }
    }
    
    
    [super layoutSubviews];

    
}


#pragma mark - Scroll View Delegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = self.frame.size.width;
    _internalPage = floorf(self.contentOffset.x / pageWidth);
    
    switch (_internalPage) {
        case 0:
            [self gotoPreviousPage];
            break;
        case 2:
            [self gotoNextPage];
            break;
    }
    [self setContentOffset:CGPointMake(pageWidth, 0)];

    if (infinitePaging) {
        _internalPage = 1;
        //[self setContentOffset:CGPointMake(pageWidth, 0)];
    }

}

#pragma mark - Private Helpers

- (void)initialize{
    
    self.pageViewControllers = [NSMutableArray array];
    
    CGSize newSize = self.frame.size;
    newSize.width *= 3;//3 views max, each view should be the size of the container
    self.contentSize = newSize;
    
    infinitePaging = YES;
    _internalPage = 1;
    page = 1;
    
    [super setDelegate: self];
    [super setPagingEnabled:YES];
    
}

#define kZTInfinitePagedVLeftPageIndex   0
#define kZTInfinitePagedVFocusPageIndex  1
#define kZTInfinitePagedVRightPageIndex  2

- (void)gotoNextPage{
        
    NSInteger removePageIndex = [self previousPageIndex];
    page = [self nextPageIndex];
    NSInteger addPageIndex = [self nextPageIndex];
        
    
    UIViewController *removeViewController = [pageViewControllers objectAtIndex:kZTInfinitePagedVLeftPageIndex];
    UIView *removeView = removeViewController.view;
    
    UIViewController *addViewController = [dataSource pagedView:self viewControllerForPage:addPageIndex];
    UIView *addView = addViewController.view;

    [removeView removeFromSuperview];
    [self addSubview:addView];
    [self setNeedsLayout];
    
    [pageViewControllers removeObject:removeViewController];
    [pageViewControllers addObject:addViewController];//tail
    
}

- (NSInteger) nextPageIndex{
    
    NSInteger nextPage = page + 1;
    
    if (nextPage >= [dataSource numberOfPagesInPagedView:self]) {
        
        if (infinitePaging)//Wrap
            nextPage = 0;
        else
            nextPage = page;
        
        
    }
    
    return nextPage;
}

- (void)gotoPreviousPage{
    
    NSInteger removePageIndex = [self nextPageIndex];
    page = [self previousPageIndex];
    NSInteger addPageIndex = [self previousPageIndex];
    
    
    UIViewController *removeViewController = [pageViewControllers objectAtIndex:kZTInfinitePagedVRightPageIndex];
    UIView *removeView = removeViewController.view;
    
    UIViewController *addViewController = [dataSource pagedView:self viewControllerForPage:addPageIndex];
    UIView *addView = addViewController.view;
    
    [removeView removeFromSuperview];
    [self addSubview:addView];
    [self sendSubviewToBack:addView];
   
    [self setNeedsLayout];
    
    [pageViewControllers removeObject:removeViewController];
    [pageViewControllers insertObject:addViewController atIndex:0];//head
    
}

- (NSInteger)previousPageIndex{
    
    NSInteger nextPage = page - 1;
    
    if (nextPage < 0) {
        
        if (infinitePaging)//Wrap
            nextPage = [dataSource numberOfPagesInPagedView:self] - 1;
        else
            nextPage = page;
        
        
    }
    
    return nextPage;
       
}

@end
