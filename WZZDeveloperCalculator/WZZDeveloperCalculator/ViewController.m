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
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ITEMBORDER 2
#define ITEMNUM 4
#define ITEMW ((kScreenWidth-(ITEMNUM-1)*ITEMBORDER)/ITEMNUM)
#define ITEMH ITEMW

#define YELLOWCOLOR [UIColor colorWithRed:0.97f green:0.55f blue:0.16f alpha:1.0f]

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
{
    UICollectionView * mainCollectionView;//主键盘滑动视图
    UIView * showView;//显示界面
    UILabel * showLabel;//显示数字
    NSMutableArray * dataArr;//数据源
    NSMutableArray * buttonsArr;//切换按钮
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self creatUI];
    [self loadData];
}

- (void)creatUI {
    [self.view setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.0f]];
    dataArr = [NSMutableArray array];
    buttonsArr = [NSMutableArray array];
    
    //显示
    showView = [[UIView alloc] initWithFrame:CGRectMake(0, 20, kScreenWidth, 94)];
    [self.view addSubview:showView];
    
    //数字
    showLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, showView.frame.size.width-40, 64)];
    [showView addSubview:showLabel];
    [showLabel setText:@"0"];
    [showLabel setFont:[UIFont systemFontOfSize:40]];
    [showLabel setTextAlignment:NSTextAlignmentRight];
    [showLabel setTextColor:[UIColor whiteColor]];
    [showLabel setAdjustsFontSizeToFitWidth:YES];
    
    //切换
    UIView * segView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(showLabel.frame), showView.frame.size.width, showView.frame.size.height-showLabel.frame.size.height)];
    [showView addSubview:segView];
    //按钮
    NSArray * titleArr = @[@"2进制", @"8进制", @"10进制", @"16进制"];
    const CGFloat buttonW = segView.frame.size.width/titleArr.count;
    const CGFloat buttonH = segView.frame.size.height;
    for (int i = 0; i < titleArr.count; i++) {
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(i*buttonW, 0, buttonW, buttonH)];
        [segView addSubview:button];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitle:titleArr[i] forState:UIControlStateNormal];
        [button.titleLabel setAdjustsFontSizeToFitWidth:YES];
        button.tag = 1000+i;
        [button addTarget:self action:@selector(changeSegClick:) forControlEvents:UIControlEventTouchUpInside];
        [buttonsArr addObject:button];
    }
    
    //键盘
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(showView.frame), kScreenWidth, kScreenHeight-CGRectGetMaxY(showView.frame)) collectionViewLayout:layout];
    [self.view addSubview:mainCollectionView];
    [mainCollectionView setBackgroundColor:[UIColor colorWithWhite:0.99f alpha:1.0f]];
    [mainCollectionView setDataSource:self];
    [mainCollectionView setDelegate:self];
    [mainCollectionView registerNib:[UINib nibWithNibName:@"WZZLiveCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)loadData {
    [self changeSegClick:buttonsArr[2]];
}

- (void)changeSegClick:(UIButton *)button {
    NSInteger index = button.tag-1000;
    [buttonsArr enumerateObjectsUsingBlock:^(UIButton * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if (obj == button) {
            [obj setTitleColor:YELLOWCOLOR forState:UIControlStateNormal];
        } else {
            [obj setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }
    }];
    switch (index) {
        case 0:
        {
            //2
            dataArr = [NSMutableArray arrayWithArray:[WZZCalModel shareInstance].calPad2];
        }
            break;
        case 1:
        {
            //8
            dataArr = [NSMutableArray arrayWithArray:[WZZCalModel shareInstance].calPad8];
        }
            break;
        case 2:
        {
            //10
            dataArr = [NSMutableArray arrayWithArray:[WZZCalModel shareInstance].calPad10];
        }
            break;
        case 3:
        {
            //16
            dataArr = [NSMutableArray arrayWithArray:[WZZCalModel shareInstance].calPad16];
        }
            break;
            
        default:
            break;
    }
    [showLabel setText:[WZZCalModel shareInstance].currentNum];
    [mainCollectionView reloadData];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
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
    [showLabel setText:returnStr];
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
