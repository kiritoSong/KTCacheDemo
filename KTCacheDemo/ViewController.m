//
//  ViewController.m
//  KTCacheDemo
//
//  Created by 刘嵩野 on 2018/2/5.
//  Copyright © 2018年 刘嵩野. All rights reserved.
//

#import "ViewController.h"

#import "BSWalletCache.h"

@interface ViewController ()
@property (atomic) NSArray * arr;
@property (nonatomic) BSWalletDataSource * dataSource;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.dataSource = [BSWalletCache shareInstance].walletDataSrource;
    self.titleLab.text = [NSString stringWithFormat:@"当前页面展示数量、%zd",[BSWalletCache shareInstance].walletDataSrource.walletDatas.count];

}

- (IBAction)startBtnClick:(id)sender {
    
    dispatch_queue_t q = dispatch_queue_create("test.q", DISPATCH_QUEUE_CONCURRENT);
    
    //这是一个崩溃的例子
//    dispatch_async(q, ^{
//        for (int i = 0; i < 100000; i ++) {
//            NSArray * a = @[@1,@2];
//            self.arr = a;
//        }
//    });
//
//    dispatch_async(q, ^{
//        for (int i = 0; i < 100000; i ++) {
//            NSLog(@"%@",self.arr);
//        }
//    });
    
    
    
    
    dispatch_async(q, ^{
        for (int i = 0; i < 100000; i ++) {
            //写入
            BSWalletData * data = [[BSWalletData alloc]initWithPrivateKey:@"key" walletName:@"name" walletAddress:@"address"];
            
            [[BSWalletCache shareInstance]pushWalletData:data callback:^(NSError *err) {
                if (!err) {
                    
                }else {
                    NSLog(@"%@",err);
                }
            }];
        }
    });
    
    dispatch_async(q, ^{
        for (int i = 0; i < 100000; i ++) {
            //读取
            NSUInteger count = [BSWalletCache shareInstance].walletDataSrource.walletDatas.count;
            NSLog(@"当前数据源数量%zd",count);
        }
    });
    
    
}
- (IBAction)delBtnClick:(id)sender {
    //在追加的时候删除是没用的、因为多线程操作会导致先被删除。然后被追加进去原来的数据源。
    [[BSWalletCache shareInstance]delAllWalletData:^(NSError *err) {
        if (!err) {
            NSLog(@"删除成功");
        }else {
            NSLog(@"%@",err);
        }
    }];
}
- (IBAction)checkBtnClick:(id)sender {
    //手动检查数据
    if (self.dataSource.dirty) {
        //更新数据
        self.dataSource = [BSWalletCache shareInstance].walletDataSrource;
//        [self.tableView reloadData];
        self.titleLab.text = [NSString stringWithFormat:@"当前页面展示数量、%zd",[BSWalletCache shareInstance].walletDataSrource.walletDatas.count];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (BSWalletDataSource *)dataSource {
    if (!_dataSource) {
        _dataSource = [BSWalletCache shareInstance].walletDataSrource;
    }
    return _dataSource;
}


@end
