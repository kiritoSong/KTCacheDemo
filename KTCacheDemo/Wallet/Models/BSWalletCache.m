//
//  BSWalletCache.m
//  BaiSongInternational
//
//  Created by 刘嵩野 on 2018/2/1.
//  Copyright © 2018年 maqihan. All rights reserved.
//

#import "BSWalletCache.h"

#import "BSKeychain.h"
#import "BSWalletCacheMediater.h"


@interface BSWalletCache()
@property (atomic) BSWalletDataSource * dataSource;
@property (nonatomic ,copy) NSString * uid;
@end

@implementation BSWalletCache

+ (instancetype)shareInstance
{
    static BSWalletCache * _walletCache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _walletCache = [[BSWalletCache alloc] init];
        [_walletCache updata];
    });
    return _walletCache;
}

- (BSWalletData *)walletData {
    @synchronized(self) {
        [self checkUserId];
        return [self.dataSource.walletDatas firstObject];
    }
}

- (BSWalletDataSource *)walletDataSrource {
    [self checkUserId];
    //dataSource 为atomic 无需加锁
    return self.dataSource;
}

- (void)checkUserId {
    NSString * uid = @"11010101";
    if (![self.uid isEqualToString:uid]) {
        //账号已经更换、更新数据
        [self updata];
    }
}

- (void)updata {
    //废弃原数据
    self.dataSource.dirty = YES;
    

    NSString * uid = @"11010101";
    self.uid = uid;
    
    BSWalletDataSource * dataSource = [BSWalletDataSource new];
    //从数据库拉取新数据
    [dataSource updata];
    self.dataSource = dataSource;
}

- (void)pushWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback{
    
    [BSWalletCacheMediater keychainPushWalletData:walletData callback:callback];
}

- (void)delWalletDataWithPrivateKey:(NSString *)privateKey callback:(walletCacheCallBack)callback{
    
    [BSWalletCacheMediater keychainDelWalletDataWithPrivateKey:privateKey callback:callback];
    
}

- (void)delAllWalletData:(walletCacheCallBack)callback {
    
    [BSWalletCacheMediater keychainDelAllWalletData:callback];
    
}

- (void)setDefaultWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback {
    
    [BSWalletCacheMediater keychainSetDefaultWalletData:walletData callback:callback];
    
}

@end



@interface BSWalletData()
@end

@implementation BSWalletData

- (NSString *)balance {
    float fbalance = [_balance floatValue];
    return [NSString stringWithFormat:@"%.4f",fbalance];
}


- (instancetype)initWithPrivateKey:(NSString *)privateKey walletName:(NSString *)walletName walletAddress:(NSString *)walletAddress
{
    self = [super init];
    if (self) {
        _privateKey = privateKey;
        _walletName = @"moren";
        _walletAddress = walletAddress;
    }
    return self;
}

- (void)configWalletAddress:(NSString *)walletAddress {
    _walletAddress = walletAddress;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.privateKey forKey:@"privateKey"];
    [coder encodeObject:self.walletName forKey:@"walletName"];
    [coder encodeObject:self.walletAddress forKey:@"walletAddress"];
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        _privateKey = [coder decodeObjectForKey:@"privateKey"];
        _walletName = [coder decodeObjectForKey:@"walletName"];
        _walletAddress = [coder decodeObjectForKey:@"walletAddress"];
    }
    return self;
}

@end

@implementation BSWalletDataSource

- (void)updata {
    _walletDatas = [[BSKeychain shareInstance] wallets];
}
@end
