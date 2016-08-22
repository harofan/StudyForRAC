//
//  ViewController.m
//  the basis of RACCommand
//
//  Created by fy on 16/8/22.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewController.h"

#import "ViewModel.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    ViewModel * vm = [[ViewModel alloc]init];
    
    [vm loadInfo];
    
    //取到command信号中的信号,对其进行订阅
    [vm.command.executionSignals.switchToLatest subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"完成");
    }];
    
    //取到command信号
    [vm.command.executionSignals subscribeNext:^(id x) {
        
        NSLog(@"-------------------------%@",[x class]);
        NSLog(@"这里获取到的x是一个带有数据的信号,需要对x做进一步订阅就可以获取到数据如上所示");
    }];
    
    [vm.command execute:@0];
}

@end
