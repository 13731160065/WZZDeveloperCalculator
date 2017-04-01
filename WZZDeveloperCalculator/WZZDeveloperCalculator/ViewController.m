//
//  ViewController.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZLiveCollectionCell.h"
#import "WZZCalModel.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define ITEMBORDER 2
#define ITEMNUM 2
#define ITEMW ((kScreenWidth-(ITEMNUM-1)*ITEMBORDER)/ITEMNUM)
#define ITEMH ITEMW

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView * mainCollectionView;//主键盘滑动视图
    UIView * showView;//显示界面
    UILabel * showLabel;//显示数字
    NSMutableArray * dataArr;//数据源
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
}

- (void)creatUI {
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.9f alpha:1.0f]];
    
    //显示
    showView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 74)];
    [self.view addSubview:showView];
    
    //数字
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, showView.frame.size.width, 44)];
    [showView addSubview:showLabel];
    [showLabel setText:@"0"];
    [showLabel setFont:[UIFont systemFontOfSize:20]];
    [showLabel setTextAlignment:NSTextAlignmentRight];
    [showLabel setTextColor:[UIColor whiteColor]];
    [showLabel setAdjustsFontSizeToFitWidth:YES];
    
    //切换
    UIView * segView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(showLabel.frame), showView.frame.size.width, showView.frame.size.height-showLabel.frame.size.height)];
    [showView addSubview:segView];
    
    
    //键盘
    
    
}

#pragma mark - collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //请求列表
    WZZLiveCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataDic = dataArr[indexPath.row];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * text = dataArr[indexPath.row][@"title"];
    NSString * returnStr = [[WZZCalModel shareInstance] handleText:text];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return ITEMBORDER;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(ITEMW, ITEMH);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}


@end
