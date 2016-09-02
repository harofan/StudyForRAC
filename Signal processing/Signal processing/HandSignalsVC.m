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
    
//    [self testTheMethodOfInterval];
    
    [self testTheMethodOfReplay];
    

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

//超时自动报错
-(void)testTheMethodOfTmeout{
    
    [[self.testSignal timeout:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        //超时一秒后会自动报错
        NSLog(@"%@",error);
        
    }];
}

-(void)testTheMethodOfInterval{
    
    //每一秒执行一次,这里要加上释放信号,否则控制器推出后依旧会执行,看具体需求吧
    [[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
      
        NSLog(@"%@",[NSDate date]);
        
    }];
    
}

//延时执行
-(void)testTheMethodOfDelay{
    
    [[self.testSignal delay:2] subscribeNext:^(id x) {
        
        NSLog(@"%@",[NSDate date]);
        
    }];
    
}

//若信号发送失败信息则会重新执行
-(void)testTheMethodOfRetry{
    
    [[self.testSignal retry] subscribeNext:^(id x) {
       
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    }];
}

-(void)testTheMethodOfReplay{
    //当一个信号被多次订阅时,不会每次都执行一遍副作用,而是像热信号一样只执行一遍,replay内部将信号封装RACMulticastConnection的热信号
    RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        static int a = 1;
        
        [subscriber sendNext:@(a)];
        
        a ++;
        
        return nil;
    }] replay];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者%@",x);
        
    }];
    
    [signal subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者%@",x);
        
    }];
}




@end
