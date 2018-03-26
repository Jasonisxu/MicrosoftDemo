//
//  LXButton.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/18.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LXButton : UIButton
//添加点击后执行的block
@property (copy,nonatomic) void (^action)(LXButton *button);
@property (nonatomic, copy) NSString *btTittle;

@end
