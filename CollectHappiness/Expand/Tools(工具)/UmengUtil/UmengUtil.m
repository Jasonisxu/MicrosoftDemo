//
//  UmengUtil.m
//  SmallShops-seller-iOS
//
//  Created by Wicrenet_Jason on 2017/3/23.
//  Copyright © 2017年 Wicrenet_Jason. All rights reserved.
//

#import "UmengUtil.h"
#import "ShareView.h"
#import <MessageUI/MessageUI.h>
@interface UmengUtil()<MFMessageComposeViewControllerDelegate>
@property (nonatomic,strong) UIViewController *controller;

@end

@implementation UmengUtil
+ (void)shareBoardBySelfDefinedController:(UIViewController *)controller photoURL:(NSString *)photoURL titleStr:(NSString *)titleStr descrStr:(NSString *)descrStr shareURL:(NSString *)shareURL
{
    BOOL hadInstalledWeixin = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"weixin://"]];
    BOOL hadInstalledQQ = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"mqq://"]];
    BOOL hadInstalledSina = [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"sinaweibo://"]];
    
    NSDictionary *(^dict)(int,NSString *,NSString *) = ^(int type, NSString *name, NSString *icon) {
        return @{@"type": @(type), @"name": name, @"icon": icon};
    };
    
    NSMutableArray *shareTargets = [[NSMutableArray alloc] initWithCapacity:5];
    NSMutableArray *operations = [[NSMutableArray alloc] initWithCapacity:2];
    
//    if (hadInstalledWeixin) {
//        [shareTargets addObject:dict(TARGET_WECHAT_SESSION, @"微信", @"icon-back-1")];
//        [shareTargets addObject:dict(TARGET_WECHAT_TIMELINE, @"朋友圈", @"icon-back-6")];
//    }
//    if (hadInstalledQQ) {
//        [shareTargets addObject:dict(TARGET_QQ, @"QQ", @"icon-back-5")];
//        [shareTargets addObject:dict(TARGET_QZONE, @"QQ空间", @"icon-back-7")];
//    }
//    if (hadInstalledSina) {
//        [shareTargets addObject:dict(TARGET_SINA, @"微博", @"icon-back-4")];
//    }
//    
    [operations addObject:dict(TARGET_COPYLINK, @"复制链接", @"icon-back-2")];
    [operations addObject:dict(TARGET_SMS, @"手机短信", @"icon-back-3")];
    
    ShareView *shareView = [[ShareView alloc] initWithShareTargets:shareTargets operations:operations title:@"分享到"];
    [shareView setButtonTapped:^(NSDictionary *info) {
        int type = [info[@"type"] intValue];
        NSLog(@"\n点击第几个====%d\n当前选中的按钮title====%@", type, info[@"name"]);
        
        switch (type) {
            case TARGET_WECHAT_SESSION: // 微信
                // 根据获取的platformType确定所选平台进行下一步操作
                [UmengUtil shareWebPageToPlatformType:UMSocialPlatformType_WechatSession controller:controller photoURL:photoURL titleStr:titleStr descrStr:descrStr shareURL:shareURL];
                break;
            case TARGET_WECHAT_TIMELINE: // 微信朋友圈
                [UmengUtil shareWebPageToPlatformType:UMSocialPlatformType_WechatTimeLine controller:controller photoURL:photoURL titleStr:titleStr descrStr:descrStr shareURL:shareURL];
                break;
            case TARGET_QQ: // QQ
                [UmengUtil shareWebPageToPlatformType:UMSocialPlatformType_QQ controller:controller photoURL:photoURL titleStr:titleStr descrStr:descrStr shareURL:shareURL];
                break;
            case TARGET_QZONE: // QQ空间
                [UmengUtil shareWebPageToPlatformType:UMSocialPlatformType_Qzone controller:controller photoURL:photoURL titleStr:titleStr descrStr:descrStr shareURL:shareURL];
                break;
            case TARGET_SINA: //微博
                [UmengUtil shareWebPageToPlatformType:UMSocialPlatformType_Sina controller:controller photoURL:photoURL titleStr:titleStr descrStr:descrStr shareURL:shareURL];
                break;
            case TARGET_COPYLINK: // 复制链接
                [[UIPasteboard generalPasteboard] setString:shareURL];
                [HUD showSuccessfulMessage:@"已复制到剪切板" toView:nil];
                
                break;
            case TARGET_SMS: // 手机短信
                [[UmengUtil alloc] showMessageView:@[] title:nil body:[NSString stringWithFormat:@"%@\n%@",titleStr,shareURL] controller:controller];
                break;
            default:
                break;
        }
        
    }];
    [[UIApplication sharedApplication].keyWindow addSubview:shareView];
    
}

+ (void)shareWebPageToPlatformType:(UMSocialPlatformType)platformType controller:(UIViewController *)controller photoURL:(NSString *)photoURL titleStr:(NSString *)titleStr descrStr:(NSString *)descrStr shareURL:(NSString *)shareURL
{
    //创建分享消息对象
    UMSocialMessageObject *messageObject = [UMSocialMessageObject messageObject];
    
    if (platformType == UMSocialPlatformType_Sina) {
        //设置文本
        messageObject.text = [NSString stringWithFormat:@"%@%@",titleStr,shareURL];
        
        //创建图片内容对象
        UMShareImageObject *shareObject = [[UMShareImageObject alloc] init];
        //如果有缩略图，则设置缩略图
        shareObject.thumbImage = [UIImage imageNamed:@"default-image"];
        
        if (photoURL.length > 10) {
            [shareObject setShareImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]]];
        } else {
            [shareObject setShareImage:GetImage(photoURL)];
        }
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
    } else {
        
        //创建网页内容对象
        UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:descrStr thumImage:GetImage(photoURL)];
        
        if (photoURL.length > 10) {
            shareObject = [UMShareWebpageObject shareObjectWithTitle:titleStr descr:descrStr thumImage:[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:photoURL]]]];
        }
        
        //设置网页地址
        shareObject.webpageUrl = shareURL;
        
        
        //分享消息对象设置分享内容对象
        messageObject.shareObject = shareObject;
        
    }
    
    //调用分享接口
    [[UMSocialManager defaultManager] shareToPlatform:platformType messageObject:messageObject currentViewController:controller completion:^(id data, NSError *error) {
        if (error) {
            UMSocialLogInfo(@"************Share fail with error %@*********",error);
        }else{
            if ([data isKindOfClass:[UMSocialShareResponse class]]) {
                UMSocialShareResponse *resp = data;
                //分享结果消息
                UMSocialLogInfo(@"response message is %@",resp.message);
                //第三方原始返回的数据
                UMSocialLogInfo(@"response originalResponse data is %@",resp.originalResponse);
                
            }else{
                UMSocialLogInfo(@"response data is %@",data);
            }
        }
    }];
    
}


#pragma mark --发送短信--
- (void)showMessageView:(NSArray *)phones title:(NSString *)title body:(NSString *)body controller:(UIViewController *)controllerVC
{
    if( [MFMessageComposeViewController canSendText] )
    {
        MFMessageComposeViewController * controller = [[MFMessageComposeViewController alloc] init];
        controller.recipients = phones;
        controller.navigationBar.tintColor = [UIColor redColor];
        controller.body = body;
        controller.messageComposeDelegate = self;
        [controllerVC presentViewController:controller animated:YES completion:nil];
        [[[[controller viewControllers] lastObject] navigationItem] setTitle:title];//修改短信界面标题
        
        self.controller = controllerVC;
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息"
                                                        message:@"该设备不支持短信功能"
                                                       delegate:nil
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

//发短信
-(void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result
{
    [self.controller dismissViewControllerAnimated:YES completion:nil];
    switch (result) {
        case MessageComposeResultSent:
            //信息传送成功
            NSLog(@"信息发送成功");
            
            break;
        case MessageComposeResultFailed:
            //信息传送失败
            NSLog(@"信息传送失败");
            
            break;
        case MessageComposeResultCancelled:
            //信息被用户取消传送
            NSLog(@"信息被用户取消传送");
            
            break;
        default:
            break;
    }
}

@end

