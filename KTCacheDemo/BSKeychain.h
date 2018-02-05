//
//  BSKeychain.h
//  YiBaiSong
//
//  Created by 马启晗 on 16/12/1.
//  Copyright © 2016年 yibaisong. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface BSKeychain : NSObject

+ (instancetype)shareInstance;


//登录用、首次登录数据库无uid、需要手动传输
- (NSString *)privateKeyWithUid:(NSString *)uid;


- (NSArray *)wallets;

//追加私钥
- (BOOL)setWallets:(NSArray *)wallets;

//追加私钥
- (BOOL)delAllWallets;




@end
