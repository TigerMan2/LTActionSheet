//
//  LTSheetView.m
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "LTSheetView.h"
#import "LTSheetCell.h"

#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)

@implementation LTSheetView
- (void)awakeFromNib{
    [super awakeFromNib];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}
#pragma mark - UITableView的数据源和代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    LTSheetCell *sheetCell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([LTSheetCell class])];
    if (!sheetCell) {
        sheetCell = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetCell class]) owner:self options:nil].lastObject;
        if (_cellTextColor) {
            sheetCell.itemLabel.textColor = _cellTextColor;
        }
    }
    sheetCell.itemLabel.text = self.dataSource[indexPath.row];
    
    //设置字体大小
    sheetCell.itemLabel.font = [UIFont systemFontOfSize:18];
    if (kWH == 667) {
        sheetCell.itemLabel.font = [UIFont systemFontOfSize:20];
    } else if (kWH > 667) {
        sheetCell.itemLabel.font = [UIFont systemFontOfSize:21];
    }
    if (_cellTextFont) {
        sheetCell.itemLabel.font = _cellTextFont;
    }
    if (_cellTextStyle == NSTextStyleLeft) {
        sheetCell.itemLabel.textAlignment = NSTextAlignmentLeft;
    } else if (_cellTextStyle == NSTextStyleRight){
        sheetCell.itemLabel.textAlignment = NSTextAlignmentRight;
    } else {
        sheetCell.itemLabel.textAlignment = NSTextAlignmentCenter;
    }
    return sheetCell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return self.cellHeight;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    //取消点击方法
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    NSInteger index = indexPath.row;
    LTSheetCell *sheetCell = (LTSheetCell *)[tableView cellForRowAtIndexPath:indexPath];
    NSString *cellTitle = sheetCell.itemLabel.text;
    if ([self.delegate respondsToSelector:@selector(selectWithIndex:title:)]) {
        [self.delegate selectWithIndex:index title:cellTitle];
    }
    
}







@end
