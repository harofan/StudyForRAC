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

@property(nonatomic,strong)RACSubject * subject;

@end

@implementation PersonViewModel

#pragma mark - 读取数据 -

-(RACSubject *)getSubject{
    
    RACSubject * subject = [RACSubject subject];
    
    self.subject = subject;
    
    return subject;
    
}
-( void)loadInfo{

    
    BOOL isError = NO;
    
    if (isError) {
        [self.subject sendError:[NSError errorWithDomain:@"github.com/SkyHarute" code:2333 userInfo:@{@"errorMessage":@"异常错误"}]];
    }else{
        
        [self creatInfo];
        
        [self.subject sendNext:_dataArray];
    }
    
    [self.subject sendCompleted];
    
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
