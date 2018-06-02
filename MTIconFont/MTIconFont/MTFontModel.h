//
//  MTFontModel.h
//  MTIconFont
//
//  Created by 范冬冬 on 2018/6/1.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MTFontModel : NSObject
/// 字体名字
@property (nonatomic, copy) NSString *fontName;
/// 映射字典
@property (nonatomic, strong) NSDictionary *mapDict;
@end
