//
//  WZZLoadJSVC.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZLoadJSVC.h"
#import "WZZSingleManager.h"

@interface WZZLoadJSVC ()<UITableViewDelegate, UITableViewDataSource>
{
    NSMutableArray * dataArr;
    void(^_selectBackBlock)(NSString *);
}
@property (weak, nonatomic) IBOutlet UITableView *mainTableView;

@end

@implementation WZZLoadJSVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self loadData];
}

- (void)loadData {
    dataArr = [NSMutableArray arrayWithArray:[[WZZSingleManager shareInstance] loadJsTitle]];
    [_mainTableView reloadData];
}

- (void)selectBackBlock:(void (^)(NSString *))aBlock {
    if (_selectBackBlock != aBlock) {
        _selectBackBlock = aBlock;
    }
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count+1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    if (indexPath.row == 0) {
        [cell.textLabel setText:@"返回"];
    } else {
        [cell.textLabel setText:dataArr[indexPath.row-1]];
    }
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return NO;
    }
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row) {
        if (_selectBackBlock) {
            _selectBackBlock([[WZZSingleManager shareInstance] loadJsCodeWithTitle:dataArr[indexPath.row-1]]);
        }
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [[WZZSingleManager shareInstance] removeJsCodeWithTitle:dataArr[indexPath.row]];
    }
}

@end
