//
//  WZZSelectView.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/10.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZSelectView.h"

@interface WZZSelectView ()<UITableViewDelegate, UITableViewDataSource>
{
    UITableView * mainTableView;
    NSMutableArray * dataArr;
    void(^_selectBlock)(NSString *);
    UIView * backView;
    CGRect oFrome;
}

@end

@implementation WZZSelectView

- (instancetype)initWithFrame:(CGRect)frame rect:(CGRect)rect
{
    self = [super initWithFrame:frame];
    if (self) {
        oFrome = rect;
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
        [self addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
        backView = [[UIView alloc] initWithFrame:CGRectMake(rect.origin.x, rect.origin.y, rect.size.width, 0)];
        [self addSubview:backView];
        [UIView animateWithDuration:0.3f animations:^{
            [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
            [backView setFrame:rect];
        }];
        [backView.layer setMasksToBounds:YES];
        mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height) style:UITableViewStylePlain];
        [backView addSubview:mainTableView];
        [mainTableView setDelegate:self];
        [mainTableView setDataSource:self];
        [mainTableView reloadData];
        [mainTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return self;
}

+ (void)showWithRect:(CGRect)rect selectBlock:(void (^)(NSString *))aBlock {
    [self showWithRect:rect dataArr:@[
                                      @"当前时间戳",
                                      @"JavaScript",
                                      @"随机数",
                                      @"随机数设置",
                                      @"浏览器"
                                      ] selectBlock:aBlock];
}

+ (void)showWithRect:(CGRect)rect dataArr:(NSArray *)dataArr selectBlock:(void (^)(NSString *))aBlock {
    WZZSelectView * view = [[WZZSelectView alloc] initWithFrame:[UIScreen mainScreen].bounds rect:rect];
    [view selectBlock:aBlock];
    view->dataArr = [NSMutableArray arrayWithArray:dataArr];
    [[UIApplication sharedApplication].keyWindow addSubview:view];
}

//选择block
- (void)selectBlock:(void (^)(NSString *))aBlock {
    if (_selectBlock != aBlock) {
        _selectBlock = aBlock;
    }
}

- (void)backClick {
    [UIView animateWithDuration:0.3f animations:^{
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
        [backView setFrame:CGRectMake(oFrome.origin.x, oFrome.origin.y, oFrome.size.width, 0)];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
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
        [self setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.0f]];
        [backView setFrame:CGRectMake(oFrome.origin.x, oFrome.origin.y, oFrome.size.width, 0)];
    } completion:^(BOOL finished) {
        if (_selectBlock) {
            _selectBlock(dataArr[indexPath.row]);
        }
        [self removeFromSuperview];
    }];
}

@end
