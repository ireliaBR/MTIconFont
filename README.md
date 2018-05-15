MTIconFont
-------

## 简介

IconFont是一种通过字体文件来构建纯色图的方案。更详细的介绍参见[使用IconFont减小iOS应用体积](http://johnwong.github.io/mobile/2015/04/03/using-icon-font-in-ios.html)。简单说来其目的是：

1. 减小应用体积，字体文件比图片要小
1. 图标保真缩放，解决2x/3x乃至将来nx图问题
1. 方便更改颜色大小，图片复用

局限性在于只支持纯色图，但是在扁平化的今天纯色图变得越来越多。


## 使用指南

### 必要条件
	Xcode 5
	iOS 6.0 +
	ARC enabled
	CoreText framework

### Cocoapod导入
	pod 'MTIconFont'
	
### 文件介绍
1. `iconfont.ttf` 用于存储图标的字体文件
2. `iconfont.plist` 用于映射文件名和unicode的关系，例如 `icon_one = \ue601` 。使用映射文件使得代码图标名字可读性高。

### 使用

```objc
	
#import <MTIconFont/MTIconFont.h>

	/// MTIconFontManager初始化， 设置iconfont路径和plist映射表路径
    NSString *iconFontUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.ttf"];
    NSString *iconFontMapFileUrlStr = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"iconfont.plist"];
    [MTIconFontManager initializeWithIconFontUrlStr:iconFontUrlStr iconFontMapFileUrlStr:iconFontMapFileUrlStr];

    /// 获取图片
    self.iconImageView.image = [UIImage imageNormalIconName:@"icon_two/80/0x4a4a4a"];
    [self.btn setImage:[UIImage imageNormalIconName:@"icon_four/50/0x7bc610"] forState:UIControlStateNormal];
    [self.btn setImage:[UIImage imageHighlightedIconName:@"icon_four/50/0x7bc610"] forState:UIControlStateNormal];
```

### python脚本
可通过映射文件 `iconfont.plist` 生成映射网页

1. 执行脚本，设置plist路径

```objc
	cd MTIconFont
	./iconfontParse.py ../iconfont.plist
```

2. 将生成的 `iconfont.html` 放入设计给的iconfont文件夹内，打开网页

![preview](./Docs/preview.png)

3. 页面展示

![preview](./Docs/preview2.png)
 
## 结语
> 您的star，是我前进的动力^_^

