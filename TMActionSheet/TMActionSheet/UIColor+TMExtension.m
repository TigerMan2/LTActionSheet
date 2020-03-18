//
//  UIColor+TMExtension.m
//  TMActionSheet
//
//  Created by Luther on 2019/9/2.
//  Copyright © 2019 wubj. All rights reserved.
//

#import "UIColor+TMExtension.h"

@implementation UIColor (TMExtension)

+ (UIColor *)colorWithHexString:(NSString *)string {
    
    NSString *cString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) {
        return [UIColor clearColor];
    }
    
    // prefix
    if ([cString hasPrefix:@"0x"]) {
        cString = [cString substringFromIndex:2];
    }
    if ([cString hasPrefix:@"#"]) {
        cString = [cString substringFromIndex:1];
    }
    if ([cString length] != 6) {
        return [UIColor clearColor];
    }
    
    //for cString find RGB value
    NSRange range;
    range.location = 0;
    range.length = 2;
    
    //R,G,B
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    //scan value
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((CGFloat)r / 255.0f) green:((CGFloat)g / 255.0f) blue:((CGFloat)b / 255.0f) alpha:1.0f];
}

@end
