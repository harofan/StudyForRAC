//
//  PersonViewModel.h
//  the basis of RACSignal
//
//  Created by fy on 16/8/15.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "PersonModel.h"

#import <ReactiveCocoa/ReactiveCocoa.h>

@interface PersonViewModel : NSObject

-(RACSignal*)loadInfo;

@end
