//
//  LTSheetHead.m
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "LTSheetHead.h"

@implementation LTSheetHead
- (void)awakeFromNib{
    [super awakeFromNib];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.backgroundColor = [UIColor whiteColor];
    self.titleLabel.textColor = [UIColor darkGrayColor];
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        self.titleLabel.font = [UIFont systemFontOfSize:16];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        self.titleLabel.font = [UIFont systemFontOfSize:18];
    }
}
@end
