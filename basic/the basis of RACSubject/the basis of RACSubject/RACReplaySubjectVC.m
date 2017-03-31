//
//  RACReplaySubjectVC.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "RACReplaySubjectVC.h"

#import "AppleViewModel.h"

@interface RACReplaySubjectVC ()

@end

@implementation RACReplaySubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
    
    [self getInfo];
}

#pragma mark - UI -
-(void)createUI{
    
    self.navigationItem.title = @"RACReplaySubject";
}

//RACReplaySubject对于订阅和发送信号的顺序掌握的比较宽松,可以先发送信号在进行订阅也可以
-(void)getInfo{
    
    AppleViewModel * viewModel = [[AppleViewModel alloc]init];
    
    [[viewModel loadInfo] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
        
    } error:^(NSError *error) {
        
        NSLog(@"%@",error);
        
    } completed:^{
        
        NSLog(@"完成");
    }];
}

@end
