//
//  RACSequenceVC.m
//  Lianxi
//
//  Created by fy on 16/8/9.
//  Copyright © 2016年 LY. All rights reserved.
//
/*
 RACSequence可以更高效的遍历数组和字典
 */
#import "RACSequenceVC.h"

@interface RACSequenceVC ()

@end

@implementation RACSequenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSArray * array = [self createNsarray];
    
    NSDictionary * dict = [self createDictionary];
    
    [self loadNsarray:array];
    
    [self loadDictionary:dict];
}
//创建
-(NSArray*)createNsarray{
    
    NSArray * array = @[@1,@2,@3,@4,@5,@4,@3,@2,@1];
    
    return array;
}
-(NSDictionary*)createDictionary{
    
    NSDictionary * dict = @{@"key1":@1,@"key2":@2,@"key3":@3};
    
    return dict;
}
//读取
-(void)loadNsarray:(NSArray*)array{
    
    [array.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }error:^(NSError *error) {
        NSLog(@"%@",error);
    }completed:^{
        NSLog(@"完成");
    }];
    

}

-(void)loadDictionary:(NSDictionary*)dict{
    
    [dict.rac_sequence.signal subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }error:^(NSError *error) {
        NSLog(@"%@",error);
    }completed:^{
        NSLog(@"完成");
    }];
}
@end
