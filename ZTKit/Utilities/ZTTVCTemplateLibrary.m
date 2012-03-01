//
//  ZTTVCTemplateLibrary.h
//  ZTKit
//
//  Created by Zachry Thayer on 10/3/11.
//  Copyright (c) 2011 Zachry Thayer. All rights reserved.
//

#import "ZTTVCTemplateLibrary.h"

@interface ZTTVCTemplateLibrary ()

@property (nonatomic, strong) NSMutableDictionary * viewTemplateLibrary;

@end


@implementation ZTTVCTemplateLibrary

@synthesize viewTemplateLibrary;

- (id)initWithNibNamed:(NSString*)aNibName
{
    if (self == [super init]) {
        self.viewTemplateLibrary = [[NSMutableDictionary alloc] init];
        NSArray * templates = [[NSBundle mainBundle] loadNibNamed:aNibName owner:self options:nil];
        for (id template in templates) {
            if ([template isKindOfClass:[UITableViewCell class]]) {
                UITableViewCell * cellTemplate = (UITableViewCell *)template;
                NSString * key = cellTemplate.reuseIdentifier;
                if (key) {
                    [self.viewTemplateLibrary setObject:[NSKeyedArchiver
                                                  archivedDataWithRootObject:template]
                                          forKey:key];
                } else {
                    @throw [NSException exceptionWithName:@"Unknown cell"
                                                   reason:@"Cell has no reuseIdentifier"
                                                 userInfo:nil];
                }
            }
        }
    }
    
    return self;
}


- (id)cellOfKind:(NSString*)theCellKind forTable:(UITableView*)aTableView
{
    id cell = [aTableView dequeueReusableCellWithIdentifier:theCellKind];
    
    if (!cell) {
        NSData * cellData = [self.viewTemplateLibrary objectForKey:theCellKind];
        if (cellData) {
            cell = [NSKeyedUnarchiver unarchiveObjectWithData:cellData];
        } else {
            NSLog(@"Don't know nothing about cell of kind %@", theCellKind);
        }
    }
    
    return cell;
}

@end
