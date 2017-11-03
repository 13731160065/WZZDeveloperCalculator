//
//  WZZTimeVC.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/10/27.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZTimeVC.h"
#import "WZZTimeHandler.h"

@interface WZZTimeVC ()<UITextFieldDelegate>
{
    WZZTimeHandler * timeHandler;
    UIDatePicker * picker;
    UIView * pickerBackView;
}
@property (weak, nonatomic) IBOutlet UITextField *yearTF;
@property (weak, nonatomic) IBOutlet UITextField *timeIntTF;

@end

@implementation WZZTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    timeHandler = [WZZTimeHandler timeWithTimeStr:@"1970-00-00 00:00:00"];
}

//年
- (IBAction)yearClick:(id)sender {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    pickerBackView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:pickerBackView];
    [pickerBackView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    
    UIDatePicker * picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, pickerBackView.frame.size.height-216, pickerBackView.frame.size.width, 216)];
    [pickerBackView addSubview:picker];
    [picker setDatePickerMode:UIDatePickerModeDateAndTime];
    [picker addTarget:self action:@selector(dateChange:) forControlEvents:UIControlEventValueChanged];
    picker setDate:<#(nonnull NSDate *)#> animated:<#(BOOL)#>
}

//当前时间
- (IBAction)currentTime:(id)sender {
    
}

//时间改变
- (void)dateChange:(UIDatePicker *)aPicker {
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _timeIntTF) {
        NSInteger timeInt = [textField.text integerValue];
        
    }
}

@end
