## StudyForRAC

[简书博客地址](http://www.jianshu.com/users/452e0bd1e30f/latest_articles)

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

the basis of RACSubject 文件夹主要讲述了RACSubject与RACSignal的小区别,以及RACSubject如何作为代理去使用 

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

        //这里不能使用基本数据类型,RAC中传递的都是id类型,使用基本类型会崩溃,所以使用map(映射)对返回值进行了更替,映射你可以理解成将一个东西变换成另一个吧,比如数据类型,字符串格式等等都可以这么做.

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

RACSubject与RACSignal在发送信号这件事上是基本相同的,用法也是差不多相同的,不同点是RACSubject需要先订阅,然后再发送信号,控制器才能够处理信号,RACReplaySubject则不用考虑订阅信号的先后顺序,所以比较推荐使用这个.另外RACSubject也可以用作代理代理,当然这也是有限制的,只能替代那些没有返回值的代理.

#### RACSubject的使用

与RACSignal类似,我们先要订阅信号,在发送信号,否则会导致信号无法执行,读取信号的时候可以通过懒加载进行读取

- 控制器接收信号部分

        PersonViewModel * viewModel = [[PersonViewModel alloc]init];

        //这是错误做法,先发送信号再订阅信号的话对于RACSubject来说的话是不可以的,RACReplaySubject可以先发送信号再去订阅
        //    [viewModel loadInfo];

        //先获取到RACSubject,再订阅他,和RACSignal基本相同的方式
        [[viewModel getSubject] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            NSLog(@"%@",error);

        } completed:^{

            NSLog(@"完成");

        }];

        //发送信号
        [viewModel loadInfo];

- viewModel发送信号部分

        BOOL isError = NO;

        if (isError) {

            [self.subject sendError:[NSError errorWithDomain:@"github.com/SkyHarute" code:2333 userInfo:@{@"errorMessage":@"异常错误"}]];

        }else{

            [self creatInfo];

            [self.subject sendNext:_dataArray];
        }

        [self.subject sendCompleted];

#### RACReplaySubject的使用

与RACSubject不同,RACReplaySubject在使用时不用过多的考虑订阅与信号发送先后的问题

- 控制器端

        AppleViewModel * viewModel = [[AppleViewModel alloc]init];
        //这里可以不用考虑是先订阅还是先发送信号的问题
        [[viewModel loadInfo] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            NSLog(@"%@",error);

        } completed:^{

            NSLog(@"完成");

        }];

- viewModel端与RACSubject相似

#### RACSubject作为代理

RACSubject作为代理有些局限性,代理方法不能有返回值

- 系统的代理,这里举例一个UIAlertView的代理

        [[self rac_signalForSelector:@selector(alertView:clickedButtonAtIndex:) fromProtocol:@protocol(UIAlertViewDelegate)] subscribeNext:^(RACTuple * x) {

            NSLog(@"%@",x);

        }];
        
- 自己写的一个代理,在push之前的控制器执行这段代码

        DelegateSecondVC * vc = [[DelegateSecondVC alloc] init];

        RACSubject * subject = [RACSubject subject];

        //将即将跳转的控制器对其RACSubject属性进行赋值,如果跳转页要让他的代理来做什么只需要发送响应的信号就可以了
        vc.delagetaSubject = subject;

        //这里有个原则,那就是还是要先订阅在发送信号
        [subject subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            NSLog(@"%@",error);

        } completed:^{

            NSLog(@"完成");

        }];

        [self.navigationController pushViewController:vc animated:YES];

- 在push的第二个页面执行这段代码,就可以了,self.delagetaSubject是暴露在头文件的一个属性,需要第一个控制器来提供,详情请参考demo

        if (self.delagetaSubject) {

            [self.delagetaSubject sendNext:@"haha"];

            [self.delagetaSubject sendCompleted];
        }

### RACCommand

#### RACCommand的普通使用

一般情况下,RACCommand主要用来封装一些请求,事件等,举个例子,我们的tableView在下拉滚动时若想刷新数据需要向接口提供页码或者最后一个数据的ID,我们可以把请求封装进RACCommand里,想要获取数据的时候只要将页码或者ID传入RACCommand里就可以了,同时监控RACCommand何时完成,若完成后将数据加入到tableview的数组就可以了,这是一个平常用的比较多的场景.使用是主要有三个注意点

* RACCommand必须返回信号,信号可以为空

* RACCommand必须强引用

* RACCommand发送完数据必须发送完成信号

- 在viewModel中创建RACCommand,同时利用懒加载,在外界获取command的时候,直接执行下面这个方法

        -(void)loadInfo{

            //input就是控制器中,viewmodel执行command时excute传入的参数
            RACCommand * command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {

                //command必须有信号返回值,如果没有的话可以为[RACSignal empty]
                return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber)
                        {
                            NSMutableDictionary * params = [NSMutableDictionary dictionary];

                            params[@"build"] = @"3360";
                            params[@"channel"] = @"appstore";
                            params[@"plat"] = @"2";

                            [FYRequestTool GET:@"http://app.bilibili.com/x/banner" parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

                                [subscriber sendNext:responseObject];

                                //发送完信号必须发送完成信号,否则无法执行
                                [subscriber sendCompleted];

                            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {

                                [subscriber sendError:error];

                            }];

                        return [RACDisposable disposableWithBlock:^{

                                [FYRequestTool cancel];

                                NSLog(@"这里面可以写取消请求,完成信号后请求会取消");

                                }];
                        }];
                }];

            //必须强引用这个command,否则无法执行
            self.command = command;

        }

- 在控制器端取到viewModel模型,并对command中带有数据的信号进行订阅,这里需要明白信号中的信号这个含义,RAC中最基础的就是信号,command也是一个信号,与signal不同的是,它返回的并不是数据而是一个信号,这个信号上带有数据

        ViewModel * vm = [[ViewModel alloc]init];

        //取到command信号中的信号,对其进行订阅
        [vm.command.executionSignals.switchToLatest subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            NSLog(@"%@",error);

        } completed:^{

            NSLog(@"完成");

        }];

        //必须要加这句话,否则command无法执行,excute传的参数若无用可以为nil,传的参数就是viewModel中RACCommand中block的input值,根据这个值我们可以做许多事情
        //例如,封装一个tableview的翻页请求,每次翻页的时候可以通过excute把翻页的页码给他
        [vm.command execute:nil];

- 我们再来看一下RACCommand直接进行订阅是什么结果

        //取到command信号
        [vm.command.executionSignals subscribeNext:^(id x) {

            NSLog(@"-------------------------%@",[x class]);

            NSLog(@"这里获取到的x是一个带有数据的信号,需要对x做进一步订阅就可以获取到数据如上所示");

        }];

- 打印结果是

        2016-08-23 18:13:42.437 the basis of RACCommand[10910:768132] -------------------------RACDynamicSignal
        2016-08-23 18:13:42.437 the basis of RACCommand[10910:768132] 这里获取到的x是一个带有数据的信号,需要对x做进一步订阅就可以获取到数据如上所示

由此可知RACCommand也是一个信号

#### 监听RACCommand是否完成

-原理很简单,还是利用的信号中的信号这一理念

        //监听命令是否完成
        [vm.command.executing subscribeNext:^(id x) {

            //这里的x是一个带有数据的信号,若这个信号存在那么就说明command还在执行,否则说明没有执行或者执行完毕
            if ([x boolValue]) {
                NSLog(@"正在执行");
            } else {
                NSLog(@"执行未开始/执行完毕");
            }
        }];

- 未完待


















