//
//  AppleViewModel.h
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <ReactiveCocoa/ReactiveCocoa.h>

#import "AppleModel.h"

@interface AppleViewModel : NSObject


-(RACReplaySubject* )loadInfo;

@end
