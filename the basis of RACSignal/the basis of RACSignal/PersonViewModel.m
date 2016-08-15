//
//  PersonViewModel.m
//  the basis of RACSignal
//
//  Created by fy on 16/8/15.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "PersonViewModel.h"

@interface PersonViewModel()

@property(nonatomic,strong)NSMutableArray <PersonModel*>* dataArray;

@end

@implementation PersonViewModel

#pragma mark - 读取数据 -
-(RACSignal *)loadInfo{
    
    
    return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        BOOL isError = NO;
        
        if (isError) {
            
            //发送错误信息
            [subscriber sendError:[NSError errorWithDomain:@"github.com/SkyHarute" code:2333 userInfo:@{@"errorMessage":@"异常错误"}]];
            
        } else {
            
            //创建信息(只需要知道是给_dataArray赋值就可以)
            [self creatInfo];
            //若没有错误发送正确信息,并将数组送出
            [subscriber sendNext:_dataArray];
            
        }
        
        //正确信息发送完毕后发送完成信号,若信息为错误信息则不发送完成信号
        [subscriber sendCompleted];
        
        return nil;
    }];
}

#pragma mark - 创建数据 -
-(void)creatInfo{
    
     _dataArray = [NSMutableArray array];
    
    for (int i =0; i<20; i++) {
        
        PersonModel * model = [[PersonModel alloc]init];
        
        model.name = [@"zhangsan" stringByAppendingFormat:@"%d",i];
        model.age = 15 + arc4random_uniform(20);

        [_dataArray addObject:model];
    }
}
@end
