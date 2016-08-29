//
//  PersonModel.m
//  the basis of RACSignal
//
//  Created by fy on 16/8/15.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "PersonModel.h"

@implementation PersonModel

-(NSString *)description{
    
    NSArray * keys = @[@"name",@"age"];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
