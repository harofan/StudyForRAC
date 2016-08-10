## StudyForRAC

study for https://github.com/shuaiwang007/RAC

If you have some questions, please tell me.

### RACSignal

- 我们首先要创建一个信号

RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {

    [subscriber sendNext:@"信号内容/signal content"];

    return [RACDisposable disposableWithBlock:^{

            NSLog(@"此时取消订阅");

            }];
    }];