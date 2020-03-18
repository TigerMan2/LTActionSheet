//
//  TMActionSheet.m
//  TMActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "TMActionSheet.h"
#import "TMActionSheetItem.h"
#import "TMActionSheetCell.h"

@interface TMActionSheet () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) NSArray <TMActionSheetItem *> *items;
@property (nonatomic, copy) TMActionSheetHandle selectedHandle;

@property (nonatomic, strong) UIWindow *popWindow;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, weak) UIViewController *popVC;
@property (nonatomic, weak) UIView *controllerView;
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, weak) UILabel *titleLabel;

@property (nonatomic, strong) NSLayoutConstraint *heightConstraint;//!< 内容高度约束

@end

static NSString * const TMActionSheetCellIdentifier = @"TMActionSheetCellIdentifier";

@implementation TMActionSheet

#pragma mark    -    private method
// 计算title高度
- (CGFloat)heightForHeaderView {
    CGFloat labelHeight = [_titleLabel.attributedText boundingRectWithSize:CGSizeMake([self currentScreenWidth] - TMActionSheetDefaultMargin * 2, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading context:nil].size.height;
    CGFloat headerHeight = ceil(labelHeight) + TMActionSheetDefaultMargin * 2;
    return headerHeight;
}
// 当前屏幕宽度
- (CGFloat)currentScreenWidth {
    
    CGFloat currentScreenWidth;
    CGSize screenSize = [UIScreen mainScreen].bounds.size;
    // 竖屏下屏幕宽度
    CGFloat screenWidth = fmin(screenSize.width, screenSize.height);
    // 竖屏下屏幕高度
    CGFloat screenHeight = fmax(screenSize.width, screenSize.height);
    //屏幕方向
    UIInterfaceOrientation orientation = [_popVC preferredInterfaceOrientationForPresentation];
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        // 横屏
        currentScreenWidth = screenHeight;
    } else {
        // 竖屏
        currentScreenWidth = screenWidth;
    }
    return currentScreenWidth;
}
// 配置标题偏移方向
- (void)updateTitleAttributeText {
    
    if (_title.length == 0 || !_titleLabel) return;
    
    // 富文本相关配置
    NSRange attributeRange = NSMakeRange(0, _title.length);
    UIFont *titleFont = [UIFont systemFontOfSize:14];
    UIColor *titleTextColor = [UIColor colorWithHexString:TMActionSheetTitleColor];
    CGFloat lineSpacing = TMActionSheetTitleLineSpacing;
    CGFloat kernSpacing = TMActionSheetTitleKernSpacing;
    
    NSMutableAttributedString *titleAttributedString = [[NSMutableAttributedString alloc] initWithString:_title];
    NSMutableParagraphStyle *titleStyle = [[NSMutableParagraphStyle alloc] init];
    // 行距
    titleStyle.lineSpacing = lineSpacing;
    // 内容偏移样式
    switch (_contentAlignment) {
        case TMItemContentAlignmentLeft:
        {
            titleStyle.alignment = NSTextAlignmentLeft;
        }
            break;
        case TMItemContentAlignmentCenter:
        {
            titleStyle.alignment = NSTextAlignmentCenter;
        }
            break;
        case TMItemContentAlignmentRight:
        {
            titleStyle.alignment = NSTextAlignmentRight;
        }
            break;
            
        default:
            break;
    }
    
    [titleAttributedString addAttribute:NSParagraphStyleAttributeName value:titleStyle range:attributeRange];
    // 字距
    [titleAttributedString addAttribute:NSKernAttributeName value:@(kernSpacing) range:attributeRange];
    // 字体
    [titleAttributedString addAttribute:NSFontAttributeName value:titleFont range:attributeRange];
    // 颜色
    [titleAttributedString addAttribute:NSForegroundColorAttributeName value:titleTextColor range:attributeRange];
    _titleLabel.attributedText = titleAttributedString;
}

#pragma mark    -   getter
- (UIWindow *)popWindow {
    if (!_popWindow) {
        _popWindow = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _popWindow.windowLevel = UIWindowLevelStatusBar + 1;
        _popWindow.rootViewController = [[UIViewController alloc] init];
        _popVC = _popWindow.rootViewController;
        _controllerView = _popVC.view;
    }
    return _popWindow;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.scrollEnabled = NO;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = self.backgroundColor;
        _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        [_tableView registerClass:[TMActionSheetCell class] forCellReuseIdentifier:TMActionSheetCellIdentifier];
        
        if (_title.length > 0) {
            self.tableView.tableHeaderView = [self headerView];
        }
    }
    return _tableView;
}

- (UIView *)headerView {
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor colorWithHexString:TMActionSheetRowNormalColor];
    
    //标题
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.numberOfLines = 0;
    titleLabel.backgroundColor = headerView.backgroundColor;
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    [headerView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    // 设置标题内容
    [self updateTitleAttributeText];
    
    // 标题边距
    CGFloat labelMargin = TMActionSheetDefaultMargin;
    // 计算内容高度
    CGFloat headerHeight = [self heightForHeaderView];
    headerView.frame = CGRectMake(0, 0, CGRectGetWidth(self.popWindow.frame), headerHeight);
    
    // titleLabel constraint
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-labelMargin-[titleLabel]-labelMargin-|"
                                                                       options:0.0
                                                                       metrics:@{@"labelMargin" : @(labelMargin)}
                                                                         views:NSDictionaryOfVariableBindings(titleLabel)]];
    [headerView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-labelMargin-[titleLabel]"
                                                                       options:0.0
                                                                       metrics:@{@"labelMargin" : @(labelMargin)}
                                                                         views:NSDictionaryOfVariableBindings(titleLabel)]];
    return headerView;
}

#pragma mark    -   setter
- (void)setContentAlignment:(TMItemContentAlignment)contentAlignment {
    if (_contentAlignment != contentAlignment) {
        _contentAlignment = contentAlignment;
        [self updateTitleAttributeText];
    }
}

@end
