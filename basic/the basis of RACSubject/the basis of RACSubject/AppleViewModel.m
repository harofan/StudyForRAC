//
//  AppleViewModel.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "AppleViewModel.h"

@interface AppleViewModel ()

@property(nonatomic,strong)NSMutableArray * dataArray;

@end

@implementation AppleViewModel

-(RACReplaySubject* )loadInfo{
    
    RACReplaySubject * replaySubject = [RACReplaySubject subject];
    
    BOOL isError = NO;
    
    if (isError) {
        [replaySubject sendError:[NSError errorWithDomain:@"github.com/SkyHarute" code:2333 userInfo:@{@"errorMessage":@"异常错误"}]];
    } else {
        
        [self creatInfo];
        
        [replaySubject sendNext:self.dataArray];
    }
    
    [replaySubject sendCompleted];

    return replaySubject;
}

#pragma mark - 创建数据 -
-(void)creatInfo{
    
    _dataArray = [NSMutableArray array];
    
    for (int i =0; i<20; i++) {
        
        AppleModel  * model = [[AppleModel  alloc]init];
        
        model.price = [NSString stringWithFormat:@"%@",@(1 + arc4random_uniform(3))];
        model.weight =[NSString stringWithFormat:@"%@",@(15 + arc4random_uniform(20))];
        
        [_dataArray addObject:model];
    }
    
    NSLog(@"%@",self.dataArray);
}

@end
