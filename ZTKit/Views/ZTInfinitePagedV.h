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

@required
- (NSInteger)numberOfPagesInPagedView:(ZTInfinitePagedV *)pagedView;

// 0 indexed
- (UIView*)pagedView:(ZTInfinitePagedV *)pagedView viewForPage:(NSInteger)page;

@end

@protocol ZTInfinitePagedVDelegate <UIScrollViewDelegate>

@optional
// Page is going to become within 1 of onscreen page
- (void)pagedView:(ZTInfinitePagedV *)pagedView willNeedPage:(NSInteger)page;

//Page is will move more than 1 away from onscreenpage
- (void)pagedView:(ZTInfinitePagedV *)pagedView willNoLongerNeedPage:(NSInteger)page;

//Page is currently on screen
- (void)pagedView:(ZTInfinitePagedV *)pagedView didFocusePage:(NSInteger)page;


@end


@interface ZTInfinitePagedV : UIScrollView <UIScrollViewDelegate>

@property (nonatomic, weak) id <ZTInfinitePagedVDelegate> delegate;
@property (nonatomic, weak) id <ZTInfinitePagedVDataSource> dataSource;

@property (nonatomic, readonly) NSInteger page;


@end
