//
//  WYActionSheet.m
//  WYActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "WYActionSheet.h"
#import "WYSheetFoot.h"
#import "WYSheetHead.h"
#import "WYSheetView.h"

#define kPushTime 0.3
#define kDismissTime 0.3
#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)
#define kCellH (kWH<500?45:(kWH<600?47:(kWH<700?49:50)))
#define kMW (kWW-2*kMargin)
#define kCornerRadius 5
#define kMargin 6

@interface WYActionSheet ()<WYSheetViewDelegate>
//背景按钮
@property (nonatomic , strong) UIButton *bgBtn;
//放title和sheetView的视图
@property (nonatomic , strong) UIView *contentView;
//item的view
@property (nonatomic , strong) WYSheetView *sheetView;
//title视图
@property (nonatomic , strong) WYSheetHead *titleView;
//取消按钮
@property (nonatomic , strong) WYSheetFoot *footView;
//间隔
@property (nonatomic , strong) UIView *marginView;
//contentView高度
@property (nonatomic , assign) CGFloat contentVH;
//contentView的Y坐标
@property (nonatomic , assign) CGFloat contentViewY;
//footView的Y坐标
@property (nonatomic , assign) CGFloat footViewY;
//数据源
@property (nonatomic , strong) NSArray *dataSource;
//样式
@property (nonatomic , assign) WYSheetStyle sheetStyle;
//block
@property (nonatomic , assign) SelectIndexBlock selectBlock;

@end

@implementation WYActionSheet

- (instancetype)initWithTitle:(NSString *)title style:(WYSheetStyle)style itemTitles:(NSArray *)itemTitles{
    
    if (self = [super initWithFrame:[[UIScreen mainScreen] bounds]]) {
        
        self.sheetStyle = style;
        self.dataSource = itemTitles;
        [[[UIApplication sharedApplication] keyWindow] addSubview:self];
        //背景按钮
        self.bgBtn = [[UIButton alloc] init];
        self.bgBtn.backgroundColor = [UIColor blackColor];
        self.bgBtn.alpha = 0.3;
        [self addSubview:self.bgBtn];
        //盛放title和items
        self.contentView = [[UIView alloc] init];
        [self addSubview:self.contentView];
        //取消按钮
        self.footView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WYSheetFoot class]) owner:self options:nil].lastObject;
        [self addSubview:self.footView];
        //items
        self.sheetView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WYSheetView class]) owner:self options:nil].lastObject;
        self.sheetView.dataSource = self.dataSource;
        self.sheetView.delegate = self;
        self.sheetView.cellHeight = kCellH;
        [self.contentView addSubview:self.sheetView];
        
        
        //判断选择的类型
        if (style == WYSheetStyleDefault) {
            self = [self updateDefaultStyleWithItems:itemTitles title:title selfView:self];
            [self pushDefaultStyleSheetView];
        }else if (style == WYSheetStyleWeiChat){
            //微信样式,待开发
            
        }else if (style == WYSheetStyleTable){
            //列表样式,待开发
        }
        
    }
    return self;
}
#pragma mark - 更新默认样式
- (id)updateDefaultStyleWithItems:(NSArray *)items title:(NSString *)title selfView:(WYActionSheet *)selfView
{
    //半透明按钮
    [selfView.bgBtn addTarget:selfView action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgBtn.frame = CGRectMake(0, 0, kWW, kWH);
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([WYSheetHead class]) owner:selfView options:nil].lastObject;
        selfView.titleView.backgroundColor = [UIColor whiteColor];
        selfView.titleView.titleLabel.text = title;
        
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    //布局子控件
    int cellCount = (int)items.count;
    //计算contentView的高度
    selfView.contentVH = kCellH * (cellCount + isTitle);
    //设置最大高度
    CGFloat maxH = kWH - 200 - (kCellH + 2*kMargin);
    if (selfView.contentVH > maxH) {
        //设置items的视图可以滑动
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    }else{
        //设置items的视图不能滑动
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    //设置取消按钮的Y坐标
    selfView.footViewY = kWH - kCellH - kMargin;
    //初始设置在界面外
    selfView.footView.frame = CGRectMake(kMargin, kWH + selfView.contentVH + kMargin, kMW, kCellH);
    selfView.contentViewY = kWH - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - 2 * kMargin;
    selfView.contentView.frame = CGRectMake(kMargin, kWH, kMW, selfView.contentVH);
    
    //设置contentView的布局
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kMW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH -= sheetY;
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kMW, sheetH);
    //设置圆角
    selfView.contentView.layer.masksToBounds = YES;
    selfView.contentView.layer.cornerRadius = kCornerRadius;
    selfView.footView.layer.masksToBounds = YES;
    selfView.footView.layer.cornerRadius = kCornerRadius;
    
    //取消方法
    [selfView.footView.cancelBtn addTarget:selfView action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    
    return selfView;
}
//显示默认的样式
- (void)pushDefaultStyleSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentViewY, kMW,weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, weakSelf.footViewY, kMW, kCellH);
        weakSelf.bgBtn.alpha = 0.35;
    }];
    
}
//显示
- (void)show
{
    if (_sheetStyle == WYSheetStyleDefault) {
        [self pushDefaultStyleSheetView];
    }
    else if (_sheetStyle == WYSheetStyleWeiChat) {
        
    }
    else if (_sheetStyle == WYSheetStyleTable) {
        
    }
}
//取消显示
- (void)dismissDefaulfSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, kWH, kMW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, kWH + weakSelf.contentVH, kMW, kCellH);
        weakSelf.bgBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.bgBtn removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}

//block传值出去
- (void)didFinishSelectBlock:(SelectIndexBlock)block{
    _selectBlock = block;
}

/**
 Description

 @param index 索引
 @param title 标题
 */
- (void)selectWithIndex:(NSInteger)index title:(NSString *)title{
    
    if (_selectBlock) {
        _selectBlock(index,title);
    }
    
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectWithIndex:title:sender:)]) {
        [self.delegate sheetViewDidSelectWithIndex:index title:title sender:self];
    }
    if ([self.delegate respondsToSelector:@selector(sheetViewDidSelectWithIndex:title:)]) {
        [self.delegate sheetViewDidSelectWithIndex:index title:title];
    }
    
    if (_sheetStyle == WYSheetStyleDefault) {
        [self dismissDefaulfSheetView];
    }
    else if (_sheetStyle == WYSheetStyleWeiChat) {
        
    }
    else if (_sheetStyle == WYSheetStyleTable) {
        
    }
}

/**
 Description

 @param titleTextColor 标题文字颜色
 */
- (void)setTitleTextColor:(UIColor *)titleTextColor{
    if (titleTextColor) {
        _titleView.titleLabel.textColor = titleTextColor;
    }
}

/**
 Description

 @param itemTextColor item文字颜色
 */
- (void)setItemTextColor:(UIColor *)itemTextColor{
    if (itemTextColor) {
        _sheetView.cellTextColor = itemTextColor;
    }
}

/**
 Description

 @param cancelBtnTextColor 取消按钮的文字颜色
 */
- (void)setCancelBtnTextColor:(UIColor *)cancelBtnTextColor{
    if (cancelBtnTextColor) {
        [_footView.cancelBtn setTitleColor:cancelBtnTextColor forState:UIControlStateNormal];
    }
}

/**
 Description

 @param titleTextFont 标题文字字体
 */
- (void)setTitleTextFont:(UIFont *)titleTextFont{
    if (titleTextFont) {
        _titleView.titleLabel.font = titleTextFont;
    }
}

/**
 Description

 @param itemTextFont item文字字体
 */
- (void)setItemTextFont:(UIFont *)itemTextFont{
    if (itemTextFont) {
        _sheetView.cellTextFont = itemTextFont;
    }
}

/**
 Description

 @param cancelTextFont 取消文字字体
 */
- (void)setCancelTextFont:(UIFont *)cancelTextFont{
    if (cancelTextFont) {
        [_footView.cancelBtn.titleLabel setFont:cancelTextFont];
    }
}

/**
 Description

 @param cancelTitle 取消按钮文字
 */
- (void)setCancelTitle:(NSString *)cancelTitle{
    if (cancelTitle) {
        [_footView.cancelBtn setTitle:cancelTitle forState:UIControlStateNormal];
    }
}


@end
