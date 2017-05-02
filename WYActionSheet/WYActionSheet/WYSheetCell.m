//
//  WYSheetCell.m
//  WYActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "WYSheetCell.h"

@implementation WYSheetCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _itemLabel.backgroundColor = [UIColor whiteColor];
    _itemLabel.textColor = [UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0];
    _itemLabel.font = [UIFont systemFontOfSize:18];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        _itemLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        _itemLabel.font = [UIFont systemFontOfSize:21];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
