//
//  EventVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/25.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "EventVC.h"

@interface EventVC ()

@end

@implementation EventVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createupUI];
}

#pragma mark - UI -
-(void)createupUI{
    
    UIButton * btn = [[UIButton alloc] init];
    
    [self.view addSubview:btn];
    
    [btn setTitle:@"button" forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
    
    [btn makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.view);
    }];
    
    [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"点击了按钮");
    }];
}



@end
