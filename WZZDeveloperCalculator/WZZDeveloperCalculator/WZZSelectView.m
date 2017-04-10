//
//  WZZSelectView.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/10.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZSelectView.h"

@interface WZZSelectView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * mainTableView;
    NSMutableArray * dataArr;
    void(^_selectBlock)(NSString *);
}

@end

@implementation WZZSelectView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setFrame:CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, 0)];
        [UIView animateWithDuration:0.3f animations:^{
            [self setFrame:frame];
        }];
        dataArr = [NSMutableArray arrayWithArray:@[
                                                   @"当前时间戳"
                                                   ]];
        mainTableView = [[UITableView alloc] initWithFrame:self.bounds style:UITableViewStylePlain];
        [self addSubview:mainTableView];
        [mainTableView setDelegate:self];
        [mainTableView setDataSource:self];
        [mainTableView reloadData];
        [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

//选择block
- (void)selectBlock:(void (^)(NSString *))aBlock {
    if (_selectBlock != aBlock) {
        _selectBlock = aBlock;
    }
}

#pragma mark - tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    
    [cell.textLabel setText:dataArr[indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [UIView animateWithDuration:0.3f animations:^{
        [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, 0)];
    } completion:^(BOOL finished) {
        if (_selectBlock) {
            _selectBlock(dataArr[indexPath.row]);
        }
        [self removeFromSuperview];
    }];
}

@end
