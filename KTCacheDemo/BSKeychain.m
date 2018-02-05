//
//  BSKeychain.m
//  YiBaiSong
//
//  Created by 马启晗 on 16/12/1.
//  Copyright © 2016年 yibaisong. All rights reserved.
//

#import "BSKeychain.h"

#import "SAMKeychain.h"
#import "SAMKeychainQuery.h"

#import "BSWalletCache.h"


static NSString * const service_name  = @"11010101_name";
static NSString * const wallets_key      = @"11010101_%@";

@interface BSKeychain()

@property (strong , nonatomic) SAMKeychainQuery *keychainQuery;

@end

@implementation BSKeychain

+ (instancetype)shareInstance
{
    static BSKeychain *_sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedManager = [[BSKeychain alloc] init];
    });
    return _sharedManager;
}


- (SAMKeychainQuery *)keychainQuery
{
    if (!_keychainQuery) {
        _keychainQuery = [[SAMKeychainQuery alloc] init];
        _keychainQuery.service  = service_name;
        _keychainQuery.synchronizationMode = SAMKeychainQuerySynchronizationModeNo;
    }
    return _keychainQuery;
}


- (NSString *)privateKeyWithUid:(NSString *)uid {
  
    if (!uid) {
        NSLog(@"uid不能为空");
        return nil;
    }
    
    NSString * wallets_uid = [NSString stringWithFormat:wallets_key,uid];
    NSData   * walletsData  = [SAMKeychain passwordDataForService:service_name account:wallets_uid];
    
    NSArray  * wallets = [NSKeyedUnarchiver unarchiveObjectWithData:walletsData];
    
    return [wallets firstObject];
}




- (NSArray *)wallets {
    NSString * uid = @"11010101";
    
    if (!uid) {
        NSLog(@"uid不能为空");
        return nil;
    }
    
    NSString * wallets_uid = [NSString stringWithFormat:wallets_key,uid];
    NSData   * walletsData  = [SAMKeychain passwordDataForService:service_name account:wallets_uid];
    
    NSArray  * wallets = [NSKeyedUnarchiver unarchiveObjectWithData:walletsData];
    
    return wallets;
}


//追加私钥
- (BOOL)setWallets:(NSArray *)wallets {
    
    NSString * uid = @"11010101";
    if (!uid) {
        NSLog(@"uid不能为空");
        return NO;
    }
    NSString * wallets_uid = [NSString stringWithFormat:wallets_key,uid];
    NSError  *error = nil;
    self.keychainQuery.account  = wallets_uid;

    
    NSData * passwordData = [NSKeyedArchiver archivedDataWithRootObject:wallets];
    
    self.keychainQuery.passwordData = passwordData;
    
    [self.keychainQuery save:&error];
    
    
    if (!error) {
        
        return YES;
    }else {
        return NO;
    }
}


- (BOOL)delAllWallets {
    NSString * uid = @"11010101";
    if (!uid) {
        NSLog(@"uid不能为空");
        return NO;
    }
    NSString * wallets_uid = [NSString stringWithFormat:wallets_key,uid];
    NSError  *error = nil;
    self.keychainQuery.account  = wallets_uid;
    
    [self.keychainQuery deleteItem:&error];
   
    if (!error) {
        return YES;
    }else {
        return NO;
    }
}
@end
