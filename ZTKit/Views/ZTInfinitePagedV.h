//
//  ZTInfinitePagedV.h
//  ZTKit
//
//  Created by Zachry Thayer on 9/30/11.
//  Copyright Zachry Thayer. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZTInfinitePagedV;

@protocol ZTInfinitePagedVDataSource

- (NSInteger)numberOfPagesInPagedView:(ZTInfinitePagedV *)pagedView;

// 0 indexed
- (UIViewController*)pagedView:(ZTInfinitePagedV *)pagedView viewControllerForPage:(NSInteger)page;

@end

@protocol ZTInfinitePagedVDelegate <UIScrollViewDelegate>

// Page is going to become within 1 of onscreen page
- (void)pagedView:(ZTInfinitePagedV *)pagedView willNeedPage:(NSInteger)page;

//Page is will move more than 1 away from onscreenpage
- (void)pagedView:(ZTInfinitePagedV *)pagedView willNoLongerNeedPage:(NSInteger)page;

//Page is currently on screen
- (void)pagedView:(ZTInfinitePagedV *)pagedView didFocusePage:(NSInteger)page;


@end


@interface ZTInfinitePagedV : UIScrollView <UIScrollViewDelegate>
{
    NSMutableArray *pageViewControllers;
    
    NSInteger _internalPage;
    NSInteger page;
    
    id <ZTInfinitePagedVDelegate> delegate;
    id <ZTInfinitePagedVDataSource> dataSource;
    
    BOOL infinitePaging;
    
}


@property (nonatomic, assign) id <ZTInfinitePagedVDelegate> delegate;
@property (nonatomic, assign) id <ZTInfinitePagedVDataSource> dataSource;

@property (nonatomic, retain) NSMutableArray *pageViewControllers;
@property (nonatomic) NSInteger page;

@property (nonatomic) BOOL infinitePaging;

@end
