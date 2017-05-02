//
//  WYActionSheet.h
//  WYActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import <UIKit/UIKit.h>
//block回调方法
typedef void(^SelectIndexBlock)(NSInteger index, NSString *title);
//代理方法
@protocol WYActionSheetDelegate <NSObject>
//传出索引 标题 点击按钮(tag属性之类的)
/**
 Description

 @param index 索引
 @param title 标题
 @param sender 可带属性的参数
 */
- (void)sheetViewDidSelectWithIndex:(NSInteger)index
                              title:(NSString *)title
                              sender:(id)sender;
//简单传出索引 标题
/**
 Description

 @param index 索引
 @param title 标题
 */
- (void)sheetViewDidSelectWithIndex:(NSInteger)index
                              title:(NSString *)title;

@end

typedef NS_ENUM (NSUInteger,WYSheetStyle){
    //默认样式
    WYSheetStyleDefault = 0,
    //微信样式
    WYSheetStyleWeiChat,
    //tableView样式(没有取消按钮)
    WYSheetStyleTable,
};

@interface WYActionSheet : UIView

@property (nonatomic , assign) id <WYActionSheetDelegate> delegate;
//标题颜色，默认是darkGrayColor
@property (nonatomic , strong) UIColor *titleTextColor;
//item字体颜色 默认是blueColor
@property (nonatomic , strong) UIColor *itemTextColor;
//取消按钮字体颜色 默认是blueColor
@property (nonatomic , strong) UIColor *cancelBtnTextColor;
//标题文字字体
@property (nonatomic , strong) UIFont *titleTextFont;
//item文字字体
@property (nonatomic , strong) UIFont *itemTextFont;
//取消按钮字体
@property (nonatomic , strong) UIFont *cancelTextFont;
//取消按钮字 默认是“取消”
@property (nonatomic , strong) NSString *cancelTitle;


/**
 Description

 @param title 标题
 @param style 样式
 @param itemTitles items数组
 @return return value description
 */
- (instancetype)initWithTitle:(NSString *)title style:(WYSheetStyle)style itemTitles:(NSArray *)itemTitles;

//显示
- (void)show;

/**
 Description

 @param block 通过block传值出去
 */
- (void)didFinishSelectBlock:(SelectIndexBlock)block;

@end
