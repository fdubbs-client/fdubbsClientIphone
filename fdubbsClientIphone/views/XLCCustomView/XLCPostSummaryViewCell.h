//
//  XLCPostSummaryViewCell.h
//  fdubbsClientIphone
//
//  Created by dennis on 14-8-11.
//  Copyright (c) 2014年 cn.edu.fudan.ss.xulvcai.fdubbs.client. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XLCPostSummary.h"

@interface XLCPostSummaryViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *ownerLabel;
@property (strong, nonatomic) IBOutlet UIButton *ownerButton;

@property NSInteger rowIndex;

- (void)setUpWithPostSummary:(XLCPostSummary *)postSummary AtRow:(NSUInteger)rowNum;
@end
