//
//  LayerHelp.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/12.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LayerHelp : NSObject

// 阴影
+ (void)showShadowRadius:(UIView *)view shadowOpacity:(CGFloat)shadowOpacity shadowColor:(UIColor *)shadowColor shadowRadius:(CGFloat)shadowRadius shadowOffset:(CGSize *)shadowOffset;

// 圆角
+ (void)showCornerRadius:(UIView *)view cornerRadius:(CGFloat)cornerRadius;

// 边框
+ (void)showBorderWidth:(UIView *)view borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;

@end
