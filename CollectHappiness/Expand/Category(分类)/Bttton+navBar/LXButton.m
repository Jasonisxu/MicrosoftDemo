//
//  LXButton.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/18.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "LXButton.h"

@implementation LXButton

-(id)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        [self addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

-(void)btnClick:(LXButton *)button
{
    //作用: 原来被点击执行target-action对应的方法
    //现在: 判断action是否已经设置block, 如果被设置, 执行block
    if(self.action)
    {
        self.action(button);
    }
}



@end
