//
//  LayerHelp.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/12.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "LayerHelp.h"

@implementation LayerHelp

// 阴影
+ (void)showShadowRadius:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize *)shadowOffset{
    view.layer.shadowOpacity = shadowOpacity;// 阴影透明度
    view.layer.shadowColor = shadowColor.CGColor;// 阴影的颜色
    view.layer.shadowRadius = shadowRadius;// 阴影扩散的范围控制
    view.layer.shadowOffset = *(shadowOffset);// 阴影的范围
}

// 圆角
+ (void)showCornerRadius:(UIView *)view cornerRadius:(CGFloat)cornerRadius{
    view.layer.masksToBounds = YES;
    view.layer.cornerRadius = cornerRadius;
}

// 边框
+ (void)showBorderWidth:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth{
    view.layer.borderColor = borderColor.CGColor;//边框颜色
    view.layer.borderWidth = borderWidth;//边框宽度
}

@end
