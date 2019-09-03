//
//  LTActionSheetItem.h
//  LTActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LTActionSheetConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface LTActionSheetItem : NSObject

@property (nonatomic, assign) LTActionSheetType type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *tintColor;

+ (instancetype)initWithType:(LTActionSheetType)type image:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
