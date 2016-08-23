//
//  ViewModel.m
//  the basis of RACCommand
//
//  Created by fy on 16/8/22.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewModel.h"

#import "FYRequestTool.h"

@implementation ViewModel

//这里使用懒加载对command赋值
-(RACCommand *)command{
    
    if (nil == _command) {
        
        [self loadInfo];
    }
    return _command;
}

-(void)loadInfo{
    
    //input就是控制器中,viewmodel执行command时excute传入的参数
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        //command必须有信号返回值,如果没有的话可以为[RACSignal empty]
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
        {
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            
            params[@"build"] = @"3360";
            params[@"channel"] = @"appstore";
            params[@"plat"] = @"2";
            
            [FYRequestTool GET:@"http://app.bilibili.com/x/banner" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                //发送完信号必须发送完成信号,否则无法执行
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendError:error];
                
            }];
            
            return [RACDisposable disposableWithBlock:^{
                
                [FYRequestTool cancel];
                
                NSLog(@"这里面可以写取消请求,完成信号后请求会取消");
                
            }];
        }];
    }];
    
    //必须强引用这个command,否则无法执行
    self.command = command;
    
}

@end
