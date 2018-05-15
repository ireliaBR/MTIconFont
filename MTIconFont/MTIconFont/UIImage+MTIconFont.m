//
//  UIImage+MTIconFont.m
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/15.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import "UIImage+MTIconFont.h"

// 系统库头文件


// 第三方库头文件


// 自定义模块的头文件
#import "MTIconFontManager.h"


@implementation UIImage (MTIconFont)
#pragma mark - 📓Lifecycle


#pragma mark - 📔IBActions


#pragma mark - 📕Public
+ (UIImage *)imageIconName:(NSString *)iconName
                      size:(CGFloat)size
                  colorRGB:(NSInteger)colorRGB
                     alpha:(CGFloat)alpha {
    return [MTIconFontManager.manager iconWithIconName:iconName size:size colorRGB:colorRGB alpha:alpha];
}

+ (UIImage *)imageNormalIconName:(NSString *)iconName {
    NSAssert([self isIconNamePerdicateWithIconName:iconName], @"iconName: %@, 格式不正确", iconName);
    NSArray<NSString *> *strs = [iconName componentsSeparatedByString:@"/"];
    
    NSString *name = strs[0];
    CGFloat size = [strs[1] floatValue];
    NSInteger colorRGB = [self numberWithHexString:strs[2]];
    return [MTIconFontManager.manager iconWithIconName:name size:size colorRGB:colorRGB alpha:1];
}

+ (UIImage *)imageHighlightedIconName:(NSString *)iconName {
    NSAssert([self isIconNamePerdicateWithIconName:iconName], @"iconName: %@, 格式不正确", iconName);
    NSArray<NSString *> *strs = [iconName componentsSeparatedByString:@"/"];
    
    NSString *name = strs[0];
    CGFloat size = [strs[1] floatValue];
    NSInteger colorRGB = [self numberWithHexString:strs[2]];
    return [MTIconFontManager.manager iconWithIconName:name size:size colorRGB:colorRGB alpha:0.6];
}
#pragma mark - 📗Private

/**
 iconName字符串正则校验

 @param iconName iconName
 @return BOOL
 */
///^[a-zA-Z\_]*/[\d]*/0x[0-9a-fA-F]{6}&
+ (BOOL)isIconNamePerdicateWithIconName:(NSString *)iconName {
    NSString *iconNameRegex = @"^[a-zA-Z\\_]*/\\d*/0x[0-9a-fA-F]{6}";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", iconNameRegex];
    return [predicate evaluateWithObject:iconName];
}

/**
 十六进制字符串转数字

 @param hexString 十六进制字符串
 @return 数字
 */
+ (NSInteger)numberWithHexString:(NSString *)hexString{
    const char *hexChar = [hexString cStringUsingEncoding:NSUTF8StringEncoding];
    int hexNumber;
    sscanf(hexChar, "%x", &hexNumber);
    return (NSInteger)hexNumber;
}

#pragma mark - 📘Protocol conformance


#pragma mark - 📙Custom Accessors
@end
