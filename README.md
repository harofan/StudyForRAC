## StudyForRAC

study for https://github.com/shuaiwang007/RAC

If you have some questions, please tell me.

My email address is fanyang_32012@outlook.com.

### RAC是一个非常强大的框架我们将会从以下方面去介绍它

[推荐在学习前先看下这个项目,比较简单也很好理解](https://github.com/SkyHarute/Functional-Programming)

* RACSignal
* RACSubject
* RACSequence
* RACMulticastConnection
* RACCommand

### 项目文件夹介绍

Lianxi 文件夹大致讲述了RAC框架一些简单的使用例子

the basis of RACSignal 文件夹主要讲述了RACSignal这个类该如何去使用

### 我们为什么要学习RAC?

RAC是github团队开发的一套超重量级开源框架

目的在于事件的监听,RAC几乎接管了Apple所有的事件机制,主要有以下四大点:

* addTarget

* 代理

* 通知

* KVO

* 时钟

* 网络异步回调

block不能列入其中的原因很简单.block是提前准备好的代码,传递给接收方,至于什么时候执行接收方并不知道

### RAC学习起来的特点

* 学习起来比较难
* 团队开发的时候需要谨慎使用
* 团队代码需要不断的评审,保证团队中所有人代码的风格一致!避免阅读代码的困难

### RAC框架如何pod导入项目

- 首先在podfile里把use_frameworks!的注释取消掉,即把#删掉即可,因为RAC框架是支持Swift的

- 再然后可以添加上 pod 'ReactiveCocoa', '~> 4.1.0'

- pod install即可

- 使用时只要将 'ReactiveCocoa.h' 'NSObject+RACKVOWrapper.h' 'RACReturnSignal.h' 这三个文件导入就可以了

- 注意:若出现大量报错的话,请将Xcode升级至7.3以上

### RAC框架的版本问题

- 4.0版本支持Swift2.0

- 3.0版本支持Swift1.2

- 2.5版本不支持Swift

若导入框架后出现报错注意排查

### RACSignal

- 首先在viewModel内创建信号,外界在调用读取信息方法时,向外界返回一个信号

        -(RACSignal *)loadInfo{


            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                BOOL isError = NO;

                if (isError) {

                    //发送错误信息
                    [subscriber sendError:[NSError errorWithDomain:@"github.com/SkyHarute" code:2333 userInfo:@{@"errorMessage":@"异常错误"}]];

                } else {

                    //创建信息(只需要知道是给_dataArray赋值就可以)
                    [self creatInfo];

                    //若没有错误发送正确信息,并将数组送出
                    [subscriber sendNext:_dataArray];

                }

                //正确信息发送完毕后发送完成信号,若信息为错误信息则不发送完成信号
                [subscriber sendCompleted];

                return nil;

            }];

        }

- 在控制器调用该方法读取信息获取到当前信号并订阅

        //这是signal对象方法中能把三种情况全部列举出来的对象方法,根据需求决定,一般使用最简单的就好
        [[viewModel loadInfo] subscribeNext:^(id x) {

            //接收到正常发送信号,并打印信号传过来的信息
            NSLog(@"%@",x);

        } error:^(NSError *error) {
    
            //接收到错误信号,并打印出错误信息
            NSLog(@"%@",error);

        } completed:^{

            //接收到完成信号,并打印出完成信息,若为错误信号则不打印
            NSLog(@"完成");

        }];

- 信号的三种对象方法sendNext,sendError,sendCompleted分别对应订阅者的next,error,completed三种情况,我们只要监听订阅者的三个代码块,并写上相应的代码,就可以实现在不同的代码块获得自己想要的东西.

- RAC在使用的时候由于系统提供的信号是始终存在的,所以在block中使用属性或者成员变量几乎都会涉及到一个循环引用的问题,有两种方法可以解决,使用weakself解决或者RAC提供的weak-strong dance.用法也比较简单:在 block 的外部使用 @weakify(self),在 block 的内部使用 @strongify(self),具体的方法会在demo或下文中看到

#### 列举一些RAC常用的事件处理,这里教大家一个技巧,通过查看RAC框架中UI控件的分类便可以得知

* 按钮点击

        @weakify(self);

        [[self.btn_event rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

            @strongify(self);

            NSLog(@"%@",self.dataArray.firstObject);

        }];

* textField输入内容的实时监听

        [[self.tf_name rac_textSignal] subscribeNext:^(id x) {
    
        NSLog(@"%@",x);
        
        }];

* 组合信号的使用,我们想将两个信号整合成一个信号的话这样做就可以了,这样就避免了同时订阅两个信号的苦恼

        //信号组合获取,注意将id类型改为RACTuple

        [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal]] subscribeNext:^(RACTuple *x) {

            NSString * name = x.first;

            NSString * age = x.second;

            NSLog(@"name:%@,age:%@",name,age);

        }];

* 信号组合时reduce的使用

        //根据textfield内容决定按钮是否可以点击

        // reduce 中，可以通过接收的参数进行计算，并且返回需要的数值！

        [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal] reduce:^id(NSString * name , NSString * age){

            return @(name.length>0&&age.length>0);

        }] subscribeNext:^(id x) {

            @strongify(self);

            self.btn_event.enabled = [x boolValue];

        }];

#### 双向绑定

一般双向绑定是指UI控件和模型互相绑定的,一般是在在改变一个值的情况下另外一个对象也会改变,类似KVO,但KVO写的时候很多观察属性写在一个方法里对代码的可阅读性并不是很好

这里为了更好的体现出效果所以采用了textfield绑定到模型,模型绑定到label的做法,比较好理解,这样在textfiled输入文字便能够实时改变模型值,而模型值一旦改变,label的text内容也会随之改变.

* UI绑定模型

        PersonModel * model = [[PersonModel alloc]init];

        model = self.dataArray.firstObject;

        RAC(self.lb_name,text)=RACObserve(model, name);

        //这里不能使用基本数据类型,RAC中传递的都是id类型,使用基本类型会崩溃,所以使用map方法对返回值进行了更替

        RAC(self.lb_age,text)=[RACObserve(model, age) map:^id(id value) {

            return [value description];
        }];

* 模型到UI
        [[RACSignal combineLatest:@[self.tf_name.rac_textSignal,self.tf_age.rac_textSignal]] subscribeNext:^(RACTuple * x) {

        model.name = x.first;
        model.age = [x.second intValue];
        }];

![image](https://github.com/SkyHarute/StudyForRAC/blob/master/imageFile/1.png)

### RACSubject




- 未完待续


















