//
//  MainVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "MainVC.h"

#import "DelegateVC.h"

#import "KVOVC.h"

#import "EventVC.h"

#import "NSNotificationVC.h"

#import "TimerVC.h"

@interface MainVC ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
}


#pragma mark - UI -

-(void)setupUI{
    
    UITableView * tableview = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
    
    [self.view addSubview:tableview];
    
    [tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.edges.equalTo(0);
        
    }];
    
    tableview.dataSource = self;
    
    tableview.delegate = self;
    
    [tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - 数据源方法 -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 5;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"代替代理";
            break;
            
        case 1:
            cell.textLabel.text = @"代替KVO";
            break;
            
        case 2:
            cell.textLabel.text = @"监听事件";
            break;
            
        case 3:
            cell.textLabel.text = @"代替通知";
            break;
            
        case 4:
            cell.textLabel.text = @"代替定时器";
            break;
            
        default:
            break;
    }
    
    return cell;
}

#pragma mark - 代理方法 -
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    switch (indexPath.row) {
            
        case 0:
        {
            DelegateVC * vc = [[DelegateVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
        {
            KVOVC * vc = [[KVOVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            EventVC * vc = [[EventVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }

        case 3:
        {
            NSNotificationVC * vc = [[NSNotificationVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }

        case 4:
        {
            TimerVC * vc = [[TimerVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
            
        default:
            break;
    }
}


@end
