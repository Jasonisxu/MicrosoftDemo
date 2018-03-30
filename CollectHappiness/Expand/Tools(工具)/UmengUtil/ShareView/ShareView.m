//
//  ShareView.m
//  haiyibao
//
//  Created by 曹雪莹 on 2016/11/26.
//  Copyright © 2016年 韩元旭. All rights reserved.
//

#import "ShareView.h"
#import "ImageWithLabel.h"
#import "POP.h"

#define ScreenWidth            [[UIScreen mainScreen] bounds].size.width
#define ScreenHeight        [[UIScreen mainScreen] bounds].size.height
#define SHAREVIEW_BGCOLOR   [UIColor colorWithRed:1.00f green:1.00f blue:1.00f alpha:1]
#define WINDOW_COLOR        [UIColor colorWithRed:0 green:0 blue:0 alpha:0.4]
#define ANIMATE_DURATION    0.25f
#define LINE_HEIGHT         74
#define BUTTON_HEIGHT       44
#define SHEET_HEIGHT        88
#define NORMAL_SPACE        7
#define LABEL_HEIGHT        45

@interface ShareView ()

//    所有标题
@property (nonatomic, strong) NSArray  *shareTargets;
//    所有图片
@property (nonatomic, strong) NSArray  *operations;
//    整个底部分享面板的 backgroundView
@property (nonatomic, strong) UIView   *bgView;
//    分享面板取消按钮上部的 View
@property (nonatomic, strong) UIView   *topSheetView;
//    取消按钮
@property (nonatomic, strong) UIButton *cancelBtn;
//    头部提示文字Label
@property (nonatomic, strong) UILabel  *proLbl;
//    头部提示文字
@property (nonatomic, copy)   NSString *protext;
//    所有的分享按钮
@property (nonatomic, copy) NSMutableArray *buttons;

@end

@implementation ShareView

- (instancetype)initWithShareTargets:(NSArray *)shareTargets operations:(NSArray *)operations title:(NSString *)title {
    self = [super init];
    if (self) {
        _shareTargets = shareTargets;
        _operations = operations;
        _protext = title;
        
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        //    背景，带灰度
        self.backgroundColor = WINDOW_COLOR;
        //    可点击
        self.userInteractionEnabled = YES;
        //    点击背景，收起底部分享面板，移除本视图
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tappedCancel)];
        [self addGestureRecognizer:tapGesture];
        
        //    加载分享面板
        [self loadUIConfig];
    }
    return self;
}

/**
 加载自定义视图，按钮的tag依次为（200 + i）
 */
- (void)loadUIConfig {
    [self addSubview:self.bgView];
    [self.bgView addSubview:self.topSheetView];
    [self.bgView addSubview:self.cancelBtn];
    
    self.proLbl.text = _protext;
    
    static CGFloat btnWidth = 70;
    static CGFloat btnHeight = 80;
    static CGFloat btnGap = 2;
    static CGFloat btnMarginX = 16;
    
    // 分享按钮
    UIScrollView *shareTargetScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, LABEL_HEIGHT - 5, CGRectGetWidth(self.topSheetView.bounds), SHEET_HEIGHT)];
    shareTargetScrollView.showsHorizontalScrollIndicator = NO;
    shareTargetScrollView.showsVerticalScrollIndicator = NO;
    shareTargetScrollView.contentSize = CGSizeMake(MAX((btnWidth + btnGap) * self.shareTargets.count + btnMarginX * 2, CGRectGetWidth(shareTargetScrollView.bounds) + 1), SHEET_HEIGHT);
    for (int i = 0; i < self.shareTargets.count; ++i) {
        NSDictionary *shareTarget = self.shareTargets[i];
        CGRect frame = CGRectMake(btnMarginX + (btnWidth + btnGap) * i, (SHEET_HEIGHT - btnHeight) / 2, btnWidth, btnHeight);
        ImageWithLabel *item = [ImageWithLabel imageLabelWithFrame:frame Image:[UIImage imageNamed:shareTarget[@"icon"]] LabelText:shareTarget[@"name"]];
        item.labelColor = RGB(0x47, 0x47, 0x5E);
        item.labelOffsetY = 4;
        item.labelFont = [UIFont systemFontOfSize:10];
        item.tag = i;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick1:)];
        [item addGestureRecognizer:tapGes];
        [shareTargetScrollView addSubview:item];
    }
    [self.topSheetView addSubview:shareTargetScrollView];
    
    // 操作按钮
    UIScrollView *operationScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, LABEL_HEIGHT + SHEET_HEIGHT, CGRectGetWidth(self.topSheetView.bounds), SHEET_HEIGHT)];
    operationScrollView.showsHorizontalScrollIndicator = NO;
    operationScrollView.showsVerticalScrollIndicator = NO;
    operationScrollView.contentSize = CGSizeMake(MAX((btnWidth + btnGap) * self.operations.count + btnMarginX * 2, CGRectGetWidth(operationScrollView.bounds) + 1), SHEET_HEIGHT);
    for (int i = 0; i < self.operations.count; ++i) {
        NSDictionary *operation = self.operations[i];
        CGRect frame = CGRectMake(btnMarginX + (btnWidth + btnGap) * i, (SHEET_HEIGHT - btnHeight) / 2, btnWidth, btnHeight);
        ImageWithLabel *item = [ImageWithLabel imageLabelWithFrame:frame Image:[UIImage imageNamed:operation[@"icon"]] LabelText:operation[@"name"]];
        item.labelColor = RGB(0x47, 0x47, 0x5E);
        item.labelOffsetY = 4;
        item.labelFont = [UIFont systemFontOfSize:10];
        item.tag = i;
        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(itemClick2:)];
        [item addGestureRecognizer:tapGes];
        [operationScrollView addSubview:item];
    }
    [self.topSheetView addSubview:operationScrollView];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(15, LABEL_HEIGHT + SHEET_HEIGHT, CGRectGetWidth(self.topSheetView.bounds) - 30, ONEPX)];
//    lineView.backgroundColor = LINE_COLOR;
    [self.topSheetView addSubview:lineView];
    
    //    弹出
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        self.bgView.frame = CGRectMake(0, ScreenHeight - CGRectGetHeight(self.bgView.frame), ScreenWidth, CGRectGetHeight(self.bgView.frame));
    }];
    
    //    icon 动画
    //    [self iconAnimation];
}


/**
 做一个 icon 依次粗线的弹簧动画
 */
- (void)iconAnimation {
    CGFloat duration = 0;
    for (UIView *icon in self.buttons) {
        CGRect frame = icon.frame;
        CGRect toFrame = icon.frame;
        frame.origin.y += frame.size.height;
        icon.frame = frame;
        
        POPSpringAnimation *animation = [POPSpringAnimation animationWithPropertyNamed:kPOPViewFrame];
        animation.toValue = [NSValue valueWithCGRect:toFrame];
        animation.beginTime = CACurrentMediaTime() + duration;
        animation.springBounciness = 10.0f;
        
        [icon pop_addAnimation:animation forKey:kPOPViewFrame];
        
        duration += 0.07;
    }
}

#pragma mark --------------------------- Selector

/**
 点击取消
 */
- (void)tappedCancel {
    [UIView animateWithDuration:ANIMATE_DURATION animations:^{
        [self.bgView setFrame:CGRectMake(0, ScreenHeight, ScreenWidth, 0)];
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (finished) {
            [self removeFromSuperview];
        }
    }];
}

/**
 按钮点击
 
 @param tapGes 手势
 */
- (void)itemClick1:(UITapGestureRecognizer *)tapGes {
    [self tappedCancel];
    if (self.buttonTapped) {
        NSInteger tag = tapGes.view.tag;
        self.buttonTapped(self.shareTargets[tag]);
    }
}

- (void)itemClick2:(UITapGestureRecognizer *)tapGes {
    [self tappedCancel];
    if (self.buttonTapped) {
        NSInteger tag = tapGes.view.tag;
        self.buttonTapped(self.operations[tag]);
    }
}

#pragma mark --------------------------- getter

- (UIView *)bgView {
    if (_bgView == nil) {
        _bgView = [[UIView alloc] init];
        //
        //        //    根据图标个数，计算行数，计算 backgroundView 的高度
        //        NSInteger index;
        //        if (_shareTargets.count % 4 == 0) {
        //            index = _shareTargets.count / 4;
        //        } else {
        //            index = _shareTargets.count / 4 + 1;
        //        }
        //        _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, BUTTON_HEIGHT + (_protext.length == 0 ? 0 : 45) + LINE_HEIGHT * index);
        _bgView.frame = CGRectMake(0, ScreenHeight, ScreenWidth, LABEL_HEIGHT + SHEET_HEIGHT +  BUTTON_HEIGHT);
    }
    return _bgView;
}

- (UIView *)topSheetView {
    if (_topSheetView == nil) {
        _topSheetView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), CGRectGetHeight(_bgView.frame) - BUTTON_HEIGHT)];
        _topSheetView.backgroundColor = [UIColor whiteColor];
        //        _topSheetView.alpha = 0.8;
        //    如果有标题，添加标题
        if (_protext.length > 0) {
            [_topSheetView addSubview:self.proLbl];
        }
    }
    return _topSheetView;
}

- (UILabel *)proLbl {
    if (_proLbl == nil) {
        _proLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(_bgView.frame), LABEL_HEIGHT)];
        //    默认标题
        _proLbl.text = @"分享至";
        _proLbl.font = PFR16Font;
        _proLbl.textColor = [UIColor blackColor];
        _proLbl.backgroundColor = [UIColor whiteColor];
        _proLbl.textAlignment = NSTextAlignmentCenter;
    }
    return _proLbl;
}

- (UIButton *)cancelBtn {
    if (_cancelBtn == nil) {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _cancelBtn.frame = CGRectMake(0, CGRectGetHeight(_bgView.frame) - BUTTON_HEIGHT, CGRectGetWidth(_bgView.frame), BUTTON_HEIGHT);
        //    取消按钮
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [_cancelBtn.titleLabel setFont:[UIFont systemFontOfSize:14]];
        _cancelBtn.backgroundColor = MAIN_COLOR;
        [_cancelBtn setTitleColor:WHITE_COLOR forState:UIControlStateNormal];
        //    点击按钮，取消，收起面板，移除视图
        [_cancelBtn addTarget:self action:@selector(tappedCancel) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelBtn;
}


- (NSArray *)buttons {
    
    if (!_buttons) {
        _buttons = [NSMutableArray arrayWithCapacity:5];
    }
    return _buttons;
}

#pragma mark --------------------------- User-Defined

- (void)setCancelBtnColor:(UIColor *)cancelBtnColor {
    
    [_cancelBtn setTitleColor:cancelBtnColor forState:UIControlStateNormal];
}

- (void)setProStr:(NSString *)proStr {
    
    _proLbl.text = proStr;
}

- (void)setOtherBtnColor:(UIColor *)otherBtnColor {
    
    for (id res in _bgView.subviews) {
        
        if ([res isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)res;
            [button setTitleColor:otherBtnColor forState:UIControlStateNormal];
        }
    }
}

- (void)setOtherBtnFont:(NSInteger)otherBtnFont {
    
    for (id res in _bgView.subviews) {
        
        if ([res isKindOfClass:[UIButton class]]) {
            
            UIButton *button = (UIButton *)res;
            button.titleLabel.font = [UIFont systemFontOfSize:otherBtnFont];
        }
    }
}

- (void)setProFont:(NSInteger)proFont {
    
    _proLbl.font = [UIFont systemFontOfSize:proFont];
}

- (void)setCancelBtnFont:(NSInteger)cancelBtnFont {
    
    _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:cancelBtnFont];
}

- (void)setDuration:(CGFloat)duration {
    
    self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:duration];
}

@end

