//
// Created by Cator Vee on 06/09/2017.
// Copyright (c) 2017 Wicrenet_Jason. All rights reserved.
//

#import "HUD.h"
#import "MBProgressHUD+BWMExtension.h"

static MBProgressHUD *commonHUD;
static CGFloat const ShowTime = 1.5f;

@implementation HUD {
}

+ (UIView *)view:(UIView *)view {
    return view == nil ? [UIApplication sharedApplication].keyWindow : view;

}

+ (void)showLoadingToView:(UIView *)view {
    [HUD hide];
    commonHUD = [MBProgressHUD bwm_showHUDAddedTo:[self view:view] title:kBWMMBProgressHUDMsgLoading];
}

+ (void)showLoadingToView:(UIView *)view withMessage:(NSString *)title {
    [HUD hide];
    commonHUD = [MBProgressHUD bwm_showHUDAddedTo:[self view:view] title:title];
}

+ (void)showMessage:(NSString *)title toView:(UIView *)view {
    [HUD hide];
    commonHUD = [MBProgressHUD bwm_showTitle:title toView:[self view:view] hideAfter:ShowTime];
}

+ (void)showErrorMessage:(NSString *)title toView:(UIView *)view {
    [HUD hide];
    commonHUD = [MBProgressHUD bwm_showTitle:title toView:[self view:view] hideAfter:ShowTime msgType:BWMMBProgressHUDMsgTypeError];
}

+ (void)showSuccessfulMessage:(NSString *)title toView:(UIView *)view {
    [HUD hide];
    commonHUD = [MBProgressHUD bwm_showTitle:title toView:[self view:view] hideAfter:ShowTime msgType:BWMMBProgressHUDMsgTypeSuccessful];
}

+ (void)hideAnimated {
    if (commonHUD != nil) {
        [commonHUD hide:YES];
    }
}

+ (void)hide {
    if (commonHUD != nil) {
        [commonHUD hide:NO];
        commonHUD = nil;
    }
}

@end
