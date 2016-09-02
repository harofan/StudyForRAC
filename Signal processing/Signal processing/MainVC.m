//
//  MainVC.m
//  the skills  of RAC
//
//  Created by fy on 16/8/24.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "MainVC.h"

#import "MapVC.h"

#import "SignalCombinerVC.h"

#import "SignalProcessingVC.h"

#import "HandSignalsVC.h"

#import "SchedulerVC.h"


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
    
    return 6;
    
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"信号的映射处理(flattenMap,Map)";
            break;
            
        case 1:
            cell.textLabel.text = @"多个信号组合处理";
            break;
            
        case 2:
            cell.textLabel.text = @"信号的筛选忽略过滤等操作";
            break;
            
        case 3:
            cell.textLabel.text = @"对信号的操作,信号发送前的一些1操作";
            break;
            
        case 4:
            cell.textLabel.text = @"调度器(多线程)";
            break;
            
        case 5:
            cell.textLabel.text = @"代替UI控件的addtarget";
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
            MapVC * vc = [[MapVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
        {
            SignalCombinerVC * vc = [[SignalCombinerVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            SignalProcessingVC * vc = [[SignalProcessingVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }

        case 3:
        {
            HandSignalsVC * vc = [[HandSignalsVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }

        case 4:
        {
            SchedulerVC * vc = [[SchedulerVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
//
//        case 5:
//        {
//            TargetOfUISignalVC * vc = [[TargetOfUISignalVC alloc]init];
//            
//            [self.navigationController pushViewController:vc animated:YES];
//            
//            break;
//        }
            
        default:
            break;
    }
}


@end
