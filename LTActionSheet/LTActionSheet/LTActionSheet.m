//
//  LTActionSheet.m
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import "LTActionSheet.h"
#import "LTSheetFoot.h"
#import "LTSheetHead.h"
#import "LTSheetView.h"

#define kPushTime 0.3
#define kDismissTime 0.3
#define kWH ([[UIScreen mainScreen] bounds].size.height)
#define kWW ([[UIScreen mainScreen] bounds].size.width)
#define kCellH (kWH<500?45:(kWH<600?47:(kWH<700?49:50)))
#define kMW (kWW-2*kMargin)
#define kCornerRadius 5
#define kMargin 6

@interface LTActionSheet ()<LTSheetViewDelegate>
//背景按钮
@property (nonatomic , strong) UIButton *bgBtn;
//放title和sheetView的视图
@property (nonatomic , strong) UIView *contentView;
//item的view
@property (nonatomic , strong) LTSheetView *sheetView;
//title视图
@property (nonatomic , strong) LTSheetHead *titleView;
//取消按钮
@property (nonatomic , strong) LTSheetFoot *footView;
//间隔
@property (nonatomic , strong) UIView *marginView;
//contentView高度
@property (nonatomic , assign) CGFloat contentVH;
//contentView的Y坐标
@property (nonatomic , assign) CGFloat contentVieLT;
//footView的Y坐标
@property (nonatomic , assign) CGFloat footVieLT;
//数据源
@property (nonatomic , strong) NSArray *dataSource;
//样式
@property (nonatomic , assign) LTSheetStyle sheetStyle;
//block
@property (nonatomic , assign) SelectIndexBlock selectBlock;

@end

@implementation LTActionSheet

- (instancetype)initWithTitle:(NSString *)title style:(LTSheetStyle)style itemTitles:(NSArray *)itemTitles{
    
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
        self.footView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetFoot class]) owner:self options:nil].lastObject;
        [self addSubview:self.footView];
        //items
        self.sheetView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetView class]) owner:self options:nil].lastObject;
        self.sheetView.dataSource = self.dataSource;
        self.sheetView.delegate = self;
        self.sheetView.cellHeight = kCellH;
        [self.contentView addSubview:self.sheetView];
        
        
        //判断选择的类型
        if (style == LTSheetStyleDefault) {
            self = [self updateDefaultStyleWithItems:itemTitles title:title selfView:self];
            [self pushDefaultStyleSheetView];
        }else if (style == LTSheetStyleWeiChat){
            //微信样式
            self = [self upWeiChatStyeWithItems:itemTitles title:title selfView:self];
            [self pushDefaultStyleSheetView];
            
        }else if (style == LTSheetStyleTable){
            //列表样式,待开发
            self = [self upTableStyeWithItems:itemTitles title:title selfView:self];
            [self pushTableStyeSheetView];
        }
        
    }
    return self;
}
#pragma mark - 初始化默认样式
- (id)updateDefaultStyleWithItems:(NSArray *)items title:(NSString *)title selfView:(LTActionSheet *)selfView
{
    //半透明按钮
    [selfView.bgBtn addTarget:selfView action:@selector(dismissDefaulfSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgBtn.frame = CGRectMake(0, 0, kWW, kWH);
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetHead class]) owner:selfView options:nil].lastObject;
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
    selfView.footVieLT = kWH - kCellH - kMargin;
    //初始设置在界面外
    selfView.footView.frame = CGRectMake(kMargin, kWH + selfView.contentVH + kMargin, kMW, kCellH);
    selfView.contentVieLT = kWH - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - 2 * kMargin;
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
#pragma mark 初始化微信样式
- (id)upWeiChatStyeWithItems:(NSArray *)itemTitles title:(NSString *)title selfView:(LTActionSheet *)selfView
{
    [selfView.bgBtn addTarget:selfView action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgBtn.frame = CGRectMake(0, 0, kWW, kWH);
    [selfView.footView.cancelBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    selfView.footView.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    if ([[UIScreen mainScreen] bounds].size.height == 667) {
        selfView.footView.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:20];
    }
    else if ([[UIScreen mainScreen] bounds].size.height > 667) {
        selfView.footView.cancelBtn.titleLabel.font = [UIFont systemFontOfSize:21];
    }
    
    //中间空隙
    selfView.marginView = [[UIView alloc] init];
    selfView.marginView.backgroundColor = [UIColor colorWithRed:230/255.0 green:230/255.0 blue:230/255.0 alpha:1.0];
    selfView.marginView.alpha = 0.0;
    [selfView addSubview:selfView.marginView];
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetHead class]) owner:selfView options:nil].lastObject;
        selfView.titleView.titleLabel.text = title;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    selfView.sheetView.cellTextColor = [UIColor blackColor];
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = kWH - 200 - (kCellH + 2*kMargin);
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
        selfView.sheetView.tableView.scrollEnabled = YES;
    } else {
        selfView.sheetView.tableView.scrollEnabled = NO;
    }
    
    selfView.footVieLT = kWH - kCellH;
    selfView.footView.frame = CGRectMake(0, selfView.footVieLT + selfView.contentVH, kWW, kCellH);
    
    selfView.contentVieLT = kWH - CGRectGetHeight(selfView.footView.frame) - selfView.contentVH - kMargin;
    selfView.contentView.frame = CGRectMake(0, kWH, kWW, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kWW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kWW, sheetH);
    selfView.marginView.frame = CGRectMake(0, kWH + sheetH, kWW, kMargin);
    
    [selfView.footView.cancelBtn addTarget:self action:@selector(dismissWeiChatStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    return selfView;
}
#pragma mark 初始化Table样式
///初始化TableView样式
- (id)upTableStyeWithItems:(NSArray *)itemTitles title:(NSString *)title selfView:(LTActionSheet *)selfView
{
    if (selfView.footView) {
        [selfView.footView removeFromSuperview];
    }
    [selfView.bgBtn addTarget:selfView action:@selector(dismissTableStyeSheetView) forControlEvents:UIControlEventTouchUpInside];
    selfView.bgBtn.frame = CGRectMake(0, 0, kWW, kWH);
    
    //标题
    BOOL isTitle = NO;
    if (title.length > 0) {
        selfView.titleView = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([LTSheetHead class]) owner:selfView options:nil].lastObject;
        selfView.titleView.titleLabel.text = title;
        selfView.titleView.titleLabel.textAlignment = NSTextAlignmentCenter;
        isTitle = YES;
        [selfView.contentView addSubview:selfView.titleView];
    }
    selfView.sheetView.cellTextColor = [UIColor blackColor];
    selfView.sheetView.cellTextStyle = NSTextStyleCenter;
    selfView.sheetView.tableView.scrollEnabled = YES;
    
    //布局子控件
    int cellCount = (int)itemTitles.count;
    selfView.contentVH = kCellH * (cellCount + isTitle);
    CGFloat maxH = kWH - 100;
    if (selfView.contentVH > maxH) {
        selfView.contentVH = maxH;
    }
    
    selfView.contentVieLT = kWH - selfView.contentVH;
    selfView.contentView.frame = CGRectMake(0, kWH, kWW, selfView.contentVH);
    
    CGFloat sheetY = 0;
    CGFloat sheetH = CGRectGetHeight(selfView.contentView.frame);
    if (isTitle) {
        selfView.titleView.frame = CGRectMake(0, 0, kWW, kCellH);
        sheetY = CGRectGetHeight(selfView.titleView.frame);
        sheetH = CGRectGetHeight(selfView.contentView.frame) - CGRectGetHeight(selfView.titleView.frame);
    }
    selfView.sheetView.frame = CGRectMake(0, sheetY, kWW, sheetH);
    return selfView;
}
//显示默认的样式
- (void)pushDefaultStyleSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(kMargin, weakSelf.contentVieLT, kMW,weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(kMargin, weakSelf.footVieLT, kMW, kCellH);
        weakSelf.bgBtn.alpha = 0.35;
    }];
    
}
//显示像微信的样式
- (void)pushWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentVieLT, kWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footVieLT, kWW, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, weakSelf.footVieLT - kMargin, kWW, kMargin);
        weakSelf.bgBtn.alpha = 0.35;
        weakSelf.marginView.alpha = 1.0;
    }];
}
//显示TableView的样式
- (void)pushTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kPushTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, weakSelf.contentVieLT, kWW, weakSelf.contentVH);
        weakSelf.bgBtn.alpha = 0.35;
    }];
}
//显示
- (void)show
{
    if (_sheetStyle == LTSheetStyleDefault) {
        [self pushDefaultStyleSheetView];
    }
    else if (_sheetStyle == LTSheetStyleWeiChat) {
        [self pushWeiChatStyeSheetView];
    }
    else if (_sheetStyle == LTSheetStyleTable) {
        
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
//消失微信样式
- (void)dismissWeiChatStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kWH, kWW, weakSelf.contentVH);
        weakSelf.footView.frame = CGRectMake(0, weakSelf.footVieLT + weakSelf.contentVH, kWW, kCellH);
        weakSelf.marginView.frame = CGRectMake(0, kWH + CGRectGetHeight(weakSelf.contentView.frame) + CGRectGetHeight(weakSelf.titleView.frame), kWW, kMargin);
        weakSelf.bgBtn.alpha = 0.0;
        weakSelf.marginView.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
        [weakSelf.footView removeFromSuperview];
        [weakSelf.marginView removeFromSuperview];
        [weakSelf.bgBtn removeFromSuperview];
        [weakSelf removeFromSuperview];
    }];
}
//消失TableView样式
- (void)dismissTableStyeSheetView
{
    __weak typeof(self) weakSelf = self;
    [UIView animateWithDuration:kDismissTime animations:^{
        weakSelf.contentView.frame = CGRectMake(0, kWH, kWW, weakSelf.contentVH);
        weakSelf.bgBtn.alpha = 0.0;
    } completion:^(BOOL finished) {
        [weakSelf.contentView removeFromSuperview];
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
    
    if (_sheetStyle == LTSheetStyleDefault) {
        [self dismissDefaulfSheetView];
    }
    else if (_sheetStyle == LTSheetStyleWeiChat) {
        [self dismissWeiChatStyeSheetView];
    }
    else if (_sheetStyle == LTSheetStyleTable) {
        [self dismissTableStyeSheetView];
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
