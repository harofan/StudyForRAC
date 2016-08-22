//
//  RACCommandVC.m
//  Lianxi
//
//  Created by fy on 16/8/10.
//  Copyright © 2016年 LY. All rights reserved.
//
/*
 监听事件完成或者按钮点击
 */
#import "RACCommandVC.h"

@interface RACCommandVC ()

@end

@implementation RACCommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createupUI];
}

-(void)createupUI{
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIButton * btn = [[UIButton alloc]init];
    
    [btn setTitle:@"处理事件" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    btn.frame = CGRectMake(100, 100, 100, 20);
    
    [self.view addSubview:btn];
    
    [btn addTarget:self action:@selector(didClickEventBtn) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton * btn2 = [[UIButton alloc]init];
    
    [btn2 setTitle:@"监听事件" forState:UIControlStateNormal];
    
    [btn2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn2 setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    btn2.frame = CGRectMake(100, 200, 100, 20);
    
    [self.view addSubview:btn2];
    
    [btn2 addTarget:self action:@selector(didClickBtn) forControlEvents:UIControlEventTouchUpInside];
    
}

-(void)didClickEventBtn{
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"input:%@",input);
        //这里主要体现了一个链式编程的思想
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"数据"];
            
            return nil;
        }];
    }];
    
    [command.executionSignals subscribeNext:^(RACSignal * x) {
        
        [x subscribeNext:^(id x) {
            NSLog(@"%@",x);
        }];
    }];
    
    [command execute:@3];
    

}

-(void)didClickBtn{
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        NSLog(@"input:%@",input);
        //这里主要体现了一个链式编程的思想
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            [subscriber sendNext:@"数据"];
            
            [subscriber sendCompleted];
            
            return nil;
        }];
    }];
    //监听事件是否完成
    [command.executing subscribeNext:^(id x) {
        if ([x boolValue]==YES) {
            NSLog(@"正在执行%@",x);
        } else {
            NSLog(@"执行完成/没有执行");
        }
    }];
    
    [command execute:@1];
}


@end
