//
//  DelegateSecondVC.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "DelegateSecondVC.h"

@interface DelegateSecondVC ()

@end

@implementation DelegateSecondVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (IBAction)didClickBtn:(UIButton *)sender {
    
    if (self.delagetaSubject) {
        [self.delagetaSubject sendNext:@"haha"];
        
        //若想要持续代理必须注释掉这一步
//        [self.delagetaSubject sendCompleted];
    }
}


@end
