//
//  BSWalletCacheMediater.m
//  BaiSongInternational
//
//  Created by Kirito on 2018/2/3.
//  Copyright © 2018年 maqihan. All rights reserved.
//

#import "BSWalletCacheMediater.h"
#import "BSKeychain.h"


static NSString * const GetSetDefault ;

@implementation BSWalletCacheMediater

+ (void)keychainPushWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback{
    NSError *error;
    if (!walletData.privateKey.length || !walletData.walletName.length ||!walletData.walletAddress.length) {
        
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:101
                                userInfo:nil];
        callback(error);
        return;
    }
    //查询key是否被导入过
    NSMutableArray * marr = [[NSMutableArray alloc]initWithArray:[BSWalletCache shareInstance].walletDataSrource.walletDatas];
    BOOL hasData = NO;
//    for (BSWalletData * data in marr) {
//        if ([data.privateKey isEqualToString:walletData.privateKey]) {
//
//            //含有、删除原item后追加
//            hasData = YES;
//            [marr removeObject:data];
//            if ([data isEqual:[[BSWalletCache shareInstance].walletDataSrource.walletDatas firstObject]]) {
//                //重新导入默认钱包
//                NSMutableIndexSet  *indexes = [NSMutableIndexSet indexSetWithIndex:0];
//                [indexes addIndex:0];
//                [marr insertObject:walletData atIndex:0];
//            }else {
//                //导入其他钱包
//                [marr addObject:walletData];
//            }
//
//            break;
//
//        }
//    }
    //demo、不匹配key了
    
    if (!hasData) {
        //不含有、直接追加
        [marr addObject:walletData];
    }
    
    if (![[BSKeychain shareInstance]setWallets:marr] ){
        
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:103
                                userInfo:nil];
        callback(error);
        return;
    }else {
        //追加成功、更新数据
        [[BSWalletCache shareInstance] updata];
    };
    callback(error);
}

+ (void)keychainDelWalletDataWithPrivateKey:(NSString *)privateKey callback:(walletCacheCallBack)callback {
    NSError *error;
    if (!privateKey.length) {
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:104
                                userInfo:nil];
        callback(error);
        return;
    }
    
    //尝试将delkey从数据源中剔除
    NSMutableArray * walletDatas;
    for (BSWalletData * datas in [BSWalletCache shareInstance].walletDataSrource.walletDatas) {
        if ([datas.privateKey isEqualToString:privateKey]) {
            walletDatas = [[NSMutableArray alloc]initWithArray:[BSWalletCache shareInstance].walletDataSrource.walletDatas];
            [walletDatas removeObject:datas];
            break;
        }
    }
    if (!walletDatas) {
        
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:105
                                userInfo:nil];
        callback(error);
        return;
    }
    
    if (![[BSKeychain shareInstance]setWallets:walletDatas] ){
        
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:103
                                userInfo:nil];
        callback(error);
        return;
    }else {
        //追加成功、更新数据
        [[BSWalletCache shareInstance] updata];
    };
    callback(error);
    
    
}

+ (void)keychainDelAllWalletData:(walletCacheCallBack)callback{
    if (![BSWalletCache shareInstance].walletDataSrource.walletDatas.count) {
        return;
    }
    NSError *error;
    if (![[BSKeychain shareInstance]delAllWallets] ){
        error = [NSError errorWithDomain:NSCocoaErrorDomain
                                    code:103
                                userInfo:nil];
        callback(error);
        return;
    } else {
        //追加成功、更新数据
        [[BSWalletCache shareInstance] updata];
    };
    callback(error);
}

+ (void)keychainSetDefaultWalletData:(BSWalletData *)walletData callback:(walletCacheCallBack)callback{
    NSDictionary * parameters = @{@"default":walletData.privateKey};
    
//    [[BSNetWorking shareInstance] POST:GetSetDefault refresh:YES parameters:parameters success:^(id json) {
        if (1) {
            
            
            NSMutableArray * marr = [[NSMutableArray alloc]initWithArray:[BSWalletCache shareInstance].walletDataSrource.walletDatas];
            
            for (BSWalletData *data in marr) {
                if ([data.privateKey isEqualToString:walletData.privateKey]) {
                    [marr removeObject:data];
                    NSMutableIndexSet  *indexes = [NSMutableIndexSet indexSetWithIndex:0];
                    [indexes addIndex:0];
                    [marr insertObject:data atIndex:0];
                    break;
                }
            }
            
            NSError * error;
            if (![[BSKeychain shareInstance]setWallets:marr] ){
                
                error = [NSError errorWithDomain:NSCocoaErrorDomain
                                            code:103
                                        userInfo:nil];
                callback(error);
                return;
            } else {
                //追加成功、更新数据
                [[BSWalletCache shareInstance] updata];
            };
            callback(error);
            
        }else {
            
            NSError *error = [NSError errorWithDomain:NSCocoaErrorDomain
                                                 code:106
                                             userInfo:@{@"msg":@""}];
            callback(error);
            
            
        }
//    } failure:^(NSError *error) {
//        callback(error);
//    }];
}

@end
