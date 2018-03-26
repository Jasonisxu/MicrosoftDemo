//
//  UIImageView+Image.m
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/10.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import "UIImageView+Image.h"

@implementation UIImageView (Image)

- (void)LX_setImageWithUrlString:(NSString *)urlString placeholderImgName:(NSString *)placeholderString {
    NSURL *url = [NSURL URLWithString:urlString];
    if (url == nil) {
        NSLog(@"urlString不合法");
        [self setImage:GetImage(placeholderString)];
        return;
    }
    [self sd_setImageWithURL:url placeholderImage:GetImage(placeholderString)];
}

@end
