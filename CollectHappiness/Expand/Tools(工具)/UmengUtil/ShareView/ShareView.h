//
//  ShareView.h
//  haiyibao
//
//  Created by 曹雪莹 on 2016/11/26.
//  Copyright © 2016年 韩元旭. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareView : UIView

//	点击按钮block回调
@property (nonatomic,copy) void(^buttonTapped)(NSDictionary *info);

//	头部提示文字
@property (nonatomic,copy) NSString *proStr;

//	头部提示文字的字体大小
@property (nonatomic,assign) NSInteger proFont;

//	取消按钮的颜色
@property (nonatomic,strong) UIColor *cancelBtnColor;

//	取消按钮的字体大小
@property (nonatomic,assign) NSInteger cancelBtnFont;

//	除了取消按钮其他按钮的颜色
@property (nonatomic,strong) UIColor *otherBtnColor;

//	除了取消按钮其他按钮的字体大小
@property (nonatomic,assign) NSInteger otherBtnFont;

//	设置弹窗背景蒙板灰度(0~1)
@property (nonatomic,assign) CGFloat duration;

/**
 *  初始化
 *
 *  @param shareTargets 标题数组
 *  @param operations 图片数组(如果不需要的话传空数组(@[])进来)
 *  @param title   最顶部的标题  不需要的话传@""
 *
 *  @return ShareView
 */

- (instancetype)initWithShareTargets:(NSArray *)shareTargets operations:(NSArray *)operations title:(NSString *)title;

@end
