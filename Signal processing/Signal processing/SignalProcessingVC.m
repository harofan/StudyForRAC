//
//  SignalProcessingVC.m
//  Signal processing
//
//  Created by fy on 16/8/29.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "SignalProcessingVC.h"

@interface SignalProcessingVC ()

@property(nonatomic,strong)UITextField * tf_name;

@property(nonatomic,strong)UITextField * tf_age;

@property(nonatomic,strong)RACSignal * nameSignal;

@property(nonatomic,strong)RACSignal * ageSignal;

@end

@implementation SignalProcessingVC

#pragma mark - 生命周期 -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createupUI];
    
    [self createupSignal];
    
//    [self testOfTheMethodOfFilter];
    
//    [self testOfTheMethodOfIgnore];
    
    [self testTheMethodOfDistinctUntilChanged];
}

-(void)dealloc{
    
    NSLog(@"销毁");
}

#pragma mark - 测试方法 -
//过滤
-(void)testOfTheMethodOfFilter{
    
    //对value进行过滤,若value的值满足条件订阅者才能够订阅到
    [[self.nameSignal filter:^BOOL(NSString * value) {
        
        return value.length>3;
        
    }] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//忽略
-(void)testOfTheMethodOfIgnore{
    
    //当信号传输的数据时ignore后的参数时,订阅者就会忽略这个信号,ignore可以嵌套,一般用来判断非空
    [[[self.nameSignal ignore:@"A"] ignore:@"B"] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//数据不同信号才会被订阅到
-(void)testTheMethodOfDistinctUntilChanged{
    
    //输入不同的字符才会获取到数值,可以用在对服务器的请求上过滤一些相同的请求,降低服务器压力
    //演示效果可能不太好,我重新写一组信号
    [[self.nameSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:@1];
        [subscriber sendNext:@1];
        [subscriber sendNext:@2];
        [subscriber sendNext:@1];
        [subscriber sendNext:@1];
        [subscriber sendNext:@3];
        [subscriber sendNext:@1];
        [subscriber sendNext:@1];
        [subscriber sendNext:@1];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    //从这里可以看出只有与上一个信号所传递的值不相同订阅者才会打印
    [[signal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - 创建信号 -
-(void)createupSignal{
    
    RACSignal * nameSignal = [self.tf_name rac_textSignal];
    
    RACSignal * ageSignal = [self.tf_age rac_textSignal];
    
    self.nameSignal = nameSignal;
    
    self.ageSignal = ageSignal;
    
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
    
//    UIButton * sendA = [[UIButton alloc]init];
//    
//    [self.view addSubview:sendA];
//    
//    [sendA setTitle:@"向name输入栏发送A" forState:UIControlStateNormal];
//    
//    [sendA setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [sendA mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.view.centerX).offset(0);
//        
//        make.top.equalTo(tf_age.bottom).offset(50);
//        
//    }];
//    
//    [[sendA rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        self.tf_name.text = @"A";
//    }];
//    
//    UIButton * sendB = [[UIButton alloc]init];
//    
//    [sendB setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
//    
//    [self.view addSubview:sendB];
//    
//    [sendB setTitle:@"向name输入栏发送B" forState:UIControlStateNormal];
//    
//    [sendB mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerX.equalTo(self.view.centerX).offset(0);
//        
//        make.top.equalTo(sendA.bottom).offset(20);
//        
//    }];
//    
//    [[sendB rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
//        
//        self.tf_name.text = @"B";
//    }];
    
}

@end
