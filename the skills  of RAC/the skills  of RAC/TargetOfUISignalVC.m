//
//  TargetOfUISignalVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/26.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "TargetOfUISignalVC.h"

@interface TargetOfUISignalVC ()

@property (weak, nonatomic) IBOutlet UITextField *textfiled;
@end

@implementation TargetOfUISignalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    //输出textfiled中的数据,具体的第一篇笔记有详细讲述
    [[self.textfiled rac_textSignal] subscribeNext:^(id x) {
        
        NSLog(@"%@",x);
    }];
}



@end
