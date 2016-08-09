//
//  RACSubjectVC.m
//  Lianxi
//
//  Created by fy on 16/8/9.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "RACSubjectVC.h"

@interface RACSubjectVC ()

@end

@implementation RACSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //创建信号
    RACSubject * subject = [RACSubject subject];
    //订阅信号
    [subject subscribeNext:^(id x) {
        NSLog(@"此处先订阅信号,信号传值是%@",x);
    }];
    //发送信号
    [subject sendNext:@2];
}
/*
 注意 RACSubject和RACReplaySubject的区别 RACSubject必须要先订阅信号之后才能发送信号， 而RACReplaySubject可以先发送信号后订阅. 
 */



@end
