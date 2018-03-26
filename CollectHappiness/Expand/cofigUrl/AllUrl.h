//
//  AllUrl.h
//  NewVShop
//
//  Created by Wicrenet_Jason on 2018/1/4.
//  Copyright © 2018年 Wicrenet_Jason. All rights reserved.
//

#ifndef AllUrl_h
#define AllUrl_h

#if DEBUG ////////////////////////////////////////////////////////////////////////////////开发

#define HEAD_URL     @"http://www.ketongtx.com"

//友盟统计
#define UmengKey           @"59cc9324aed1796ddb00001d"

//QQ分享
#define UmengQQAppSecret @"qTRstNhGLePWgdIJ"
#define UmengQQAppID @"1106333515"

#else//////////////////////////////////////////////////////////////////////////////分隔符
//
//请求头部
#define HEAD_URL     @"http://wise.wicrenet.com"

//友盟统计
#define UmengKey           @"59b6339d07fe656aad000613"

//QQ分享
#define UmengQQAppSecret @"JAZoOOnsZs73vIFI"
#define UmengQQAppID @"1106333333"
//
#endif////////////////////////////////////////////////////////////////////////////////结束


/******************************************************************************************************************----MAIN_URL--*/
#define MAIN_URL                          HEAD_URL @"/api/services"

/******************************************************************************************************************---login和个人信息---*/
//发送手机验证码
#define SendLoginSmsCode_URL              MAIN_URL @"/mall/account/sendCode"
//验证码登录
#define MobileLogin_URL                   MAIN_URL @"/mall/account/BuyerLogin2"
//获取会员中心信息
#define URL_usercenterinfo                [NSString stringWithFormat:@"%@/mall/home/usercenterinfo?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//更新昵称和头像
#define URL_updateavatornickname          MAIN_URL @"/mall/account/updateavatornickname"
//更新用户信息
#define URL_userinfo                      [NSString stringWithFormat:@"%@/mall/home/userinfo?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//获取app下载地址
#define URL_getsetting                    [NSString stringWithFormat:@"%@/appgenerate/main/getsetting?wid=%@",MAIN_URL,LXUserDefaultsGet(AppShopWid)]


/**********************************************************************751061********************************************----上传图片-*/
//上传图片 -- (头像)
#define URL_UpdatePhoto                   HEAD_URL @"/tools/upload_ajax.ashx"

/******************************************************************************************************************------*/
//商品分组
#define URL_GetMobileCateProducts         MAIN_URL @"/mall/product/GetMobileCateProducts"

/******************************************************************************************************************---跳转的URL---*/

//查看店铺
#define ShopUrl_index                     [NSString stringWithFormat:@"%@/mall/index?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//购物车
#define ShopUrl_carts                     [NSString stringWithFormat:@"%@/mall/carts?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]

//订单
#define ShopUrl_orders                    [NSString stringWithFormat:@"%@/mall/orders?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//优惠券
#define ShopUrl_MyCoupon                  [NSString stringWithFormat:@"%@/mall/coupons/MyCoupon?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//礼品卡
#define ShopUrl_mygiftcard                [NSString stringWithFormat:@"%@/giftcard/app/giftcard/mygiftcard?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//收到的礼物
#define ShopUrl_mygiftorder               [NSString stringWithFormat:@"%@/mall/order/mygiftorder?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//会员卡
#define ShopUrl_ucard                     [NSString stringWithFormat:@"%@/crm/ucard/index?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//积分商城
#define ShopUrl_scoredProduct             [NSString stringWithFormat:@"%@/crm/ucard/scoredProduct?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//收藏夹
#define ShopUrl_collection                [NSString stringWithFormat:@"%@/mall/collection?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]

//账号管理
#define ShopUrl_accountinfo               [NSString stringWithFormat:@"%@/mall/ucenter/accountinfo?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//收货地址管理
#define ShopUrl_address                   [NSString stringWithFormat:@"%@/mall/address?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]
//收货地址管理
#define ShopUrl_homeAboutus               [NSString stringWithFormat:@"%@/mall/home/aboutus?wid=%@",HEAD_URL,LXUserDefaultsGet(AppShopWid)]

//商品详情
#define ShopUrl_goodsDetail(productid)    [NSString stringWithFormat:@"%@/mall/detail/%@.html?wid=%@&productid=%@",HEAD_URL,productid,LXUserDefaultsGet(AppShopWid),productid]
//搜索商品
#define ShopUrl_searchGoods(keyword)    [NSString stringWithFormat:@"%@/mall/category?keyword=%@&wid=%@&type=search",HEAD_URL,keyword,LXUserDefaultsGet(AppShopWid)]








#endif /* AllUrl_h */
