//
//  FYNetworkManger.h
//  FYBILIBILI
//
//  Created by fy on 16/8/4.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>

@interface FYNetworkManger : AFHTTPSessionManager
//获取单例
+(instancetype)shareManager;

@end
