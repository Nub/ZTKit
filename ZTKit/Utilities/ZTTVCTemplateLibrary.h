//
//  ZTTVCTemplateLibrary.h
//  
//
//  Created by Zachry Thayer on 10/3/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

@interface ZTTVCTemplateLibrary : NSObject

- (id)initWithNibNamed:(NSString*)aNibName;
- (id)cellOfKind:(NSString*)theCellKind forTable:(UITableView*)aTableView;

@end
