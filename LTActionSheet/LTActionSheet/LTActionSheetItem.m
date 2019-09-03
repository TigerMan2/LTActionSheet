//
//  LTActionSheetItem.m
//  LTActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import "LTActionSheetItem.h"

@implementation LTActionSheetItem

+ (instancetype)initWithType:(LTActionSheetType)type image:(UIImage *)image title:(NSString *)title tintColor:(UIColor *)tintColor {
    LTActionSheetItem *item = [[LTActionSheetItem alloc] init];
    item.type = type;
    item.title = title;
    item.image = image;
    item.tintColor = tintColor;
    return item;
}

@end
