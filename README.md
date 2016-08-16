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

#### RACSignal

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

![image](https://github.com/SkyHarute/StudyForRAC/blob/master/imageFile/1.png)

#### RACSubject




- 未完待续


















