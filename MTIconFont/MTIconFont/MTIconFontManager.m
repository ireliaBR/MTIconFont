//
//  MTIconFontManager.m
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/14.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import "MTIconFontManager.h"

// 系统库头文件
#import <CoreText/CoreText.h>

// 第三方库头文件


// 自定义模块的头文件

/**定义颜色的宏*/
#define UIColorFromRGBA(rgbValue, alpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]

static MTIconFontManager *ME;

@interface MTIconFontManager()

@property (nonatomic, copy) NSString *iconFontUrlStr;
@property (nonatomic, copy) NSString *iconFontMapFileUrlStr;

@property (nonatomic, strong) NSString *fontName;
@property (nonatomic, strong) NSDictionary *mapDict;

@property (nonatomic, strong) NSCache *iconCache;

@end

@implementation MTIconFontManager
#pragma mark - 📓Lifecycle


#pragma mark - 📔IBActions


#pragma mark - 📕Public
+ (MTIconFontManager *)manager {
    NSAssert(ME, @"MTIconFontManager not initialize");
    return ME;
}

+ (void)initializeWithIconFontUrlStr:(NSString *)iconFontUrlStr
               iconFontMapFileUrlStr:(NSString *)iconFontMapFileUrlStr {
    NSAssert(ME == nil, @"MTIconFontManager already initialize");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ME = [MTIconFontManager new];
        ME.iconFontUrlStr = iconFontUrlStr;
        ME.iconFontMapFileUrlStr = iconFontMapFileUrlStr;
        ME.fontName = [iconFontUrlStr.lastPathComponent componentsSeparatedByString:@"."].firstObject;
        ME.mapDict = [[NSDictionary alloc] initWithContentsOfFile:iconFontMapFileUrlStr];
    });
}

- (UIImage *)iconWithIconName:(NSString *)iconName
                         size:(CGFloat)size
                     colorRGB:(NSInteger)colorRGB
                        alpha:(CGFloat)alpha {
    UIImage *image = [self valueForIconName:iconName size:size colorRGB:colorRGB alpha:alpha];
    if (image != nil) {
        return image;
    }
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    UIFont *font = [self fontWithSize:realSize];
    UIGraphicsBeginImageContext(CGSizeMake(realSize, realSize));
    NSString *code = [self codeWithIconName:iconName];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if ([code respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [code drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:UIColorFromRGBA(colorRGB, alpha)}];
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, UIColorFromRGBA(colorRGB, alpha).CGColor);
        [code drawAtPoint:CGPointMake(0, 0) withFont:font];
#pragma clang pop
    }
    
    image = [UIImage imageWithCGImage:UIGraphicsGetImageFromCurrentImageContext().CGImage scale:scale orientation:UIImageOrientationUp];
    [self setImage:image forIconName:iconName size:size colorRGB:colorRGB alpha:alpha];
    UIGraphicsEndImageContext();
    
    return image;
}

#pragma mark - 📗Private
/**
 注册URL对应的字体文件

 @param url 字体文件URL
 */
- (void)registerFontWithURL:(NSURL *)url {
    NSAssert([[NSFileManager defaultManager] fileExistsAtPath:[url path]], @"Font file doesn't exist， path %@", url.path);
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
}


/**
 获取对应尺寸的font

 @param size 尺寸
 @return 字体
 */
- (UIFont *)fontWithSize:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:self.fontName size:size];
    if (font == nil) {
        [self registerFontWithURL:[NSURL fileURLWithPath:self.iconFontUrlStr]];
        font = [UIFont fontWithName:[self fontName] size:size];
        NSAssert(font, @"UIFont object should not be nil, check if the font file is added to the application bundle and you're using the correct font name.");
    }
    return font;
}

/**
 通过iconName获取映射文件中code的值

 @param iconName iconName
 @return code
 */
- (NSString *)codeWithIconName:(NSString *)iconName {
    NSString *code = self.mapDict[iconName];
    NSAssert([code isKindOfClass:NSString.class], @"code: %@ 不是字符串", code);
    code = [self replaceUnicode:code];
    if (code == nil) {
        code = iconName;
    }
    return code;
}


/**
 unicode字符串 转unicode

 @param unicodeStr unicodeStr
 @return unicode
 */
- (NSString *)replaceUnicode:(NSString *)unicodeStr
{
    
    NSString *tempStr1 = [unicodeStr stringByReplacingOccurrencesOfString:@"\\u"withString:@"\\U"];
    NSString *tempStr2 = [tempStr1 stringByReplacingOccurrencesOfString:@"\""withString:@"\\\""];
    NSString *tempStr3 = [[@"\""stringByAppendingString:tempStr2] stringByAppendingString:@"\""];
    NSData *tempData = [tempStr3 dataUsingEncoding:NSUTF8StringEncoding];
    NSString* returnStr = [NSPropertyListSerialization propertyListFromData:tempData
                                                           mutabilityOption:NSPropertyListImmutable
                                                                     format:NULL
                                                           errorDescription:NULL];
    return [returnStr stringByReplacingOccurrencesOfString:@"\\r\\n"withString:@"\n"];
}

- (void)setImage:(UIImage *)image
     forIconName:(NSString *)iconName
            size:(CGFloat)size
        colorRGB:(NSInteger)colorRGB
           alpha:(CGFloat)alpha {
    NSString *key = [NSString stringWithFormat:@"%@_%f_%ld_%f", iconName, size, (long)colorRGB, alpha];
    [self.iconCache setObject:image forKey:key];
}

- (id)valueForIconName:(NSString *)iconName
                  size:(CGFloat)size
              colorRGB:(NSInteger)colorRGB
                 alpha:(CGFloat)alpha {
    NSString *key = [NSString stringWithFormat:@"%@_%f_%ld_%f", iconName, size, (long)colorRGB, alpha];
    return [self.iconCache objectForKey:key];
}

#pragma mark - 📘Protocol conformance


#pragma mark - 📙Custom Accessors
- (NSCache *)iconCache {
    if (!_iconCache) {
        _iconCache = [NSCache new];
    }
    return _iconCache;
}
@end
