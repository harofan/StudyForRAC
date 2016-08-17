//
//  ViewController.m
//  the basis of RACSignal
//
//  Created by fy on 16/8/15.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewController.h"

#import "PersonViewModel.h"

@interface ViewController ()

@property (weak, nonatomic) IBOutlet UIButton *btn_event;

@property (weak, nonatomic) IBOutlet UITextField *tf_age;

@property (weak, nonatomic) IBOutlet UITextField *tf_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_name;

@property (weak, nonatomic) IBOutlet UILabel *lb_age;

@property (strong, nonatomic)NSArray * dataArray;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //获取信息
    [self getInfo];
    
    //处理事件
//    [self handlingEvents];
    
    [self twoWayBinding];
}

#pragma mark - 获取信息 -
-(void)getInfo{
    
    PersonViewModel * viewModel = [[PersonViewModel alloc]init];
    
    //这是signal对象方法中能把三种情况全部列举出来的对象方法,根据需求决定,一般使用最简单的就好
    [[viewModel loadInfo] subscribeNext:^(id x) {
        
        //接收到正常发送信号,并打印信号传过来的信息
        NSLog(@"%@",x);
        
        self.dataArray = [NSArray array];
        
        self.dataArray = x;
        
    } error:^(NSError *error) {
        
        //接收到错误信号,并打印出错误信息
        NSLog(@"%@",error);
        
    } completed:^{
        
        //接收到完成信号,并打印出完成信息,若为错误信号则不打印
        NSLog(@"完成");
        
    }];
}

#pragma mark - 处理事件 -
-(void)handlingEvents{
    
    //按钮点击
    [[self.btn_event rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        NSLog(@"%@",self.dataArray.firstObject);
        
    }];


    //name输入框输入内容实时监听
    [[self.tf_name rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //年龄输入框输入内容实时监听
    [[self.tf_age rac_textSignal] subscribeNext:^(id x) {
        NSLog(@"%@",x);
    }];
    
    //信号组合获取,注意将id类型改为RACTuple
    [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal]] subscribeNext:^(RACTuple *x) {
        
        NSString * name = x.first;
        
        NSString * age = x.second;
        
        NSLog(@"name:%@,age:%@",name,age);
    }];
    
    //根据textfield内容决定按钮是否可以点击
    // reduce 中，可以通过接收的参数进行计算，并且返回需要的数值！
    [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal] reduce:^id(NSString * name , NSString * age){
        
        return @(name.length>0&&age.length>0);
        
    }] subscribeNext:^(id x) {
        
        self.btn_event.enabled = [x boolValue];
        
    }];
    
}

#pragma mark - 双向绑定 -
-(void)twoWayBinding{
    
    //一般双向绑定是指UI控件和模型互相绑定的,一般是在在改变一个值的情况下另外一个对象也会改变,类似KVO;
    //这里为了更好的体现出效果所以采用了textfield绑定到模型,模型绑定到label的做法,比较好理解
    
    //UI绑定模型
    PersonModel * model = [[PersonModel alloc]init];
    
    model = self.dataArray.firstObject;
    
    RAC(self.lb_name,text)=RACObserve(model, name);
    
#warning 这里不能使用基本数据类型,RAC中传递的都是id类型,使用基本类型会崩溃
    RAC(self.lb_age,text)=[RACObserve(model, age) map:^id(id value) {
        return [value description];
    }];
    //模型到UI
    [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal]] subscribeNext:^(RACTuple * x) {
        
        model.name = x.first;
        model.age = [x.second intValue];
    }];
     
    
}

@end
