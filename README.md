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

the basis of RACCommand 文件夹主要讲的是RACCommand如何使用,并监听完成情况

the skills of RAC 文件夹主要讲的是RAC的使用技巧,主要包括UI控件addTarget的替代,代替代理,代替通知,代替KVO,监听事件,定时器

Signal processing 文件夹主要讲的是信号的组合和处理

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

* 直接双向绑定

        RACChannelTo(self.lb_name,text) = RACChannelTo(model, name);

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

            //若想要持续代理必须注释掉这一步
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

### RAC的使用技巧

#### 代替代理

- 使用RAC代替代理时,rac_signalForSelector: fromProtocol:这个代替代理的方法使用时,切记要将self设为代理这句话放在订阅代理信号的后面写,否则会无法执行
        
        //这里订阅收到的是一个x,当一个页面存在多个tableview时,我们可以对x进行判断看是哪个tableview
        [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:) fromProtocol:@protocol(UITableViewDelegate) ] subscribeNext:^(RACTuple * x) {

            NSLog(@"点击了");

            NSLog(@"%@,%@",x.first,x.second);

        }];

        //这样子不带协议是无法代替代理的,虽然能达到效果,这个方法表示某个selector被调用时执行一段代码.带有协议参数的表示该selector实现了某个协议，所以可以用它来实现Delegate。
        //    [[self rac_signalForSelector:@selector(tableView:didSelectRowAtIndexPath:)] subscribeNext:^(RACTuple* x) {
                
        //        NSLog(@"%@",[x class]);

        //        NSLog(@"%@",x);
        //    }];

        //这里是个坑,必须将代理最后设置,否则信号是无法订阅到的
        //雷纯峰大大是这样子解释的:在设置代理的时候，系统会缓存这个代理对象实现了哪些代码方法
        //如果将代理放在订阅信号前设置,那么当控制器成为代理时是无法缓存这个代理对象实现了哪些代码方法的
        tableview.delegate = self;

#### 代替KVO

- 使用RAC代替KVO很简单,一句话就可以搞定,而且相比传统的KVO,不仅代码不用放在一起写美观了很多,同时还能达到高聚合低耦合的目标

        //代替KVO
        [RACObserve(scrollView, contentOffset) subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 监听事件

- 同样简单,一句话搞定

        [[btn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {

            NSLog(@"点击了按钮");

        }];

#### 代替通知

- 这里是有个坑的,单纯的写完订阅通知的信号会发现每次都会执行,而且叠加次数会增加,效果如图所示,所以我们要想办法把通知订阅的信号给释放掉,所以用到了takeUntil这个方法,后面我会把它和别的方法放在一起详细讲的

![image](https://github.com/SkyHarute/StudyForRAC/blob/master/imageFile/2.jpg)

- 以textfiled成为第一响应者接收键盘弹出的通知为例,我们可以这么写通知

        //代替通知
        //takeUntil会接收一个signal,当signal触发后会把之前的信号释放掉
        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {

            NSLog(@"键盘弹出");

        }];

- 这个方法虽然能得到相同的效果,但并不能代替通知

        //这个写法有个问题,这样子写信号不会被释放,当你再次收到键盘弹出的通知时他会叠加上次的信号进行执行,并一直叠加下去,所以我们在用上面的写法
        //    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:UIKeyboardDidShowNotification object:nil] subscribeNext:^(id x) {
        
        //        NSLog(@"键盘弹出");

        //    }];

- 这里再给大家举例一个写法思路,可以自己创建一个信号,当这个信号执行时通知会被释放

        //这里这样写只是为了给大家开拓一种思路,selector的方法可以应需求更改,即当这个方法执行后,产生一个信号告知控制器释放掉这个订阅的信号
        RACSignal * deallocSignal = [self rac_signalForSelector:@selector(viewWillDisappear:)];

        [[[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"haha" object:nil] takeUntil:deallocSignal] subscribeNext:^(id x) {

            NSLog(@"haha");

        }];

#### 定时器

- 延时执行

        //五秒后执行一次
        [[RACScheduler mainThreadScheduler]afterDelay:5 schedule:^{

            NSLog(@"五秒后执行一次");

        }];

- 定时执行

        //每隔两秒执行一次
        //这里要加takeUntil条件限制一下否则当控制器pop后依旧会执行
        [[[RACSignal interval:2 onScheduler:[RACScheduler mainThreadScheduler]] takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {

            NSLog(@"每两秒执行一次");

        }];

#### 代替addTarget

- 详细的使用方法在我写RACSignal时有写,基本技巧就是翻看RAC框架中UI控件的分类基本就可以得知方法

        //输出textfiled中的数据,具体的第一篇笔记有详细讲述
        [[self.textfiled rac_textSignal] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

### 信号的组合处理

- 本部分参考了峥吖前辈的博客,并结合了自己的一些实践和想法

#### 信号的依赖

- 使用场景是当信号A执行完才会执行信号B,和请求的依赖很类似,例如请求A请求完毕才执行请求B,我们需要注意信号A必须要执行发送完成信号,否则信号B无法执行

        //这相当于网络请求中的依赖,必须先执行完信号A才会执行信号B
        //经常用作一个请求执行完毕后,才会执行另一个请求
        //注意信号A必须要执行发送完成信号,否则信号B无法执行
        RACSignal * concatSignal = [self.signalA concat:self.signalB];

        //这里我们是对这个拼接信号进行订阅
        [concatSignal subscribeNext:^(id x) {
    
            NSLog(@"%@",x);

        }];

#### 信号的条件执行

- 使用场景当信号A执行后才会执行信号B,同时信号A不会被订阅到,也就不会被执行

        //当地一个信号执行完才会执行then后面的信号,同时第一个信号发送出来的东西不会被订阅到
        @weakify(self);
        [[self.signalA then:^RACSignal *{

            @strongify(self);
            return self.signalB;

        }] subscribeNext:^(id x) {

            //这里只会打印出信号B的数据
            NSLog(@"%@",x);

        }];

#### 信号的组合

- 将信号A和信号B组合为一个信号,当其中一个信号发送数据时,组合信号也可以订阅到.

        RACSignal * nameSignal = [self.tf_name rac_textSignal];

        RACSignal * ageSignal = [self.tf_age rac_textSignal];

        //将两个信号组成为一个信号,若其中一个子信号发送了对象,那么组合信号也能够订阅到
        RACSignal * mergeSignal = [nameSignal merge:ageSignal];

        [mergeSignal subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 信号的压缩,须成对

- 信号A和信号B会压缩成为一个信号,当信号A和信号B发出的信号成对存在时这个压缩后的元祖才会触发压缩流的next事件,注意要'成对',不成对的话其中一个信号发送多次也不会被订阅到

        //信号A和B会压缩成为一个信号,当二者'同时'发送数据时,并且把两个信号的内容合并成一个元组，才会触发压缩流的next事件
        //注意这里的'同时'二字指的并不是时间上的同时,只要信号A发送,信号B也发送就可以了,并不需要同时,但一定要成对
        RACSignal * zipSignal1 = [self.signalA zipWith:self.signalB];

        [zipSignal1 subscribeNext:^(id x) {

            NSLog(@"%@",x);
    
        }];

        RACSignal * nameSignal = [self.tf_name rac_textSignal];

        RACSignal * ageSignal = [self.tf_age rac_textSignal];

        RACSignal * zipSignal2 = [nameSignal zipWith:ageSignal];

        //这里会把姓名和年龄输入框的信号包装成一个元祖,这里看起来效果会比较明显,年龄和姓名输入框若多次变动后,他们的信号呈现一个多一个少的情况下那么是无法订阅成功的
        //必须信号称对包装成元祖才可以
        [zipSignal2 subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 信号的压缩,每个信号只要sendNext即可

- 和zip相似,只要两个信号都发送过至少一次信号就会执行,不同的是zip要求更为苛刻,需要二者信号每次执行时都必须成对,否则无法订阅成功

        RACSignal * nameSignal = [self.tf_name rac_textSignal];

        RACSignal * ageSignal = [self.tf_age rac_textSignal];

        //和zip相似,只要两个信号都发送过至少一次信号就会执行,不同的是zip要求更为苛刻,需要二者信号每次执行时都必须成对,否则无法订阅成功
        RACSignal * combineSignal = [nameSignal combineLatestWith:ageSignal];

        [combineSignal subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 信号的聚合

- 先组合再聚合,聚合后和映射类似可以返回我们需要的数据格式

        RACSignal * nameSignal = [self.tf_name rac_textSignal];

        RACSignal * ageSignal = [self.tf_age rac_textSignal];

        //先组合再聚合
        //reduce后的参数需要自己添加,添加以前方传来的信号的数据为准
        //return类似映射,可以对数据进行处理再发送给订阅者
        RACSignal * reduceSignal = [RACSignal combineLatest:@[nameSignal,ageSignal] reduce:^id(NSString * name,NSString * age){

            return [NSString stringWithFormat:@"姓名:%@,年龄:%@",name,age];

        }];

        [reduceSignal subscribeNext:^(id x) {

            NSLog(@"%@",x);
        }];

### 信号的信息处理(过滤,忽略等)

#### 即时搜索的优化

- 如果我是刚学iOS不久的菜鸟我会怎么去写一个即时搜索呢?我大概会这么写,监听testfiled的内容变化,一旦变化就发送一个请求.这种做法写起来很好写但考虑过对网络和服务器压力减小的优化吗?答案很明显没有,下面用几行代码我们来看看RAC是怎样优化即时搜索的.

        UITextField * tf_search = [[UITextField alloc]init];

        //这段代码的意思是若0.3秒内无新信号(tf无输入),并且输入框内不为空那么将会执行,这对服务器的压力减少有巨大帮助同时提高了用户体验
        [[[[[[tf_search.rac_textSignal throttle:0.3]distinctUntilChanged]ignore:@""] map:^id(id value) {

        //这里使用的是信号中的信号这个概念
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                //  network request

                //  这里可将请求到的信息发送出去

                [subscriber sendNext:value];

                [subscriber sendCompleted];

                return [RACDisposable disposableWithBlock:^{

                    //  cancel request

                    // 这里可以将取消请求写在这里,若输入框有新输入信息那么将会发送一个新的请求,原来那个没执行完的请求将会执行这个取消请求的代码

                        }];
                    }];

                }]switchToLatest] subscribeNext:^(id x) {

                    //这里获取信息

                }];

- 从上面的代码可以看出我对即时搜索的信号进行了很多优化,包括判断用户输入时不进行搜索,为空不进行搜索,并对新请求发出对旧请求进行了处理.里头使用到了许多未知的方法,下面我们就对他们进行介绍

#### 过滤

- 对信号发送的信息进行过滤,只有符合我们要求的信号才会被订阅到

        //对value进行过滤,若value的值满足条件订阅者才能够订阅到
        [[self.nameSignal filter:^BOOL(NSString * value) {

            return value.length>3;

        }] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 忽略

- 对信号发送的信息对某些值进行忽略,当值是忽略值时,订阅信号不会执行,一般用作判断非空

        //当信号传输的数据时ignore后的参数时,订阅者就会忽略这个信号,ignore可以嵌套,一般用来判断非空
        [[[self.nameSignal ignore:@"A"] ignore:@"B"] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 数据不同才会被订阅到

- 输入不同的字符才会获取到数值,可以用在对服务器的请求上过滤一些相同的请求,降低服务器压力

        -(void)testTheMethodOfDistinctUntilChanged{

            //演示效果可能不太好,我重新写一组信号
            [[self.nameSignal distinctUntilChanged] subscribeNext:^(id x) {

                NSLog(@"%@",x);

            }];

            //从这里可以看出只有与上一个信号所传递的值不相同订阅者才会打印
            [[self.testSignal distinctUntilChanged] subscribeNext:^(id x) {

                NSLog(@"%@",x);

            }];
        }

        -(void)createupSignal{

            RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                [subscriber sendNext:@1];
                [subscriber sendNext:@1];
                [subscriber sendNext:@2];
                [subscriber sendNext:@1];
                [subscriber sendNext:@1];
                [subscriber sendNext:@3];
                [subscriber sendNext:@1];
                [subscriber sendNext:@1];
                [subscriber sendNext:@1];

                [subscriber sendCompleted];

                return [RACDisposable disposableWithBlock:^{

                }];

            }];

            self.testSignal = signal;
        }

#### 获取前n个信号

- 信号使用上面的示例

        [[self.testSignal take:3] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 获取最后几次信号

- 信号使用上面的示例

        [[self.testSignal takeLast:3] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 对信号监听条件的释放

- 前面介绍rac替代通知时有遇到过

        //当对象被销毁后将不再监听
        //这里takeuntil后面的参数可以自己创建信号
        [[self.nameSignal takeUntil:self.rac_willDeallocSignal] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 跳过几个信号不接收

- 信号使用上面的示例

        [[self.testSignal skip:5] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 获取信号中带有数据的最新信号

- 信号中信号很常用

        RACSignal * signalOfSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            [subscriber sendNext:self.testSignal];

            [subscriber sendCompleted];

            return [RACDisposable disposableWithBlock:^{

            }];

        }];

        [[signalOfSignal switchToLatest] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 映射

- 我们有时需要对信号block返回来的数据进行处理,或者是转换格式,或者是拼接字符串,这个时候就要用到map和flattenMap了,二者的区别主要在于:FlatternMap返回的是一个信号,而map返回的是信号,一般情况下我们使用的是map,只有信号中的信号我们才会使用FlatternMap.使用FlatternMap我们需要导入RACReturnSignal.h

* map

        //这里可以使用绑定写法来更快捷的达到目的,这里主要是为了体验map所以就不展示了,详情请看RACSignal的绑定
        //这里的映射(map)前面有讲过主要是为了对block的返回值进行处理
        @weakify(self);
        [[[self.tf_name rac_textSignal] map:^id(id value) {

            return [NSString stringWithFormat:@"名字是:%@",value];

        }] subscribeNext:^(id x) {

            @strongify(self);
            self.lb_name.text = x;

        }];

* FlatternMap

        //同时使用FlatternMap我们需要导入RACReturnSignal.h
        @weakify(self);
        [[[self.tf_age rac_textSignal] flattenMap:^RACStream *(id value) {

            return [RACReturnSignal return:[NSString stringWithFormat:@"年龄是:%@",value]];

        }] subscribeNext:^(id x) {

            @strongify(self);
            self.lb_age.text = x;

        }];

### 冷信号和热信号

- 这里感谢cocoachina论坛Noah前辈对我的耐心讲解,同时本文参考了臧成威前辈的[文章](http://tech.meituan.com/talk-about-reactivecocoas-cold-signal-and-hot-signal-part-2.html)

#### 冷热信号的理解

以前我对冷信号和热信号的认知就是没订阅的就是冷信号,订阅了的就是热信号,但是最近研究副作用时看了几篇文章打破了我以前的观点.例如RACSignal一般创建出来就是冷信号,RACSubject,RACComand内部返回的信号, RACMulticastConnect这些就是热信号,区别就好比冷信号是一段视频,发过来可以完整的接收到,而热信号就好比是直播,你在订阅的时候有可能信息错过了的话就会收不到.

实际上冷热信号的区分并不是这样的,热信号指，即使外部没有订阅，里面已经源源不断发送值了,你在订阅的时候如果前面的信号错过了就错过了不会再有,这就是为何RACSubject为何要先订阅才能收到信号的原因;冷信号因为每次订阅都会执行一次，每个订阅都是独立行为。这和我们是否去订阅他并没有什么直接的关系,在RAC2中 RACSignal是信号，RACSubject是热信号，RACSignal和子类排除RACSubject是冷信号,而在RAC4中signal是热信号 SignalProducer是冷信号.

我们一般使用热信号的时候会非常谨慎的使用,因为RACSubject会被滥用太方便了,我们一般会使用replay*的方法或者multicast、publish方法来转化或者创建热信号.

RACSubject即使有多少个订阅者，它都只会执行一次，并将结果返回。另外RACMulticastConnection这种内部实现实际上是多个订阅者订阅了一个subject,控制执行行为并不是通过被订阅,而是手动控制的

#### 对RAC副作用的个人理解

副作用指的就是RAC改变了外界的状态(例如全局属性的赋值,多次网络请求,线程锁等),这些可能会导致一个问题,那就是同样的输入可能会导致不同的输出,同时也增加了我们排查代码错误的难度.以网络请求为例,现实中一般是不会这么用的,这里只是举个例子.请求若使用冷信号,我们对这个冷信号在进行一些操作的时候,臧成威前辈讲其实内部对一些信号的操作是再次订阅的过程,那么最后你可能会导致多次请求的问题出现,这便可以理解为副作用.严格地讲iOS开发其实就是一个在创造副作用的过程.现实中我们一般会把请求放到viewmodel中,只请求一个数据,然后将数据转成相应的属性暴露在.h文件,然后控制器在和数据进行绑定,这样做非常的优雅.

#### 冷信号转热信号

这是臧成威前辈给出的冷信号转热信号比较常用的方法,他比subject直接订阅冷信号的优点在于例如subject的订阅者提前终止了订阅，而subject并不能终止对coldSignal的订阅,具体实现代码如下:

        RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

                NSLog(@"Cold signal be subscribed.");

                [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{

                    [subscriber sendNext:@"A"];

                }];

                [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{

                    [subscriber sendNext:@"B"];

                }];

                [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{

                    [subscriber sendCompleted];

                }];


                return nil;

            }];

        RACSubject *subject = [RACSubject subject];

        NSLog(@"Subject created.");

        //RACMulticastConnection:用于当一个信号，被多次订阅时，为了保证创建信号时，避免多次调用创建信号中的block，造成副作用，可以使用这个类处理。
        //也可以通过signal publish创建
        RACMulticastConnection *multicastConnection = [coldSignal multicast:subject];

        RACSignal *hotSignal = multicastConnection.signal;

        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{

            [multicastConnection connect];

        }];

        [hotSignal subscribeNext:^(id x) {

            NSLog(@"Subscribe 1 recieve value:%@.", x);

        }];

        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{

            [hotSignal subscribeNext:^(id x) {

                NSLog(@"Subscribe 2 recieve value:%@.", x);

            }];

        }];

* 另一种写法

        RACSignal *coldSignal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            NSLog(@"Cold signal be subscribed.");

            [[RACScheduler mainThreadScheduler] afterDelay:1.5 schedule:^{

                [subscriber sendNext:@"A"];

            }];

            [[RACScheduler mainThreadScheduler] afterDelay:3 schedule:^{

                [subscriber sendNext:@"B"];

            }];

            [[RACScheduler mainThreadScheduler] afterDelay:5 schedule:^{

                [subscriber sendCompleted];

            }];


            return nil;

        }];

        RACSubject *subject = [RACSubject subject];

        NSLog(@"Subject created.");

        RACMulticastConnection *multicastConnection = [coldSignal multicast:subject];

        RACSignal *hotSignal = multicastConnection.autoconnect;

        [[RACScheduler mainThreadScheduler] afterDelay:2 schedule:^{

            [hotSignal subscribeNext:^(id x) {

                NSLog(@"Subscribe 1 recieve value:%@.", x);

            }];

        }];


        [[RACScheduler mainThreadScheduler] afterDelay:4 schedule:^{

            [hotSignal subscribeNext:^(id x) {

                NSLog(@"Subscribe 2 recieve value:%@.", x);

            }];

        }];

### 信号的调度器RACScheduler(多线程)

#### deliverOn

在上一篇我们讲到过RAC的副作用,deliverOn这个方法会将内容传递切换到指定线程,而副作用依旧会在指定线程内执行

        //创建信号
        -(void)createUpSignals{

        RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            NSLog(@"sendTestSignal%@",[NSThread currentThread]);

            [subscriber sendNext:@1];

            [subscriber sendCompleted];

            return [RACDisposable disposableWithBlock:^{

                    }];
            }];

        self.testSignal = signal;

        }

        //订阅信号
        //要想放在主线程执行只要将[RACScheduler scheduler]更换为[RACScheduler mainThreadScheduler]
        [[self.testSignal deliverOn:[RACScheduler scheduler]] subscribeNext:^(id x) {

            NSLog(@"receiveSignal%@",[NSThread currentThread]);

        }];

- 打印结果如下

        2016-09-02 09:48:59.697 Signal processing[1686:22894] sendTestSignal<NSThread: 0x7fb373c0bb80>{number = 1, name = main}
        2016-09-02 09:48:59.697 Signal processing[1686:24680] receiveSignal<NSThread: 0x7fb373e07070>{number = 3, name = (null)}

subscribeOn则会将传递内容和副作用一起放到指定线程执行

        [[[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            NSLog(@"sendSignal%@",[NSThread currentThread]);

            [subscriber sendNext:@1];

            return [RACDisposable disposableWithBlock:^{
    
                    }];

        }] subscribeOn:[RACScheduler scheduler]] subscribeNext:^(id x) {

            NSLog(@"receiveSignal%@",[NSThread currentThread]);

        }];

- 打印结果如下

        2016-09-02 09:54:47.819 Signal processing[1778:54504] sendSignal<NSThread: 0x7fde7adb4e00>{number = 2, name = (null)}
        2016-09-02 09:54:47.819 Signal processing[1778:54504] receiveSignal<NSThread: 0x7fde7adb4e00>{number = 2, name = (null)}


### 对信号的一些执行操作

#### send信号前执行相应的block

        //doNext doComplete doError中的block会分别在对应的sendNext sendComplete sendError之前执行
        [[[[self.testSignal doNext:^(id x) {

            NSLog(@"sendNext之前会执行这个block");

        }] doCompleted:^{

            NSLog(@"sendComplete之前会执行这个block");

        }] doError:^(NSError *error) {

            NSLog(@"sendError之前会执行这个block");

        }] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

#### 超时自动报错

        [[self.testSignal timeout:1 onScheduler:[RACScheduler mainThreadScheduler]] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            //超时一秒后会自动报错
            NSLog(@"%@",error);

        }];

#### 定时执行

和前面讲的定时器类似

        //每一秒执行一次,这里要加上释放信号,否则控制器推出后依旧会执行,看具体需求吧
        [[[RACSignal interval:1 onScheduler:[RACScheduler scheduler]]takeUntil:self.rac_willDeallocSignal ] subscribeNext:^(id x) {

            NSLog(@"%@",[NSDate date]);

        }];

#### 延时执行

        [[self.testSignal delay:2] subscribeNext:^(id x) {

            NSLog(@"%@",[NSDate date]);

        }];

#### 信号发送失败后会重新执行

        [[self.testSignal retry] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        } error:^(NSError *error) {

            NSLog(@"%@",error);

        }];

#### 当一个信号被多次订阅后会像热信号那样

当一个信号被多次订阅时,不会每次都执行一遍副作用,而是像热信号一样只执行一遍,replay内部将信号封装RACMulticastConnection的热信号

拿示例来说第一个例子我们不对信号进行replay操作

        RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            static int a = 1;

            [subscriber sendNext:@(a)];

            a ++;

            return nil;

        }];

        [signal subscribeNext:^(id x) {

            NSLog(@"第一个订阅者%@",x);

        }];

        [signal subscribeNext:^(id x) {

            NSLog(@"第二个订阅者%@",x);

        }];

- 输出结果如下

        2016-09-02 11:57:50.312 Signal processing[3703:323215] 第一个订阅者1
        2016-09-02 11:57:50.312 Signal processing[3703:323215] 第二个订阅者2

这个结果说明了冷信号的本质以及副作用,每订阅一次冷信号,都会完整的执行一次副作用

下来对冷信号进行replay操作

        RACSignal *signal = [[RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

            static int a = 1;

            [subscriber sendNext:@(a)];

            a ++;

            return nil;
        }] replay];

        [signal subscribeNext:^(id x) {

            NSLog(@"第一个订阅者%@",x);

        }];

        [signal subscribeNext:^(id x) {

            NSLog(@"第二个订阅者%@",x);

        }];

- 输出结果如下

        2016-09-02 11:59:44.352 Signal processing[3782:328331] 第一个订阅者1
        2016-09-02 11:59:44.352 Signal processing[3782:328331] 第二个订阅者1

由此可以看出,实际上是将冷信号只发送了一次

#### 节流

对信号使用throttle这个方法,原理就是类似若一段时间后没有新信号就执行最后这个信号,前面讲的即时搜索的优化就是一个很好的例子,主要用在降低服务器压力以及其他一些信号发送频繁,但订阅却不需要如此频繁的地方.

        [[signal throttle:1] subscribeNext:^(id x) {

            NSLog(@"%@",x);

        }];

- 未完待


















