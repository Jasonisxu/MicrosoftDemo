//
//  ReadableCodeMaskView.m
//  clientsAPP
//
//  Created by Cator Vee on 05/09/2017.
//  Copyright © 2017 Wicrenet_Jason. All rights reserved.
//

#import "ReadableCodeMaskView.h"

@interface ReadableCodeMaskView ()
@property (nonatomic,strong) NSTimer *timer;
@property (nonatomic) NSUInteger step;
@end

@implementation ReadableCodeMaskView

-(instancetype)init
{
    self = [super init];
    if (self) {
        [self setupView];
    }
    return self;
}

-(void)setupView
{
    self.backgroundColor = [UIColor clearColor];
    self.step = 0;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    CGSize size = rect.size;
    CGFloat width = (CGFloat) round(size.width / 3 * 2);
    CGRect frame = CGRectMake((CGFloat) round((size.width - width) / 2), (CGFloat) round((size.height - width) / 2 - size.height / 20), width, width);
    
    //获得处理的上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 蒙版
    CGContextSetRGBFillColor(context, 0, 0, 0, 0.5);
    CGContextFillRect(context, CGRectMake(0, 0, size.width, frame.origin.y));
    CGContextFillRect(context, CGRectMake(0, frame.origin.y, frame.origin.x, frame.size.height));
    CGContextFillRect(context, CGRectMake(frame.origin.x + frame.size.width, frame.origin.y, size.width - frame.origin.x - frame.size.width, frame.size.height));
    CGContextFillRect(context, CGRectMake(0, frame.origin.y + frame.size.height, size.width, size.height - frame.origin.y - frame.size.height));
    
    // 提示文字
    UIFont *font = [UIFont systemFontOfSize:14.0];
    NSString *text = @"将条码/二维码放入框内";
    NSDictionary* attribute = @{
                                NSForegroundColorAttributeName:WHITE_COLOR,//设置文字颜色
                                NSFontAttributeName:font//设置文字的字体
                                };
    CGSize sizeText = [text boundingRectWithSize:self.bounds.size
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:attribute
                                         context:nil].size;
    [text drawInRect:CGRectMake((size.width - sizeText.width) / 2, frame.origin.y - sizeText.height - 6.0f, sizeText.width, sizeText.height) withAttributes:attribute];
    
    // 网格线
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetLineWidth(context, ONEPX);
    CGContextSetRGBStrokeColor(context, 0.274509, 0.588235, 0.839215, 0.3);
    CGContextBeginPath(context);
    int num = 25;
    CGFloat space = frame.size.height / num;
    for (int i = 0; i <= num; i++) {
        CGContextMoveToPoint(context, frame.origin.x + i * space, frame.origin.y);
        CGContextAddLineToPoint(context, frame.origin.x + i * space, frame.origin.y + frame.size.height);
        CGContextMoveToPoint(context, frame.origin.x, frame.origin.y + i * space);
        CGContextAddLineToPoint(context, frame.origin.x + frame.size.width, frame.origin.y + i * space);
    }
    CGContextStrokePath(context);
    
    // 激光线
    int steps = 100;
    int step = self.step % steps;
    int dir = self.step / steps;
    CGFloat lineHeight = space * 0.8f;
    CGFloat lineY;
    UIImage *lightImage = [UIImage imageNamed:@"scan_light"];
    if (dir % 2 == 0) {
        lineY = frame.origin.y + space + (frame.size.height - space * 2) / steps * step;
    } else {
        lineY = CGRectGetMaxY(frame) - space - (frame.size.height - space * 2) / steps * step;
    }
    CGContextDrawImage(context, CGRectMake(frame.origin.x, lineY - lineHeight / 2, frame.size.width, lineHeight), lightImage.CGImage);
    
    // 边角线
    CGContextSetRGBFillColor(context, 0.274509, 0.588235, 0.839215, 1.0);
    CGFloat cornerWidth = width / 15;
    CGFloat cornerHeight = 3.0;
    CGContextFillRect(context, CGRectMake(frame.origin.x, frame.origin.y, cornerWidth, cornerHeight));
    CGContextFillRect(context, CGRectMake(frame.origin.x, frame.origin.y, cornerHeight, cornerWidth));
    CGContextFillRect(context, CGRectMake(frame.origin.x, CGRectGetMaxY(frame) - cornerHeight, cornerWidth, cornerHeight));
    CGContextFillRect(context, CGRectMake(frame.origin.x, CGRectGetMaxY(frame) - cornerWidth, cornerHeight, cornerWidth));
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(frame) - cornerWidth, frame.origin.y, cornerWidth, cornerHeight));
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(frame) - cornerHeight, frame.origin.y, cornerHeight, cornerWidth));
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(frame) - cornerWidth, CGRectGetMaxY(frame) - cornerHeight, cornerWidth, cornerHeight));
    CGContextFillRect(context, CGRectMake(CGRectGetMaxX(frame) - cornerHeight, CGRectGetMaxY(frame) - cornerWidth, cornerHeight, cornerWidth));
}

-(void)animationStep
{
    self.step++;
    [self setNeedsDisplay];
}

-(void)startAnimating
{
    if (self.timer != nil) {
        [self stopAnimating];
    }
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05 target:self selector:@selector(animationStep) userInfo:nil repeats:true];
}

-(void)stopAnimating
{
    if (self.timer != nil) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

@end
