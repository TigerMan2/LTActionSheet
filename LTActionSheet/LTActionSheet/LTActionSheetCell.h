//
//  LTSheetCell.h
//  LTActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LTActionSheetConfig.h"
@class LTActionSheetItem;

@interface LTActionSheetCell : UITableViewCell

@property (nonatomic, assign) LTItemContentAlignment contentAlignment;
@property (nonatomic, strong) LTActionSheetItem *item;
@property (nonatomic, assign) BOOL hideTopLine; //!< hide topLine

@end
