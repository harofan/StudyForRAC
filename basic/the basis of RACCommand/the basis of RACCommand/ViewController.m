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
    
    //监听命令是否完成
    [vm.command.executing subscribeNext:^(id x) {
       
        //这里的x是一个带有数据的信号,若这个信号存在那么就说明command还在执行,否则说明没有执行或者执行完毕
        if ([x boolValue]) {
            NSLog(@"正在执行");
        } else {
            NSLog(@"执行未开始/执行完毕");
        }
    }];
    
    //必须要加这句话,否则command无法执行,excute传的参数若无用可以为nil,传的参数就是viewModel中RACCommand中block的input值,根据这个值我们可以做许多事情
    //例如,封装一个tableview的翻页请求,每次翻页的时候可以通过excute把翻页的页码给他
    [vm.command execute:nil];
}

@end
