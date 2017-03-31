//
//  FYRequestTool.h
//  FYBILIBILI
//
//  Created by fy on 16/8/4.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "FYNetworkManger.h"

@interface FYRequestTool : NSObject

//中间必须有值
NS_ASSUME_NONNULL_BEGIN
+ (nullable NSURLSessionDataTask *)GET:(NSString *)URLString
                            parameters:(nullable id)parameters
                              progress:(nullable void (^)(NSProgress *downloadProgress))downloadProgress
                               success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                               failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;


+ (nullable NSURLSessionDataTask *)POST:(NSString *)URLString
                             parameters:(nullable id)parameters
                               progress:(nullable void (^)(NSProgress *uploadProgress))uploadProgress
                                success:(nullable void (^)(NSURLSessionDataTask *task, id _Nullable responseObject))success
                                failure:(nullable void (^)(NSURLSessionDataTask * _Nullable task, NSError *error))failure;

+ (void)cancel;

@end
NS_ASSUME_NONNULL_END