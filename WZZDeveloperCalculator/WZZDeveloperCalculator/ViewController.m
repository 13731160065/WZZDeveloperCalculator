//
//  ViewController.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "ViewController.h"
#import "WZZLiveCollectionCell.h"
#import "WZZCalModel.h"
#import "WZZSelectView.h"
#import "WZZSingleManager.h"
#import "JSViewController.h"
#import "WZZWebVC.h"

#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
#define ITEMBORDER 2
#define ITEMNUM 4
#define ITEMW ((kScreenWidth-(ITEMNUM-1)*ITEMBORDER)/ITEMNUM)
#define ITEMH ITEMW

//00a2ff
#define YELLOWCOLOR UIColorFromRGB(0x00a2ff)
//[UIColor colorWithRed:0.0000f green:0.6353f blue:1.0000f alpha:1.0f]

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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[WZZSingleManager shareInstance] showGuide];
    });
}

//创建UI
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
    [showLabel setUserInteractionEnabled:YES];
    //添加手势
    [showLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)]];
    [showLabel addGestureRecognizer:[[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longClick:)]];
    [showLabel addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panClick:)]];
    
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
    [mainCollectionView setBackgroundColor:[UIColor colorWithWhite:0.1f alpha:1.0f]];
    [mainCollectionView setDataSource:self];
    [mainCollectionView setDelegate:self];
    [mainCollectionView registerNib:[UINib nibWithNibName:@"WZZLiveCollectionCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [mainCollectionView setShowsVerticalScrollIndicator:NO];
    [mainCollectionView setShowsHorizontalScrollIndicator:NO];
}

//加载数据
- (void)loadData {
    [self changeSegClick:buttonsArr[2]];
}

//键盘切换
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

#pragma mark - 点击事件
//点击数字
- (void)tapClick:(UITapGestureRecognizer *)tap {
    
    CGFloat selectHeight = kScreenHeight-94;
    if ([WZZSingleManager shareInstance].menuArr.count*44 < selectHeight) {
        selectHeight = [WZZSingleManager shareInstance].menuArr.count*44;
    }
    //快速获取数字列表
    [WZZSelectView showWithRect:CGRectMake(0, CGRectGetMaxY(showView.frame), kScreenWidth, selectHeight) selectBlock:^(NSString * selectStr) {
        
        //时间戳
        if ([selectStr isEqualToString:@"当前时间戳"]) {
            NSString * str = [NSString stringWithFormat:@"%ld", (long)[[NSDate date] timeIntervalSince1970]];
            [showLabel setText:[[WZZCalModel shareInstance] inputLongText:str]];
        }
        
        //js
        if ([selectStr isEqualToString:@"JavaScript"]) {
            JSViewController * jsss = [[JSViewController alloc] init];
            [self presentViewController:jsss animated:YES completion:nil];
        }
        
        //随机数
        if ([selectStr isEqualToString:@"随机数"]) {
            struct WZZMAXMINNUM nn = [[WZZSingleManager shareInstance] loadMaxMinNum];
            NSInteger rNum = arc4random()%(nn.max-nn.min)+nn.min;
            [showLabel setText:[[WZZCalModel shareInstance] inputLongText:@(rNum).stringValue]];
        }
        
        //随机数设置
        if ([selectStr isEqualToString:@"随机数设置"]) {
            UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"设置随机数" message:@"输入一个最大值和一个最小值，随机数将取包含这两个值极其中间值的随机数" preferredStyle:UIAlertControllerStyleAlert];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"最小值(整型)";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
                textField.placeholder = @"最大值(整型)";
                textField.keyboardType = UIKeyboardTypeNumberPad;
            }];
            [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NSInteger min = [alert.textFields[0].text integerValue];
                NSInteger max = [alert.textFields[1].text integerValue];
                if (max < min) {
                    //如果大小反了，交换
                    NSInteger tmp = max;
                    max = min;
                    min = tmp;
                }
                max++;
                struct WZZMAXMINNUM nn;
                nn.max = max;
                nn.min = min;
                [[WZZSingleManager shareInstance] saveMaxMinNum:nn];
            }]];
            [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:alert animated:YES completion:nil];
        }
        
        //浏览器
        if ([selectStr isEqualToString:@"浏览器"]) {
            WZZWebVC * vc = [[WZZWebVC alloc] init];
            [self presentViewController:vc animated:YES completion:nil];
        }
        
        //其他
        if ([selectStr isEqualToString:@"其他"]) {
            
        }
    }];
}

//长按数字
- (void)longClick:(UILongPressGestureRecognizer *)longGes {
    //复制
    [showLabel setText:[WZZCalModel copyWithText:[WZZCalModel shareInstance].currentNum]];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [showLabel setText:[WZZCalModel shareInstance].currentNum];
    });
}

//拖拽数字
- (void)panClick:(UIPanGestureRecognizer *)pan {
    
}

#pragma mark - collection代理
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return dataArr.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //请求列表
    WZZLiveCollectionCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.dataDic = dataArr[indexPath.row];
    [cell buttonClickBlock:^{
        NSString * text = dataArr[indexPath.row][@"title"];
        NSString * returnStr = [[WZZCalModel shareInstance] handleText:text];
        [showLabel setText:returnStr];
    }];
    return cell;
}

#if 0//应该没用了
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString * text = dataArr[indexPath.row][@"title"];
    NSString * returnStr = [[WZZCalModel shareInstance] handleText:text];
    [showLabel setText:returnStr];
}
#endif

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

#pragma mark - 其他
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end
