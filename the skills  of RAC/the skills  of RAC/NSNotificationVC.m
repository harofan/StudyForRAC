//
//  NSNotificationVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/25.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "NSNotificationVC.h"

@interface NSNotificationVC ()

@property (weak, nonatomic) IBOutlet UITextField *tf;
@end

@implementation NSNotificationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self sendNotification];
    
    [self getNotification];
    
}

-(void)getNotification{
    
    //代替通知
    //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {
        
        NSLog(@"键盘弹出");
        
    }];
    
    //这个写法有个问题,这样子写信号不会被释放,当你再次收到键盘弹出的通知时他会叠加上次的信号进行执行,并一直叠加下去,所以我们在用上面的写法
    //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
    //
    //        NSLog(@"键盘弹出");
    //
    //    }];
    
    //这里这样写只是为了给大家开拓一种思路,selector的方法可以应需求更改,即当这个方法执行后,产生一个信号告知控制器释放掉这个订阅的信号
    RACSignal * deallocSignal = [self rac_signalForSelector:@selector(viewWillDisappear:)];
    
    [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"haha" object:nil] takeUntil:deallocSignal] subscribeNext:^(id x) {
        
        NSLog(@"haha");
    }];
    
}

-(void)sendNotification{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"haha" object:nil userInfo:nil];
}
-(void)dealloc{
    
    NSLog(@"控制器销毁");
}

@end
