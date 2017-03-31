//
//  TimerVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/26.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "TimerVC.h"

@interface TimerVC ()

@end

@implementation TimerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
//    [self test1];
    
    [self test2];
}

-(void)test1{
    
    //五秒后执行一次
    [[RACScheduler mainThreadScheduler]afterDelay:5 schedule:^{
        
        NSLog(@"五秒后执行一次");
    }];
}

-(void)test2{
    
    //每隔两秒执行一次
    //这里要加takeUntil条件限制一下否则当控制器pop后依旧会执行
    [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {
        
        NSLog(@"每两秒执行一次");
    }];
}

@end
