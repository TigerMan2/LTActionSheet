//
//  LTActionSheetConfig.h
//  LTActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+LTExtension.h"

UIKIT_EXTERN CGFloat const LTActionSheetItemTitleFontSize;
UIKIT_EXTERN CGFloat const LTActionSheetItemContentSpacig;
UIKIT_EXTERN CGFloat const LTActionSheetTitleKernSpacing;
UIKIT_EXTERN CGFloat const LTActionSheetTitleLineSpacing;
UIKIT_EXTERN CGFloat const LTActionSheetRowHeight;
UIKIT_EXTERN CGFloat const LTActionSheetContentMaxScale;
UIKIT_EXTERN CGFloat const LTActionSheetDefaultMargin;
UIKIT_EXTERN CGFloat const LTActionSheetSectionMargin;

UIKIT_EXTERN NSString * const LTActionSheetBackColor;
UIKIT_EXTERN NSString * const LTActionSheetItemNormalColor;
UIKIT_EXTERN NSString * const LTActionSheetItemHighlightColor;
UIKIT_EXTERN NSString * const LTActionSheetTitleColor;
UIKIT_EXTERN NSString * const LTActionSheetRowNormalColor;
UIKIT_EXTERN NSString * const LTActionSheetRowHighlightColor;
UIKIT_EXTERN NSString * const LTActionSheetRowTopLineColor;

//!< 内容偏移枚举
typedef NS_ENUM(NSUInteger, LTItemContentAlignment) {
    LTItemContentAlignmentLeft         = 0, //!< 内容在左侧
    LTItemContentAlignmentCenter          , //!< 内容在中间
    LTItemContentAlignmentRight           , //!< 内容在右侧
};

//!< 高亮选项枚举
typedef NS_ENUM(NSUInteger, LTActionSheetType) {
    LTActionSheetTypeNormal,    //!< 正常
    LTActionSheetTypeHighlight  //!< 高亮
};

typedef void(^LTActionSheetHandle)(NSInteger selectedIndex, NSString *title);
