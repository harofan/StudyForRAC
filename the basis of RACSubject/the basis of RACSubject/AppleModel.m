//
//  AppleModel.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "AppleModel.h"

@implementation AppleModel

-(NSString *)description{
    
    NSArray * keys = @[@"price",@"weight"];
    
    return [self dictionaryWithValuesForKeys:keys].description;
}

@end
