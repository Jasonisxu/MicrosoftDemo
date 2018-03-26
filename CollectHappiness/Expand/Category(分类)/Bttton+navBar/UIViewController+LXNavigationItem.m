//
//  UIViewController+LXNavigationItem.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/18.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "UIViewController+LXNavigationItem.h"

@implementation UIViewController (LXNavigationItem)

- (id)setLeftImageBarButtonItemImage:(NSString *)image action:(void(^)(LXButton *button))action
{
    LXButton *leftButton = [LXButton buttonWithType:UIButtonTypeCustom];
    [leftButton setFrame:CGRectMake(0, 0, 40, 40)];
//    [leftButton setImage:[HQFontImageDictionary iconWithName:image fontSize:23 color:WHITE_COLOR] forState:UIControlStateNormal];
    [leftButton setImage:GetImage(image) forState:UIControlStateNormal];
    leftButton.action = action;
    UIBarButtonItem *leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;

    return leftButton;
}

- (id)setRightImageBarButtonItemImage:(NSString *)image action:(void(^)(LXButton *button))action
{
    LXButton *rightButton = [LXButton buttonWithType:UIButtonTypeCustom];
    [rightButton setFrame:CGRectMake(0, 0, 40, 40)];
//    [rightButton setImage:[HQFontImageDictionary iconWithName:image fontSize:23 color:WHITE_COLOR] forState:UIControlStateNormal];
    [rightButton setImage:GetImage(image) forState:UIControlStateNormal];
    rightButton.action = action;
    UIBarButtonItem *rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightBarButtonItem;
    
    return rightButton;
}

- (id)setTitleViewAction:(void(^)(LXButton *button))action
{
    LXButton *titleButton = [LXButton buttonWithType:UIButtonTypeCustom];
    [titleButton setFrame:CGRectMake(0, 0, SCREEN_WIDTH - 100, 32)];
    [titleButton setImage:[HQFontImageDictionary iconWithName:@"\U0000e632" fontSize:18 color:WHITE_COLOR] forState:UIControlStateNormal];
    [titleButton setTitle:@"  搜索" forState:UIControlStateNormal];
    [titleButton.titleLabel setFont:PFR16Font];
    titleButton.backgroundColor = rgba(0, 0, 0, 0.2f);
    titleButton.action = action;
    self.navigationItem.titleView = titleButton;
    [LayerHelp showCornerRadius:titleButton cornerRadius:3];
    
    return titleButton;
}


@end
