//
//  BSWalletCache.h
//  BaiSongInternational
//
//  Created by 刘嵩野 on 2018/2/1.
//  Copyright © 2018年 maqihan. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  钱包模块数据缓存
 **/

@class BSWalletDataSource;
@class BSWalletData;

/**
 *  101 privateKey || walletName 为空
 *  102 私钥已被导入
 *  103 写入数据失败
 *  104 privateKey 为空
 *  105 想要删除的key 不存在
 *  106 设置默认钱包失败
 **/
typedef void(^walletCacheCallBack)(NSError * err);

@interface BSWalletCache : NSObject

//当前缓存数据源。
//交由外界列表持有。
//不可变保证资源完整性与线程安全。
//当数据库改变后、外部UI通过判断walletDataSrource.dirty = YES 鉴别是否需要重新拉取数据。
@property (nonatomic ,readonly) BSWalletDataSource * walletDataSrource;

//当前主钱包、位列数据源第一位
@property (atomic ,readonly) BSWalletData * walletData;

+ (instancetype)shareInstance;
//从数据库更新数据
- (void)updata;
//插入
- (void)pushWalletData:(BSWalletData *)data callback:(walletCacheCallBack)callback;
//删除
- (void)delWalletDataWithPrivateKey:(NSString *)privateKey callback:(walletCacheCallBack)callback;;
//删除全部
- (void)delAllWalletData:(walletCacheCallBack)callback;

- (void)setDefaultWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback;

@end






#pragma mark - 附属类

typedef void(^walletDataCallBack)(NSError * err);

@interface BSWalletData : NSObject

//私钥
@property (nonatomic, readonly ,copy) NSString * privateKey;
//钱包名
@property (nonatomic, readonly ,copy) NSString * walletName;
//钱包地址
@property (nonatomic, readonly ,copy) NSString * walletAddress;
//钱包地址
@property (nonatomic, readwrite ,copy) NSString * balance;

- (instancetype)initWithPrivateKey:(NSString *)privateKey walletName:(NSString *)walletName walletAddress:(NSString *)walletAddress;

- (void)configWalletAddress:(NSString *)walletAddress;

@end


@interface BSWalletDataSource : NSObject

//当dirty=Yes 代表当前数据已经被废弃
@property (nonatomic) BOOL dirty;

//当前缓存数据源。
//交由外界列表持有。
//不可变保证资源完整性与线程安全。
//当数据库改变后、外部UI通过dirty = YES 鉴别是否需要重新拉取数据。
@property (nonatomic,readonly) NSArray * walletDatas;

//从数据库更新数据
- (void)updata;
@end
