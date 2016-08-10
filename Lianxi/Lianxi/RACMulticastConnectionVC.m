//
//  RACMulticastConnectionVC.m
//  Lianxi
//
//  Created by fy on 16/8/10.
//  Copyright © 2016年 LY. All rights reserved.
//

/*
 可以看到,RACMulticastConnection每次连接一次,信号发送的时候didSubscribeblock都会全部执行一遍,而不仅仅是subscriber发出的东西
 */
#import "RACMulticastConnectionVC.h"

@interface RACMulticastConnectionVC ()

@property(nonatomic,strong)RACSignal * signal;

@end

@implementation RACMulticastConnectionVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self sendSignal];
    
    [self getSignal];
    
    [self getSecondSignal];
}

-(void)sendSignal{
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        NSLog(@"发送信号");
        
        [subscriber sendNext:@"haha"];
        
        return nil;
    }];
    
    self.signal = signal;
    
}

-(void)getSignal{
   
    RACMulticastConnection * connection = [self.signal publish];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"1%@",x);
    }];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"2%@",x);
    }];
    //将信号源转化为热信号
    [connection connect];
}

-(void)getSecondSignal{
    RACMulticastConnection * connection = [self.signal publish];
    
    [connection.signal subscribeNext:^(id x) {
        NSLog(@"3%@",x);
    }];
    
    [connection connect];
}
@end
