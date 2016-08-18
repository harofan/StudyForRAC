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
        [self.delagetaSubject sendCompleted];
    }
}


@end
