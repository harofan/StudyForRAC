//
//  RACSubjectDelegateVC.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "RACSubjectDelegateVC.h"

#import "DelegateSecondVC.h"

@interface RACSubjectDelegateVC ()

@property(nonatomic,strong)RACSubject * subject;

@end

@implementation RACSubjectDelegateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.navigationItem.title = @"RACSubjectDelegate";
    
}
//跳转到第二个页面
- (IBAction)didClickNextBtn:(UIButton *)sender {
    
    DelegateSecondVC * vc = [[DelegateSecondVC alloc] init];
    
    RACSubject * subject = [RACSubject subject];
    //将即将跳转的控制器对其RACSubject属性进行赋值,如果跳转页要让他的代理来做什么只需要发送响应的信号就可以了
    vc.delagetaSubject = subject;
    
    self.subject = subject;
    //这里有个原则,那就是还是要先订阅在发送信号
    [self getInfo];
    
    [self.navigationController pushViewController:vc animated:YES];
}

#pragma mark - 订阅信号 -
-(void)getInfo{
    
    [self.subject subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        NSLog(@"%@",error);
    } completed:^{
        NSLog(@"完成");
    }];
}

@end
