//
//  TMActionSheetConfig.h
//  TMActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "UIColor+TMExtension.h"

UIKIT_EXTERN CGFloat const TMActionSheetItemTitleFontSize;
UIKIT_EXTERN CGFloat const TMActionSheetItemContentSpacig;
UIKIT_EXTERN CGFloat const TMActionSheetTitleKernSpacing;
UIKIT_EXTERN CGFloat const TMActionSheetTitleLineSpacing;
UIKIT_EXTERN CGFloat const TMActionSheetRowHeight;
UIKIT_EXTERN CGFloat const TMActionSheetContentMaxScale;
UIKIT_EXTERN CGFloat const TMActionSheetDefaultMargin;
UIKIT_EXTERN CGFloat const TMActionSheetSectionMargin;

UIKIT_EXTERN NSString * const TMActionSheetBackColor;
UIKIT_EXTERN NSString * const TMActionSheetItemNormalColor;
UIKIT_EXTERN NSString * const TMActionSheetItemHighlightColor;
UIKIT_EXTERN NSString * const TMActionSheetTitleColor;
UIKIT_EXTERN NSString * const TMActionSheetRowNormalColor;
UIKIT_EXTERN NSString * const TMActionSheetRowHighlightColor;
UIKIT_EXTERN NSString * const TMActionSheetRowTopLineColor;

//!< 内容偏移枚举
typedef NS_ENUM(NSUInteger, TMItemContentAlignment) {
    TMItemContentAlignmentLeft         = 0, //!< 内容在左侧
    TMItemContentAlignmentCenter          , //!< 内容在中间
    TMItemContentAlignmentRight           , //!< 内容在右侧
};

//!< 高亮选项枚举
typedef NS_ENUM(NSUInteger, TMActionSheetType) {
    TMActionSheetTypeNormal,    //!< 正常
    TMActionSheetTypeHighlight  //!< 高亮
};

typedef void(^TMActionSheetHandle)(NSInteger selectedIndex, NSString *title);
