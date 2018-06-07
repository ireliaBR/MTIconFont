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
#import "MTFontModel.h"

/**定义颜色的宏*/
#define UIColorFromRGBA(rgbValue, alpha) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:alpha]

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1]

#ifdef DEBUG
#define MTLog(fmt, ...)  NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define MTLog(fmt, ...)
#endif

static MTIconFontManager *ME;

@interface MTIconFontManager()

@property (nonatomic, copy) NSString *defaultFontName;
@property (nonatomic, strong) NSMutableArray<MTFontModel*> *fonts;
@property (nonatomic, strong) NSCache *iconCache;

@end

@implementation MTIconFontManager
#pragma mark - 📓Lifecycle


#pragma mark - 📔IBActions


#pragma mark - 📕Public
+ (MTIconFontManager *)manager {
    if (ME == nil) {
        @synchronized (self) {
            if (ME == nil) {
                ME = [MTIconFontManager new];
                ME.defaultFontName = @"iconfont";
                
                NSString *iconFontUrlStr = [[NSBundle mainBundle] URLForResource:ME.defaultFontName withExtension:@"ttf"].path;
                NSString *iconFontMapFileUrlStr = [[NSBundle mainBundle] URLForResource:ME.defaultFontName withExtension:@"plist"].path;
                
                [ME registerWithFontPath:iconFontUrlStr plistPath:iconFontMapFileUrlStr];
            }
        }
    }
    return ME;
}

+ (void)initializeWithIconFontUrlStr:(NSString *)iconFontUrlStr
               iconFontMapFileUrlStr:(NSString *)iconFontMapFileUrlStr {
    NSAssert(ME == nil, @"MTIconFontManager already initialize");
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        ME = [MTIconFontManager new];
        NSString *fontName = [iconFontUrlStr.lastPathComponent componentsSeparatedByString:@"."].firstObject;
        ME.defaultFontName = fontName;
        [ME registerWithFontPath:iconFontUrlStr plistPath:iconFontMapFileUrlStr];
    });
}

/**
 注册字体文件
 
 @param fontPath 字体文件位置
 @param plistPath 映射文件位置
 */
- (void)registerWithFontPath:(NSString *)fontPath plistPath:(NSString *)plistPath {
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSAssert([fileManager fileExistsAtPath:fontPath], @"字体文件位置%@, 不存在", fontPath);
    
    NSString *fontName = [fontPath.lastPathComponent componentsSeparatedByString:@"."].firstObject;
    for (MTFontModel *fontModel in self.fonts) {
        NSCAssert(![fontModel.fontName isEqualToString:fontName], @"fontName: %@, 已经注册", fontName);
    }
    BOOL isSuccess = [self registerFontWithURL:[NSURL fileURLWithPath:fontPath]];
    NSCAssert(isSuccess, @"fontName: %@, 注册失败", fontName);
    
    MTFontModel *fontModel = [MTFontModel new];
    fontModel.fontName = fontName;
    
    if ([fileManager fileExistsAtPath:plistPath] && isSuccess) {
        fontModel.mapDict = [self registerPlistWithPath:plistPath];
    }
    
    [self.fonts addObject:fontModel];
}

- (UIImage *)iconWithIconName:(NSString *)iconName
                         size:(CGFloat)size
                     colorRGB:(NSInteger)colorRGB
                        alpha:(CGFloat)alpha {
    return [self iconWithFontName:self.defaultFontName
                  iconName:iconName
                      size:size
                  colorRGB:colorRGB
                     alpha:alpha];
}

- (UIImage *)iconWithFontName:(NSString *)fontName
                     iconName:(NSString *)iconName
                         size:(CGFloat)size
                     colorRGB:(NSInteger)colorRGB
                        alpha:(CGFloat)alpha {
    UIImage *image = [self valueForFontName:fontName iconName:iconName size:size colorRGB:colorRGB alpha:alpha];
    if (image != nil) {
        return image;
    }
    
    MTFontModel *fontModel = nil;
    for (MTFontModel *model in self.fonts) {
        if ([model.fontName isEqualToString:fontName]) {
            fontModel = model;
            break;
        }
    }
    NSAssert(fontModel != nil, @"fontName: %@, 未注册", fontName);
    
    CGFloat scale = [UIScreen mainScreen].scale;
    CGFloat realSize = size * scale;
    UIFont *font = [self fontWithName:fontModel.fontName size:realSize];
    NSString *code = [self codeWithMapDict:fontModel.mapDict IconName:iconName];
    CGRect rect = [code boundingRectWithSize:CGSizeMake(MAXFLOAT, size) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetAlpha(context, alpha);
    if ([code respondsToSelector:@selector(drawAtPoint:withAttributes:)]) {
        /**
         * 如果这里抛出异常，请打开断点列表，右击All Exceptions -> Edit Breakpoint -> All修改为Objective-C
         * See: http://stackoverflow.com/questions/1163981/how-to-add-a-breakpoint-to-objc-exception-throw/14767076#14767076
         */
        [code drawAtPoint:CGPointZero withAttributes:@{NSFontAttributeName:font, NSForegroundColorAttributeName:UIColorFromRGB(colorRGB)}];
    } else {
        
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"
        CGContextSetFillColorWithColor(context, UIColorFromRGB(colorRGB).CGColor);
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
 获取对应尺寸的font

 @param fontName 字体名字
 @param size 尺寸
 @return 字体
 */
- (UIFont *)fontWithName:(NSString *)fontName
                    size:(CGFloat)size {
    UIFont *font = [UIFont fontWithName:fontName size:size];
    return font;
}

/**
 通过iconName获取映射文件中code的值

 @param mapDict mapDict
 @param iconName iconName
 @return code
 */
- (NSString *)codeWithMapDict:(NSDictionary *)mapDict
                     IconName:(NSString *)iconName {
    NSString *code = mapDict[iconName];
//    NSAssert([code isKindOfClass:NSString.class], @"code: %@ 不是字符串", code);
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
    if (unicodeStr == nil) {
        return nil;
    }
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

- (id)valueForFontName:(NSString *)fontName
              iconName:(NSString *)iconName
                  size:(CGFloat)size
              colorRGB:(NSInteger)colorRGB
                 alpha:(CGFloat)alpha {
    NSString *key = [NSString stringWithFormat:@"%@_%@_%f_%ld_%f", fontName, iconName, size, (long)colorRGB, alpha];
    return [self.iconCache objectForKey:key];
}

/**
 注册URL对应的字体文件
 
 @param url 字体文件URL
 */
- (BOOL)registerFontWithURL:(NSURL *)url {
    BOOL isSuccess = NO;
    
    CGDataProviderRef fontDataProvider = CGDataProviderCreateWithURL((__bridge CFURLRef)url);
    CGFontRef newFont = CGFontCreateWithDataProvider(fontDataProvider);
    CGDataProviderRelease(fontDataProvider);
    isSuccess = CTFontManagerRegisterGraphicsFont(newFont, nil);
    CGFontRelease(newFont);
    return isSuccess;
}

/**
 解析映射文件

 @param path 映射文件路径
 */
- (NSDictionary *)registerPlistWithPath:(NSString *)path {
    NSMutableDictionary<NSString *, NSString *> *mapDict = [NSMutableDictionary new];
    NSDictionary<NSString *, id> *dict = [[NSDictionary alloc] initWithContentsOfFile:path];
    [self parseDictWithDict:dict mapDict:mapDict];
    return [mapDict copy];
}

- (void)parseDictWithDict:(NSDictionary<NSString *, id> *)dict mapDict:(NSMutableDictionary<NSString *, NSString *> *)mapDict {
    for (NSString *key in dict.allKeys) {
        id value = dict[key];
        if ([value isKindOfClass:NSString.class]) {
            mapDict[key] = value;
            continue;
        }
        
        if ([value isKindOfClass:NSDictionary.class]) {
            [self parseDictWithDict:value mapDict:mapDict];
            continue;
        }
    }
}
#pragma mark - 📘Protocol conformance


#pragma mark - 📙Custom Accessors
- (NSCache *)iconCache {
    if (!_iconCache) {
        _iconCache = [NSCache new];
    }
    return _iconCache;
}

- (NSMutableArray<MTFontModel *> *)fonts {
    if (!_fonts) {
        _fonts = [NSMutableArray new];
    }
    return _fonts;
}
@end

#undef UIColorFromRGBA
#undef UIColorFromRGB
