//
//  RACSubjectVC.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "RACSubjectVC.h"

@interface RACSubjectVC ()

@end

@implementation RACSubjectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createUI];
}

#pragma mark - UI -
-(void)createUI{
    
    self.navigationItem.title = @"RACSubject";
}
@end
