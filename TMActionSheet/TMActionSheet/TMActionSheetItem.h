//
//  TMActionSheetItem.h
//  TMActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMActionSheetConfig.h"

NS_ASSUME_NONNULL_BEGIN

@interface TMActionSheetItem : NSObject

@property (nonatomic, assign) TMActionSheetType type;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIColor *tintColor;

+ (instancetype)initWithType:(TMActionSheetType)type image:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor;

@end

NS_ASSUME_NONNULL_END
