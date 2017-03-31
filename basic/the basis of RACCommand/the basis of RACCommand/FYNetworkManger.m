//
//  FYNetworkManger.m
//  FYBILIBILI
//
//  Created by fy on 16/8/4.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "FYNetworkManger.h"

@implementation FYNetworkManger

//三种解析json格式
- (instancetype)init
{
    self = [super init];
    if (!self) return nil;
    self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/plain",@"text/html", nil];
    return self;
}

+(instancetype)shareManager{
    
    static FYNetworkManger * _instance;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        _instance = [[self alloc]init];
        
    });
    
    return _instance;
}

@end
