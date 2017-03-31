//
//  KVOVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/25.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "KVOVC.h"

@interface KVOVC ()

@end

@implementation KVOVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}

#pragma mark - UI -
-(void)createUI{
    
    UIScrollView * scrollView = [[UIScrollView alloc] init];
    
    [self.view addSubview:scrollView];
    
    UIView * contentView = [[UIView alloc]init];
    
    [scrollView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
 
    }];
    
    [scrollView addSubview:contentView];
    
    [contentView makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(0);
        make.width.height.equalTo(1000);
    }];
    
    //代替KVO
    [RACObserve(scrollView, contentOffset) subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
    
    
}

@end
