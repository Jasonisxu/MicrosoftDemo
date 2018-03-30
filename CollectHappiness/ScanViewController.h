//
//  ScanViewController.h
//  CollectHappiness
//
//  Created by Wicrenet_Jason on 2018/3/28.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScanViewController : UIViewController
@property (nonatomic, copy) void(^addProductNoBlock)(NSString *productNoString);
@end
