//
//  UIImage+MTIconFont.h
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/15.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MTIconFont)

/**
 获取iconfont中的icon

 @param iconName 图标名字，可以是名字或unicode
 @param size 图标大小
 @param colorRGB 图标颜色 0xffffff
 @param alpha 透明度 0~1
 @return 图片
 */
+ (UIImage *)imageIconName:(nonnull NSString *)iconName
                      size:(CGFloat)size
                  colorRGB:(NSInteger)colorRGB
                     alpha:(CGFloat)alpha;

/**
 获取iconfont中的normal icon
 alpha默认为1

 @param iconName 名字、size、colorRGB的组合，格式必须为icon_name/30/0x4a4a4a
 @return 图片
 */
+ (UIImage *)imageNormalIconName:(nonnull NSString *)iconName;

/**
 获取iconfont中的normal icon
 alpha默认为0.6
 
 @param iconName 名字、size、colorRGB的组合，格式必须为icon_name/30/0x4a4a4a
 @return 图片
 */
+ (UIImage *)imageHighlightedIconName:(nonnull NSString *)iconName;
@end
