//
//  MapVC.m
//  Signal processing
//
//  Created by fy on 16/8/29.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "MapVC.h"

#import "RACReturnSignal.h"

@interface MapVC ()

@property(nonatomic,strong)UILabel * lb_name;

@property(nonatomic,strong)UILabel * lb_age;

@property(nonatomic,strong)UITextField * tf_name;

@property(nonatomic,strong)UITextField * tf_age;

@end

@implementation MapVC

#pragma mark - 生命周期 -

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self createupUI];
    
    //测试Map方法
    [self testTheMethodOfMap];
    
    //测试FlatternMap
    [self testTheMethodOfFlatternMap];
}

-(void)dealloc{
    
    NSLog(@"销毁");
}

#pragma mark - UI -
-(void)createupUI{
    
    UITextField * tf_name = [[UITextField alloc]init];
    
    self.tf_name = tf_name;
    
    [self.view addSubview:tf_name];
    
    tf_name.borderStyle = UITextBorderStyleRoundedRect;
    
    tf_name.placeholder = @"姓名";
    
    [tf_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(self.view.top).offset(100);
        
        make.width.equalTo(200);
        
    }];
    
    UITextField * tf_age = [[UITextField alloc]init];
    
    self.tf_age = tf_age;
    
    [self.view addSubview:tf_age];
    
    tf_age.borderStyle = UITextBorderStyleRoundedRect;
    
    tf_age.placeholder = @"年龄";
    
    [tf_age mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(tf_name.bottom).offset(20);
        
        make.width.equalTo(200);
        
    }];
    
    UILabel * lb_name = [[UILabel alloc]init];
    
    self.lb_name = lb_name;
    
    [self.view addSubview:lb_name];
    
    lb_name.text = @"姓名";
    
    [lb_name mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(tf_age.bottom).offset(50);
        
        
    }];
    
    UILabel * lb_age = [[UILabel alloc]init];
    
    self.lb_age = lb_age;
    
    [self.view addSubview:lb_age];
    
    lb_age.text = @"年龄";
    
    [lb_age mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(self.view.centerX).offset(0);
        
        make.top.equalTo(lb_name.bottom).offset(20);
        
    }];
    
}

-(void)testTheMethodOfMap{
    
    //这里可以使用绑定写法来更快捷的达到目的,这里主要是为了体验map所以就不展示了,详情请看RACSignal的绑定
    //这里的映射(map)前面有讲过主要是为了对block的返回值进行处理
    @weakify(self);
    [[[self.tf_name rac_textSignal] map:^id(id value) {
        
        return [NSString stringWithFormat:@"名字是:%@",value];
        
    }] subscribeNext:^(id x) {
    
        @strongify(self);
        self.lb_name.text = x;
        
    }];
    
}

-(void)testTheMethodOfFlatternMap{
    
    
    //FlatternMap返回的是一个信号,而map返回的是信号,一般情况下我们使用的是map,只有信号中的信号我们才会使用FlatternMap
    //同时使用FlatternMap我们需要导入RACReturnSignal.h
    @weakify(self);
   [[[self.tf_age rac_textSignal] flattenMap:^RACStream *(id value) {
        
       return [RACReturnSignal return:[NSString stringWithFormat:@"年龄是:%@",value]];
       
   }] subscribeNext:^(id x) {
       
       @strongify(self);
       self.lb_age.text = x;
       
   }];
    
}


@end
