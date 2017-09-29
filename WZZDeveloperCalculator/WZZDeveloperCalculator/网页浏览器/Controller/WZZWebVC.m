//
//  WZZWebVC.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/6/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZWebVC.h"
#import "NSString+WZZURLText.h"
#import "WZZSelectView.h"
@import WebKit;

@interface WZZWebVC ()<UITextFieldDelegate, UIWebViewDelegate>
{
    NSMutableArray <UIWebView *>* webViewsArr;
    NSMutableArray <NSString *>* datasArr;
    NSMutableArray <NSNumber *>* loadOKArr;//执行任务队列
    BOOL noJumpPage;
    NSInteger currentIndex;
}

@property (weak, nonatomic) IBOutlet UITextField *netTf;
@property (weak, nonatomic) IBOutlet UIScrollView *mainScrollView;
@property (weak, nonatomic) IBOutlet UIView *webBackView;

@end

@implementation WZZWebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    webViewsArr = [NSMutableArray array];
    datasArr = [NSMutableArray array];
    loadOKArr = [NSMutableArray array];
}

//刷新标题
- (void)reloadScrollView {
    [[_mainScrollView subviews] enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj removeFromSuperview];
    }];
    [datasArr enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        UIView * titleBackView = [[UIView alloc] initWithFrame:CGRectMake((71+30)*idx, 0, 70+30, 30)];
        [_mainScrollView addSubview:titleBackView];
        [titleBackView.layer setMasksToBounds:YES];
        [titleBackView.layer setCornerRadius:5];
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
        [button setFrame:CGRectMake(0, 0, 70, 30)];
        [titleBackView addSubview:button];
        [button.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:obj forState:UIControlStateNormal];
        [button setTag:5000+idx];
        [button addTarget:self action:@selector(pageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIButton * buttonX = [UIButton buttonWithType:UIButtonTypeCustom];
        [buttonX setFrame:CGRectMake(70, 0, 30, 30)];
        [titleBackView addSubview:buttonX];
        [buttonX setTitle:@"X" forState:UIControlStateNormal];
        [buttonX.titleLabel setFont:[UIFont systemFontOfSize:13]];
        [buttonX setTitleColor:[UIColor lightGrayColor] forState:UIControlStateNormal];
        [buttonX setBackgroundColor:[UIColor darkGrayColor]];
        [buttonX setTag:9000+idx];
        [buttonX addTarget:self action:@selector(cutPageButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        
        if (currentIndex == idx) {
            [button setBackgroundColor:[UIColor lightGrayColor]];
        } else {
            [button setBackgroundColor:[UIColor colorWithRed:0.9f green:0.9f blue:0.9f alpha:1.0f]];
        }
        
        if (![loadOKArr[idx] integerValue]) {
            UIActivityIndicatorView * loadView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
            loadView.center = CGPointMake(button.frame.size.width/2, button.frame.size.height/2);
            [button addSubview:loadView];
            [loadView startAnimating];// 开始旋转
        }
    }];
    [_mainScrollView setContentSize:CGSizeMake(datasArr.count*(71+30)-1, 0)];
}

//创建网页
- (void)createWebView {
    //初始化web
    UIWebView * web = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, _webBackView.frame.size.width, _webBackView.frame.size.height)];
    [web setDelegate:self];
    web.scalesPageToFit = YES;
    
    if (webViewsArr.count > currentIndex) {
        //移除旧web
        [webViewsArr[currentIndex] removeFromSuperview];
    }
    //创建新web
    [webViewsArr addObject:web];
    //游标同步
    currentIndex = webViewsArr.count-1;
    web.tag = 6000+currentIndex;
    //添加新web到滑动标题
    [datasArr addObject:[NSString stringWithFormat:@"标签%ld", currentIndex]];
    //添加转圈视图判断
    [loadOKArr addObject:@(0)];
    //添加新web到视图
    [_webBackView addSubview:webViewsArr[currentIndex]];
    [self noJump];
}

- (void)noJump {
    noJumpPage = YES;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        noJumpPage = NO;
    });
}

#pragma mark - 点击事件
- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)lastPageClick:(id)sender {
    [self noJump];
    [webViewsArr[currentIndex] goBack];
}

- (IBAction)nextPageClick:(id)sender {
    [self noJump];
    [webViewsArr[currentIndex] goForward];
}

- (IBAction)refreshClick:(id)sender {
    [self noJump];
    [loadOKArr replaceObjectAtIndex:currentIndex withObject:@(0)];
    [webViewsArr[currentIndex] reload];
    [self reloadScrollView];
}

- (IBAction)moreClick:(id)sender {
    [WZZSelectView showWithRect:CGRectMake(0, [UIScreen mainScreen].bounds.size.height/2, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height/2) dataArr:@[@"网页适应视图", @"网页不适应视图"] selectBlock:^(NSString *str) {
        if ([str isEqualToString:@"网页适应视图"]) {
            [webViewsArr[currentIndex] setScalesPageToFit:YES];
        } else if ([str isEqualToString:@"网页不适应视图"]) {
            [webViewsArr[currentIndex] setScalesPageToFit:NO];
        }
    }];
}

//切换页面
- (void)pageButtonClick:(UIButton *)btn {
    NSInteger idx = btn.tag-5000;
    //移除旧web
    [webViewsArr[currentIndex] removeFromSuperview];
    currentIndex = idx;
    //添加新web
    [_webBackView addSubview:webViewsArr[currentIndex]];
    [self reloadScrollView];
}

//关闭页面
- (void)cutPageButtonClick:(UIButton *)btn {
    NSInteger idx = btn.tag-9000;
    
    //删除页面
    if (idx == currentIndex) {
        [webViewsArr[currentIndex] removeFromSuperview];
    }
    [webViewsArr[idx] setDelegate:nil];
    [webViewsArr removeObjectAtIndex:idx];
    [loadOKArr removeObjectAtIndex:idx];
    [datasArr removeObjectAtIndex:idx];
    
    //跳转到前一页面
    if (webViewsArr.count) {
        if (idx-1 >= 0) {
            currentIndex = idx-1;
            //添加新web
            [_webBackView addSubview:webViewsArr[currentIndex]];
        } else {
            currentIndex = 0;
            //添加新web
            [_webBackView addSubview:webViewsArr[0]];
        }
    }
    [self reloadScrollView];
}

#pragma mark - tf代理
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEqualToString:@""]) {
        [textField resignFirstResponder];
        return YES;
    }
    [self createWebView];
    NSArray * arr = [textField.text rangeOfURLString];
    if (arr.count || [textField.text hasPrefix:@"http"]) {
        NSString * str = textField.text;
        if (![str hasPrefix:@"http"]) {
            str = [@"http://" stringByAppendingString:str];
        }
        [webViewsArr[currentIndex] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:str]]];
    } else {
        [webViewsArr[currentIndex] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://www.baidu.com/s?wd=%@", textField.text]]]];
    }
    [datasArr replaceObjectAtIndex:currentIndex withObject:textField.text];
    [self reloadScrollView];
    [textField resignFirstResponder];
    return YES;
}

#pragma mark - web代理
//将要加载
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    //判断是否是单击
    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
        NSString *url = [request.URL absoluteString];
        //拦截链接跳转到货源圈的动态详情
        if ([url rangeOfString:@"http"].location != NSNotFound) {
            //跳转到你想跳转的页面
            _netTf.text = url;
            [self textFieldShouldReturn:_netTf];
            return NO;
        }
    }
    return YES;
//#warning 跳页有问题
//    if (noJumpPage) {
//        NSInteger index = webView.tag-6000;
//        [loadOKArr replaceObjectAtIndex:index withObject:@(0)];
//        return YES;
//    } else {
//        noJumpPage = NO;
//        _netTf.text = request.URL.absoluteString;
//        [self textFieldShouldReturn:_netTf];
//        return NO;
//    }
}

//加载结束
- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if([webView stringByEvaluatingJavaScriptFromString:@"document.title"]){
        NSString * title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        NSInteger index = webView.tag-6000;
        [loadOKArr replaceObjectAtIndex:index withObject:@(1)];
        [datasArr replaceObjectAtIndex:index withObject:title];
        [self reloadScrollView];
    }
}

//加载失败
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSInteger index = webView.tag-6000;
    [loadOKArr replaceObjectAtIndex:index withObject:@(1)];
    [self reloadScrollView];
}

//加载开始
- (void)webViewDidStartLoad:(UIWebView *)webView {
    
}

@end
