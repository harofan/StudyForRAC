//
//  ViewModel.m
//  the basis of RACCommand
//
//  Created by fy on 16/8/22.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewModel.h"

#import "FYRequestTool.h"



//http://app.bilibili.com/x/banner

//NSMutableDictionary *params = [NSMutableDictionary dictionary];
//params[@"build"] = @"3360";
//params[@"channel"] = @"appstore";
//params[@"plat"] = @"2";

@implementation ViewModel


-(void)loadInfo{
    
    RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
        
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
        {
            
            NSMutableDictionary * params = [NSMutableDictionary dictionary];
            
            params[@"build"] = @"3360";
            params[@"channel"] = @"appstore";
            params[@"plat"] = @"2";
            
            [FYRequestTool GET:@"http://app.bilibili.com/x/banner" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                
                [subscriber sendNext:responseObject];
                
                [subscriber sendCompleted];
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                
                [subscriber sendError:error];
                
            }];
            
            return [RACDisposable disposableWithBlock:^{
                
                [FYRequestTool cancel];
                
                NSLog(@"取消");
                
            }];
        }];
    }];
    
    self.command = command;
    
}

@end
