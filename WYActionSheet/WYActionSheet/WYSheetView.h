//
//  WYSheetView.h
//  WYActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import <UIKit/UIKit.h>
//代理方法
@protocol WYSheetViewDelegate <NSObject>

- (void)selectWithIndex:(NSInteger)index title:(NSString *)title;

@end

typedef NS_ENUM(NSUInteger , NSCellTextStyle){
    NSTextStyleCenter = 0,    ///cell文字默认样式居中
    NSTextStyleLeft,          ///cell文字样式居左
    NSTextStyleRight,         ///cell文字样式居右
};

@interface WYSheetView : UIView <UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , strong) NSArray *dataSource;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic , assign) CGFloat cellHeight;
@property (nonatomic , strong) UIColor *cellTextColor;
@property (nonatomic , strong) UIFont *cellTextFont;
@property (nonatomic , assign) NSCellTextStyle cellTextStyle;
@property (nonatomic , assign) id <WYSheetViewDelegate> delegate;


@end
