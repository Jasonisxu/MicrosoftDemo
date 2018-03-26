//
//  UIViewController+LXNavigationItem.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/18.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LXButton.h"

@interface UIViewController (LXNavigationItem)
/** nav左边按钮 **/
- (id)setLeftImageBarButtonItemImage:(NSString *)image action:(void(^)(LXButton *button))action;

/** nav右边按钮 **/
- (id)setRightImageBarButtonItemImage:(NSString *)image action:(void(^)(LXButton *button))action;

/** nav中间按钮 **/
- (id)setTitleViewAction:(void(^)(LXButton *button))action;

@end
