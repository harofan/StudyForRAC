//
//  ViewController.m
//  the basis of RACSignal
//
//  Created by fy on 16/8/15.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewController.h"

#import "PersonViewModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    PersonViewModel * viewModel = [[PersonViewModel alloc]init];
    
    //这是signal对象方法中能把三种情况全部列举出来的对象方法,根据需求决定,一般使用最简单的就好
    [[viewModel loadInfo] subscribeNext:^(id x) {
        
        //接收到正常发送信号,并打印信号传过来的信息
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        //接收到错误信号,并打印出错误信息
        NSLog(@"%@",error);
        
    } completed:^{
        
        //接收到完成信号,并打印出完成信息,若为错误信号则不打印
        NSLog(@"完成");
        
    }];
}



@end
