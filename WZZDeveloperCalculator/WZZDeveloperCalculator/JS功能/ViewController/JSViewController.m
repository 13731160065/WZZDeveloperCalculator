//
//  JSViewController.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/18.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "JSViewController.h"
#import "WZZSingleManager.h"
#import "WZZLoadJSVC.h"
@import UIKit;

@interface JSViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *mainWebView;
@property (weak, nonatomic) IBOutlet UITextView *mainTV;
@property (weak, nonatomic) IBOutlet UIButton *goButton;

@end

@implementation JSViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //网页
    NSString * hStr = [NSString stringWithFormat:@"<html>\
                       <body>\
                       欢迎使用; )<br/>\
                       此处是一个网页<br/>\
                       要输出内容到此处请使用<br/>\
                       以下js方法:<br/>\
                       document.write()<br/>\
                       </body>\
                       </html>"];
    [_mainWebView loadHTMLString:hStr baseURL:nil];
    [_mainWebView setBackgroundColor:[UIColor whiteColor]];
    [_mainWebView setScalesPageToFit:YES];
    
    //输入框
    [_mainTV setText:@"在此输入JS代码"];
    [_mainTV setDelegate:self];
}

- (void)inputJs:(NSString *)js {
    NSString * hStr = [NSString stringWithFormat:@"<html>\
                       <body>\
                       <script>\
                       %@\
                       </script>\
                       </body>\
                       </html>", js];
    [_mainWebView stringByEvaluatingJavaScriptFromString:js];
    [_mainWebView loadHTMLString:hStr baseURL:nil];
}

//执行
- (IBAction)goClick:(id)sender {
    [self inputJs:_mainTV.text];
}

//返回
- (IBAction)backClick:(id)sender {
    [_mainTV resignFirstResponder];
    [self dismissViewControllerAnimated:YES completion:nil];
}

//保存
- (IBAction)saveClick:(id)sender {
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:@"请输入标题" message:@"注意:如果输入已保存过的代码标题，它将会覆盖掉你已经保存的代码" preferredStyle:UIAlertControllerStyleAlert];
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        textField.placeholder = @"标题";
    }];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[WZZSingleManager shareInstance] saveJsCode:_mainTV.text title:alert.textFields[0].text];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil]];
    [self presentViewController:alert animated:YES completion:nil];
}

//读取
- (IBAction)loadClick:(id)sender {
    WZZLoadJSVC * jsvc = [[WZZLoadJSVC alloc] init];
    [jsvc selectBackBlock:^(NSString *jsCode) {
        _mainTV.text = [_mainTV.text stringByAppendingFormat:@"\n%@", jsCode];
    }];
    [self presentViewController:jsvc animated:YES completion:nil];
}

//触摸
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [_mainTV resignFirstResponder];
}

#pragma mark - textview代理
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    if ([textView.text isEqualToString:@"在此输入JS代码"]) {
        [textView setText:@""];
    }
    return YES;
}

@end
