//
//  TMSheetCell.h
//  TMActionSheet
//
//  Created by wubj on 17/3/31.
//  Copyright © 2017年 wubj. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TMActionSheetConfig.h"
@class TMActionSheetItem;

@interface TMActionSheetCell : UITableViewCell

@property (nonatomic, assign) TMItemContentAlignment contentAlignment;
@property (nonatomic, strong) TMActionSheetItem *item;
@property (nonatomic, assign) BOOL hideTopLine; //!< hide topLine

@end
