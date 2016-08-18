//
//  RACSubjectVC.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "RACSubjectVC.h"

#import "PersonViewModel.h"

@interface RACSubjectVC ()

@end

@implementation RACSubjectVC

#pragma mark - 生命周期 -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
    [self getInfo];
}

#pragma mark - UI -
-(void)createUI{
    
    self.navigationItem.title = @"RACSubject";
}

-(void)getInfo{
    
    PersonViewModel * viewModel = [[PersonViewModel alloc]init];

    //这是错误做法,先发送信号再订阅信号的话对于RACSubject来说的话是不可以的,RACReplaySubject可以先发送信号再去订阅
//    [viewModel loadInfo];
    
    //先获取到RACSubject,再订阅他,和RACSignal基本相同的方式
    [[viewModel getSubject] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"完成");
    }];
    
    //发送信号
    [viewModel loadInfo];
}
@end
