//
//  BSWalletCacheMediater.h
//  BaiSongInternational
//
//  Created by Kirito on 2018/2/3.
//  Copyright © 2018年 maqihan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BSWalletCache.h"

/**
 *  walletCache 与 keychain 之间操作的中间件
 *  进行逻辑判断与资源格式化
 *  视情况将来可能变成 数据库操作的中间件
 **/

@interface BSWalletCacheMediater : NSObject


//插入
+ (void)keychainPushWalletData:(BSWalletData *)data callback:(walletCacheCallBack)callback;
//删除
+ (void)keychainDelWalletDataWithPrivateKey:(NSString *)privateKey callback:(walletCacheCallBack)callback;
//删除全部
+ (void)keychainDelAllWalletData:(walletCacheCallBack)callback;

+ (void)keychainSetDefaultWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback;

@end
