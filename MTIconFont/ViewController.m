//
//  ViewController.m
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/14.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import "ViewController.h"

// 系统库头文件
#import <CoreText/CoreText.h>

// 第三方库头文件


// 自定义模块的头文件
#import "MTIconFont.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController
#pragma mark - 📓Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self register];
    [self addImage];

}

#pragma mark - 📔IBActions

#pragma mark - 📕Public

#pragma mark - 📗Private
- (void)addImage {
    
    // 1. 使用指定字体生成图片
    self.iconImageView.image = [UIImage imageWithFontName:@"icomoon" iconName:@"12 34 56" size:50 colorRGB:0x4a4a4a alpha:1];
    
    // 2. 使用默认字体iconfont，或者初始化的字体。PS：如果未初始化，则会自动初始化iconfont字体
    self.imageView.image = [UIImage imageWithIconName:@"icon_one" size:50 colorRGB:0x4a4a4a alpha:1];
    
    // 3. 使用/的表达式生成图片
    [self.btn setImage:[UIImage imageNormalIconName:@"icon_aaa/50/0x7bc610"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageHighlightedIconName:@"icon_four/50/0x7bc610"] forState:UIControlStateHighlighted];
}

- (void)register {
    
    /// 初始化
    NSString *iconFontUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.ttf"];
    NSString *iconFontMapFileUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.plist"];
    [MTIconFontManager initializeWithIconFontUrlStr:iconFontUrlStr iconFontMapFileUrlStr:iconFontMapFileUrlStr];
    
    // 注册水印
    NSString *waterMarkUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"icomoon.ttf"];
    [MTIconFontManager.manager registerWithFontPath:waterMarkUrlStr plistPath:@""];
}

#pragma mark - 📘Protocol conformance


#pragma mark - 📙Custom Accessors

@end
