//
//  TMActionSheetItem.m
//  TMActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import "TMActionSheetItem.h"

@implementation TMActionSheetItem

+ (instancetype)initWithType:(TMActionSheetType)type image:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor {
    TMActionSheetItem *item = [[TMActionSheetItem alloc] init];
    item.type = type;
    item.title = title;
    item.image = image;
    item.tintColor = tintColor;
    return item;
}

@end
