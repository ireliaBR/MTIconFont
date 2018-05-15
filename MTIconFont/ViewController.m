//
//  ViewController.m
//  MTIconFont
//
//  Created by 范冬冬 on 2018/5/14.
//  Copyright © 2018年 meitu. All rights reserved.
//

#import "ViewController.h"

// 系统库头文件


// 第三方库头文件


// 自定义模块的头文件
#import "MTIconFont.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ViewController
#pragma mark - 📓Lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    /// 初始化
    NSString *iconFontUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.ttf"];
    NSString *iconFontMapFileUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.plist"];
    [MTIconFontManager initializeWithIconFontUrlStr:iconFontUrlStr iconFontMapFileUrlStr:iconFontMapFileUrlStr];

    /// 获取图片
    self.iconImageView.image = [UIImage imageNormalIconName:@"icon_two/80/0x4a4a4a"];
    [self.btn setImage:[UIImage imageNormalIconName:@"icon_four/50/0x7bc610"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageHighlightedIconName:@"icon_four/50/0x7bc610"] forState:UIControlStateNormal];
}

#pragma mark - 📔IBActions

#pragma mark - 📕Public


#pragma mark - 📗Private


#pragma mark - 📘Protocol conformance


#pragma mark - 📙Custom Accessors

@end
