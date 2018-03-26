//
// Created by Cator Vee on 06/09/2017.
// Copyright (c) 2017 Wicrenet_Jason. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HUD : NSObject

+ (void)showLoadingToView:(UIView *)view;

+ (void)showErrorMessage:(NSString *)title toView:(UIView *)view;

+ (void)showLoadingToView:(UIView *)view withMessage:(NSString *)title;

+ (void)showMessage:(NSString *)title toView:(UIView *)view;

+ (void)showSuccessfulMessage:(NSString *)title toView:(UIView *)view;

+ (void)hideAnimated;

+ (void)hide;

@end