//
//  WZZOtherVC.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/9/29.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZOtherVC.h"

@interface WZZOtherVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * dataArr;
}
    
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WZZOtherVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainTableView setTableFooterView:[[UIView alloc] init]];
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [_mainTableView setShowsHorizontalScrollIndicator:NO];
    [_mainTableView setShowsVerticalScrollIndicator:NO];
    
    dataArr = [NSMutableArray arrayWithArray:@[@"关于我们"]];
}
    
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell.textLabel setText:@""];
    
    return cell;
}

@end
