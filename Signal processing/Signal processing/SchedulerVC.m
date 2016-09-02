//
//  SchedulerVC.m
//  Signal processing
//
//  Created by fy on 16/9/2.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "SchedulerVC.h"

@interface SchedulerVC ()

@property(nonatomic,strong)RACSignal * testSignal;

@end

@implementation SchedulerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self createUpSignals];
    
    [self testTheMethodOfScheduler];
}

#pragma mark - 创建信号 -
-(void)createUpSignals{
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"sendTestSignal%@",[NSThread currentThread]);
        
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    self.testSignal = signal;
    
}

#pragma mark -  测试方法
-(void)testTheMethodOfScheduler{
    
    [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"sendSignal%@",[NSThread currentThread]);
        
        [subscriber sendNext:@1];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
        
    }] subscribeOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
        
        NSLog(@"receiveSignal%@",[NSThread currentThread]);
        
    }];
    
//        [[self.testSignal deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {
//    
//            NSLog(@"receiveSignal%@",[NSThread currentThread]);
//    
//        }];
    

}

@end
