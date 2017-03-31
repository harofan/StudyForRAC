//
//  ViewController.m
//  the basis of RACSubject
//
//  Created by fy on 16/8/18.
//  Copyright © 2016年 LY. All rights reserved.
//

#import "ViewController.h"

#import "RACSubjectVC.h"

#import "RACReplaySubjectVC.h"

#import "RACSubjectDelegateVC.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

static NSString * identifier = @"cell";

#pragma mark - 生命周期 -
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self createUI];
}

#pragma mark - UI -
-(void)createUI{
    
    self.tableView.dataSource = self;
    
    self.tableView.delegate = self;
    
    //取消tableview顶部空白
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    
}

#pragma mark - 数据源方法 -
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell * cell =[tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    
    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"RACSubject";
            break;
            
        case 1:
            cell.textLabel.text = @"RACReplaySubject";
            break;
            
        case 2:
            cell.textLabel.text = @"RACSubject代替代理";
            break;
            
        default:
            break;
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

#pragma mark - 代理方法 -

//设置组头组尾高度
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    return 0.1f;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    switch (indexPath.row) {
        case 0:
        {
            RACSubjectVC * vc = [[RACSubjectVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
        case 1:
        {
            RACReplaySubjectVC * vc = [[RACReplaySubjectVC alloc]init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
            
        case 2:
        {
            
            RACSubjectDelegateVC * vc = [[RACSubjectDelegateVC alloc] init];
            
            [self.navigationController pushViewController:vc animated:YES];
            
            break;
        }
            
        default:
            
            break;
    }
}
@end
