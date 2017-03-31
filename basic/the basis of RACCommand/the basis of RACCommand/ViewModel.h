//
//  ViewModel.h
//  the basis of RACCommand
//
//  Created by fy on 16/8/22.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface ViewModel : NSObject

//这里需要对command进行强引用,否则无法执行
@property(nonatomic,strong)RACCommand * command;


@end
