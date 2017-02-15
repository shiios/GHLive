//
//  GHConstant.h
//  GHLive
//
//  Created by kalian on 2017/2/15.
//  Copyright © 2017年 kalian. All rights reserved.
//

#ifndef GHConstant_h
#define GHConstant_h

#pragma mark - Frame相关
// 屏幕宽/高
#define ALinScreenWidth  [UIScreen mainScreen].bounds.size.width
#define ALinScreenHeight [UIScreen mainScreen].bounds.size.height

#pragma mark - 颜色
// 颜色相关
#define Color(r,g,b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define KeyColor Color(216, 41, 116)

// 首页的选择器的宽度
#define Home_Seleted_Item_W 60
#define DefaultMargin       10

#endif /* GHConstant_h */
