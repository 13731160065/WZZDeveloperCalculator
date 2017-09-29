//
//  WZZSingleManager.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZSingleManager.h"
#import <UIKit/UIKit.h>

#define JSCODEKEY @"jscodetitle"
#define MINKEY @"MINKEY"
#define MAXKEY @"MAXKEY"

static WZZSingleManager * mm;

@interface WZZSingleManager ()
{
    //引导视图
    void(^_completeBlock)();
}

@end

@implementation WZZSingleManager

//单例
+ (instancetype)shareInstance {
    if (!mm) {
        mm = [[WZZSingleManager alloc] init];
    }
    return mm;
}

//加载js标题
- (NSMutableArray <NSDictionary <NSString *, NSString *>*>*)loadJsTitle {
    NSString * jsTitle = [[NSUserDefaults standardUserDefaults] objectForKey:JSCODEKEY];
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[jsTitle componentsSeparatedByString:@","]];
    for (int i = 0; i < arr.count; i++) {
        NSString * str = arr[i];
        arr[i] = [[str componentsSeparatedByString:@"js@"] componentsJoinedByString:@""];
    }
    return arr;
}

//保存js代码
- (void)saveJsCode:(NSString *)code title:(NSString *)title {
    [[NSUserDefaults standardUserDefaults] setObject:code forKey:[NSString stringWithFormat:@"js@%@", title]];
    
    //加载标题，往标题里加一个
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self loadJsTitle]];
    [arr addObject:[NSString stringWithFormat:@"js@%@", title]];
    [[NSUserDefaults standardUserDefaults] setObject:[arr componentsJoinedByString:@","] forKey:JSCODEKEY];
}

//加载js代码
- (NSString *)loadJsCodeWithTitle:(NSString *)title {
    return [[NSUserDefaults standardUserDefaults] objectForKey:[NSString stringWithFormat:@"js@%@", title]];
}

//删除js代码
- (void)removeJsCodeWithTitle:(NSString *)title {
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:[NSString stringWithFormat:@"js@%@", title]];
    
    //加载标题，删除符合的标题
    NSMutableArray * arr = [NSMutableArray arrayWithArray:[self loadJsTitle]];
    [arr removeObject:[NSString stringWithFormat:@"%@", title]];
    if (arr.count == 0) {
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:JSCODEKEY];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:[arr componentsJoinedByString:@","] forKey:JSCODEKEY];
    }
}

//保存最大最小值
- (void)saveMaxMinNum:(struct WZZMAXMINNUM)maxMinNum {
    [[NSUserDefaults standardUserDefaults] setInteger:maxMinNum.max forKey:MAXKEY];
    [[NSUserDefaults standardUserDefaults] setInteger:maxMinNum.min forKey:MINKEY];
}

//加载最大最小值
- (struct WZZMAXMINNUM)loadMaxMinNum {
    struct WZZMAXMINNUM nnn;
    NSInteger max = [[NSUserDefaults standardUserDefaults] integerForKey:MAXKEY];
    NSInteger min = [[NSUserDefaults standardUserDefaults] integerForKey:MINKEY];
    if (max == min) {
        max++;
    }
    nnn.max = max;
    nnn.min = min;
    return nnn;
}

//展示引导图
- (void)showGuide {
    BOOL isNew = [self checkIsNewVersionWithType:@"WZZSHOWGUIDE"];
    if (isNew) {
        const CGFloat pointWH = 30;
        const CGFloat otherBorder = 20;
        [self showGuideView:CGRectMake(otherBorder, 44+pointWH/6*7+otherBorder, [UIScreen mainScreen].bounds.size.width-otherBorder*2, 70) text:@"长按显示区域复制，点击显示区域有更多功能噢" pointFrame:CGRectMake([UIScreen mainScreen].bounds.size.width-otherBorder-pointWH, 44, pointWH, pointWH/6*7) complete:^{
            [self registerIsNewVersionWithType:@"WZZSHOWGUIDE"];
        }];
    }
}

//展示引导
- (void)showGuideView:(CGRect)frame
                 text:(NSString *)text
           pointFrame:(CGRect)pointFrame
             complete:(void(^)())completeBlock {
    _completeBlock = completeBlock;
    UIView * guideView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    [[[UIApplication sharedApplication] keyWindow] addSubview:guideView];
    [guideView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAView:)]];
    [guideView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [guideView setAlpha:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [guideView setAlpha:1.0f];
    }];
    
    
    UIView * backView = [[UIView alloc] initWithFrame:frame];
    [guideView addSubview:backView];
    [backView setBackgroundColor:[UIColor whiteColor]];
    [backView.layer setMasksToBounds:YES];
    [backView.layer setCornerRadius:5];
    
    UIImageView * poImgv = [[UIImageView alloc] initWithFrame:CGRectMake(backView.frame.size.width-20-20, -20, 20, 10)];
    [backView addSubview:poImgv];
    [poImgv setImage:[UIImage imageNamed:@"新卡包小角"]];
    
    UILabel * IKnowLabel = [[UILabel alloc] initWithFrame:CGRectMake(backView.frame.size.width-backView.frame.size.height, 0, 70, backView.frame.size.height)];
    [backView addSubview:IKnowLabel];
    [IKnowLabel setFont:[UIFont systemFontOfSize:15]];
    [IKnowLabel setText:@"知道了"];
    [IKnowLabel setTextAlignment:NSTextAlignmentCenter];
    [IKnowLabel setTextColor:[UIColor blackColor]];
    
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(IKnowLabel.frame.origin.x-1, 20, 1, backView.frame.size.height-20*2)];
    [backView addSubview:lineView];
    [lineView setBackgroundColor:[UIColor blackColor]];
    
    UILabel * textLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, lineView.frame.origin.x-20-20, backView.frame.size.height)];
    [backView addSubview:textLabel];
    [textLabel setText:text];
    [textLabel setNumberOfLines:2];
    [textLabel setFont:[UIFont systemFontOfSize:15]];
    [textLabel setAdjustsFontSizeToFitWidth:YES];
    
    UIImageView * imageView = [[UIImageView alloc] initWithFrame:pointFrame];
    [imageView setImage:[UIImage imageNamed:@"新卡包小手"]];
    [guideView addSubview:imageView];
}

//删除引导
- (void)removeAView:(UITapGestureRecognizer *)tap {
    [tap.view removeFromSuperview];
    if (_completeBlock) {
        _completeBlock();
    }
}

//注册tip
- (void)registerIsNewVersionWithType:(NSString *)type {
    if (!type) {
        type = @"";
    }
    NSString *buildVeison = [[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] stringByAppendingString:type];
    [[NSUserDefaults standardUserDefaults] setObject:buildVeison forKey:buildVeison];
}

//检测
- (BOOL)checkIsNewVersionWithType:(NSString *)type {
    if (!type) {
        type = @"";
    }
    NSString * buildVeison = [[[[NSBundle mainBundle]infoDictionary]objectForKey:@"CFBundleShortVersionString"] stringByAppendingString:type];
    NSString * checkVersion = [[NSUserDefaults standardUserDefaults] objectForKey:buildVeison];
    if ([buildVeison isEqualToString:checkVersion]) {
        return NO;
    } else {
        return YES;
    }
}

@end
