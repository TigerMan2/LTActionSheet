//
//  LTSheetFoot.m
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "LTSheetFoot.h"

@implementation LTSheetFoot
- (void)awakeFromNib{
    
    [super awakeFromNib];
    
    _cancelBtn.backgroundColor = [UIColor whiteColor];
    
    [_cancelBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateNormal];
    [_cancelBtn setTitleColor:[UIColor colorWithRed:0/255.0 green:122/255.0 blue:255/255.0 alpha:1.0] forState:UIControlStateHighlighted];
    
    _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:18];
    
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        _cancelBtn.titleLabel.font = [UIFont boldSystemFontOfSize:21];
    }

}
@end
