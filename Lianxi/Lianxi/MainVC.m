//
//  MainVC.m
//  Lianxi
//
//  Created by fy on 16/8/9.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "MainVC.h"

#import "RACSignal1.h"

#import "RACSubjectVC.h"

#import "RACSequenceVC.h"

@interface MainVC ()<UITableViewDataSource,UITableViewDelegate>

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor greenColor];
    
    

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
    
    return 100;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"RACSignal";
            break;
            
        case 1:
            cell.textLabel.text = @"RACSubject";
            break;
            
        case 2:
            cell.textLabel.text = @"RACSequence";
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
            RACSignalVC * vc = [[RACSignalVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
        {
            RACSubjectVC * vc = [[RACSubjectVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 2:
        {
            RACSequenceVC * vc = [[RACSequenceVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        default:
            break;
    }
}
@end
