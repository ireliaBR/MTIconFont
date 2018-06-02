//
//  MTIconFontManager.h
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/14.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTIconFontManager : NSObject
@property (nonatomic, strong, class, readonly) MTIconFontManager *manager;
@property (nonatomic, copy, readonly) NSString *defaultFontName;

/**
 iconFont初始化

 @param iconFontUrlStr iconFont文件位置
 @param iconFontMapFileUrlStr iconFont映射文件位置
 */
+ (void)initializeWithIconFontUrlStr:(nonnull NSString *)iconFontUrlStr
               iconFontMapFileUrlStr:(nonnull NSString *)iconFontMapFileUrlStr;

/**
 注册一个矢量图字体文件

 @param fontPath 字体文件位置
 @param plistPath 映射文件位置
 */
- (void)registerWithFontPath:(nonnull NSString *)fontPath
                   plistPath:(nonnull NSString *)plistPath;

/**
 通过fontName, iconName，size，color获取iconfont中的图片

 @param fontName fontName
 @param iconName iconName
 @param size size
 @param colorRGB colorRGB 0xffffff
 @param alpha alpha  0~1
 @return icon
 */
- (UIImage *)iconWithFontName:(NSString*)fontName
                     iconName:(nonnull NSString *)iconName
                         size:(CGFloat)size
                     colorRGB:(NSInteger)colorRGB
                        alpha:(CGFloat)alpha;


/**
 通过iconName，size，color获取默认字体中的图片
 
 @param iconName iconName
 @param size size
 @param colorRGB colorRGB 0xffffff
 @param alpha alpha  0~1
 @return icon
 */
- (UIImage *)iconWithIconName:(nonnull NSString *)iconName
                         size:(CGFloat)size
                     colorRGB:(NSInteger)colorRGB
                        alpha:(CGFloat)alpha;
@end
