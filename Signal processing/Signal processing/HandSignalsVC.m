//
//  HandSignalsVC.m
//  Signal processing
//
//  Created by fy on 16/8/30.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "HandSignalsVC.h"

@interface HandSignalsVC ()

@property(nonatomic,strong)RACSignal * testSignal;

@end

@implementation HandSignalsVC

#pragma mark - 生命周期 -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUpSignals];
    
//    [self testTheMethodOfDoNextandDoComplete];
    
    [self testTheMethodOf];
}

-(void)dealloc{
    
    NSLog(@"销毁");
}

#pragma mark - 创建信号 -
-(void)createUpSignals{
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"1%@",[NSThread currentThread]);
        
        [subscriber sendNext:@1];
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@2];
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@3];
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@1];
//        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    self.testSignal = signal;
    
}

#pragma mark - 测试方法 -
-(void)testTheMethodOfDoNextandDoComplete{
    
    //doNext doComplete doError中的block会分别在对应的sendNext sendComplete sendError之前执行
    [[[[self.testSignal doNext:^(id x) {
        
        NSLog(@"sendNext之前会执行这个block");
        
    }] doCompleted:^{
        
        NSLog(@"sendComplete之前会执行这个block");
        
    }] doError:^(NSError *error) {
        
        NSLog(@"sendError之前会执行这个block");
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

-(void)testTheMethodOf{
    
//    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
//        
//        NSLog(@"send%@",[NSThread currentThread]);
//        
//        [subscriber sendNext:@1];
//        
//        return [RACDisposable disposableWithBlock:^{
//            
//        }];
//    }] subscribeOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
    
//    [[self.testSignal deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",[NSThread currentThread]);
//        
//    }];
//    
//    [[self.testSignal deliverOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
//        
//        NSLog(@"%@",[NSThread currentThread]);
//    }];
    
    [[self.testSignal subscribeOn:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        
        NSLog(@"3%@",[NSThread currentThread]);
    }];
}

@end
