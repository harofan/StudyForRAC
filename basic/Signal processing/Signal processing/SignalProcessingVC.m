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

@property(nonatomic,strong)RACSignal * testSignal;

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
    
//    [self testTheMethodOfDistinctUntilChanged];
    
//    [self testTheMethodOfTake];
    
//    [self testTheMethodOfTakeLast];
    
//    [self testTheMethodOfSkip];
    
    [self testTheMethodOfSwitcToLatest];
}

-(void)dealloc{
    
    NSLog(@"销毁");
}

#pragma mark - 即时搜索优化 -
-(void)optimizeSearch{
    
    UITextField * tf_search = [[UITextField alloc]init];
    
    //这段代码的意思是若0.3秒内无新信号(tf无输入),并且输入框内不为空那么将会执行,这对服务器的压力减少有巨大帮助同时提高了用户体验
    [[[[[[tf_search.rac_textSignal throttle:0.3]distinctUntilChanged]ignore:@""] map:^id(id value) {
        
        //这里使用的是信号中的信号这个概念
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            //  network request
            //  这里可将请求到的信息发送出去
            [subscriber sendNext:value];
            [subscriber sendCompleted];
            
            return [RACDisposable disposableWithBlock:^{
                
                //  cancel request
                // 这里可以将取消请求写在这里,若输入框有新输入信息那么将会发送一个新的请求,原来那个没执行完的请求将会执行这个取消请求的代码
                
            }];
        }];
    }]switchToLatest] subscribeNext:^(id x) {
        
        //这里获取信息
        
    }];

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
    
    //从这里可以看出只有与上一个信号所传递的值不相同订阅者才会打印
    [[self.testSignal distinctUntilChanged] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

//获取前n个信号
-(void)testTheMethodOfTake{
    
    [[self.testSignal take:3] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//获取最后几次信号
-(void)testTheMethodOfTakeLast{
    
    [[self.testSignal takeLast:3] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
    
}

//对信号的监听条件释放
-(void)testTheMethodOfTakeUntil{
 
    //当对象被销毁后将不再监听
    //这里takeuntil后面的参数可以自己创建信号
    [[self.nameSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//跳过几个信号不接收
-(void)testTheMethodOfSkip{
    
    [[self.testSignal skip:5] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    }];
}

//获取信号中信号的最新(最后一个)信号
-(void)testTheMethodOfSwitcToLatest{
    
    RACSignal * signalOfSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        [subscriber sendNext:self.testSignal];
        
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            
        }];
    }];
    
    [[signalOfSignal switchToLatest] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}

#pragma mark - 创建信号 -
-(void)createupSignal{
    
    RACSignal * nameSignal = [self.tf_name rac_textSignal];
    
    RACSignal * ageSignal = [self.tf_age rac_textSignal];
    
    self.nameSignal = nameSignal;
    
    self.ageSignal = ageSignal;
    
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
    
    self.testSignal = signal;
    
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
    
}

@end
