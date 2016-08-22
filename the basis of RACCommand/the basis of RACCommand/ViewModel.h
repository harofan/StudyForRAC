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

@property(nonatomic,strong)RACCommand * command;

-(void)loadInfo;

@end
