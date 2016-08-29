//
//  SignalCombinerVC.m
//  Signal processing
//
//  Created by fy on 16/8/29.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "SignalCombinerVC.h"

@interface SignalCombinerVC ()

@property(nonatomic,strong)UILabel * lb_name;

@property(nonatomic,strong)UILabel * lb_age;

@property(nonatomic,strong)UITextField * tf_name;

@property(nonatomic,strong)UITextField * tf_age;

@property(nonatomic,strong)RACSignal * signalA;

@property(nonatomic,strong)RACSignal * signalB;

@end

@implementation SignalCombinerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createupUI];
    
    [self createSignal];
    
    [self testTheMethodOfConcat];
}

#pragma mark - 创建信号 -
-(void)createSignal{
    
    RACSignal * signalA = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"A"];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    RACSignal * signalB = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@"B"];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    self.signalA = signalA;
    
    self.signalB = signalB;
    
}

#pragma mark - 信号组合处理 -
-(void)testTheMethodOfConcat{
    
    //这相当于网络请求中的依赖,必须先执行完信号A才会执行信号B
    //经常用作一个请求执行完毕后,才会执行另一个请求
    //注意信号A必须要执行发送完成信号,否则信号B无法执行
    RACSignal * concatSignal = [self.signalA concat:self.signalB];
    
    //这里我们是对这个拼接信号进行订阅
    [concatSignal subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - UI -
-(void)createupUI{
    
    UITextField * tf_name = [[UITextField alloc]init];
    
    self.tf_name = tf_name;
    
    [self.view addSubview:tf_name];
    
    tf_name.borderStyle = UITextBorderStyleRoundedRect;
    
    tf_name.placeholder = @"姓名";
    
    [tf_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(self.view.top).offset(100);
        
        make.width.equalTo(200);
        
    }];
    
    UITextField * tf_age = [[UITextField alloc]init];
    
    self.tf_age = tf_age;
    
    [self.view addSubview:tf_age];
    
    tf_age.borderStyle = UITextBorderStyleRoundedRect;
    
    tf_age.placeholder = @"年龄";
    
    [tf_age mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(tf_name.bottom).offset(20);
        
        make.width.equalTo(200);
        
    }];
    
    UILabel * lb_name = [[UILabel alloc]init];
    
    self.lb_name = lb_name;
    
    [self.view addSubview:lb_name];
    
    lb_name.text = @"姓名";
    
    [lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(tf_age.bottom).offset(50);
        
        
    }];
    
    UILabel * lb_age = [[UILabel alloc]init];
    
    self.lb_age = lb_age;
    
    [self.view addSubview:lb_age];
    
    lb_age.text = @"年龄";
    
    [lb_age mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(lb_name.bottom).offset(20);
        
    }];
    
}



@end
