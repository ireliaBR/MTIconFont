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

/**
 iconFont初始化

 @param iconFontUrlStr iconFont文件位置
 @param iconFontMapFileUrlStr iconFont映射文件位置
 */
+ (void)initializeWithIconFontUrlStr:(nonnull NSString *)iconFontUrlStr
               iconFontMapFileUrlStr:(nonnull NSString *)iconFontMapFileUrlStr;

/**
 通过iconName，size，color获取iconfont中的图片

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
