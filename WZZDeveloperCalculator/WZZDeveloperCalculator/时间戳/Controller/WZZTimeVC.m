//
//  WZZTimeVC.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 2017/10/27.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZTimeVC.h"
#import "WZZTimeHandler.h"

@interface WZZTimeVC ()<UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>
{
    WZZTimeHandler * timeHandler;
    UIDatePicker * picker;
    UIView * pickerBackView;
    NSString * hour1;
    NSString * min2;
    NSString * sec3;
}
@property (weak, nonatomic) IBOutlet UITextField *timeTF;
@property (weak, nonatomic) IBOutlet UITextField *yearTF;
@property (weak, nonatomic) IBOutlet UITextField *timeIntTF;

@end

@implementation WZZTimeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    timeHandler = [WZZTimeHandler timeWithTimeStr:@"1970-01-01 08:00:00"];
    hour1 = @"08";
    min2 = @"00";
    sec3 = @"00";
    [self setAutomaticallyAdjustsScrollViewInsets:NO];
    [self reloadDate];
}

- (void)reloadDate {
    _yearTF.text = [NSString stringWithFormat:@"%04d-%02d-%02d", timeHandler.year, timeHandler.month, timeHandler.day];
    _timeIntTF.text = @(timeHandler.timeTemp).stringValue;
    _timeTF.text = [NSString stringWithFormat:@"%02d:%02d:%02d", timeHandler.hour, timeHandler.min, timeHandler.sec];
}

- (IBAction)addTime:(id)sender {
    hour1 = @"00";
    min2 = @"00";
    sec3 = @"00";
    [self creatTimeWithTag:5401];
}

- (IBAction)minusTime:(id)sender {
    hour1 = @"00";
    min2 = @"00";
    sec3 = @"00";
    [self creatTimeWithTag:5402];
}

- (IBAction)addTimeInt:(id)sender {
    UIAlertController * con = [UIAlertController alertControllerWithTitle:@"加时间戳" message:@"请输入要加的时间戳（以秒为单位）" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField * aTf;
    [con addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField becomeFirstResponder];
        aTf = textField;
    }];
    [con addAction:[UIAlertAction actionWithTitle:@"转换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        timeHandler = [WZZTimeHandler timeWithTimeTemp:timeHandler.timeTemp+aTf.text.integerValue];
        [self reloadDate];
    }]];
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:con animated:YES completion:nil];
}

- (IBAction)minusTimeInt:(id)sender {
    UIAlertController * con = [UIAlertController alertControllerWithTitle:@"减时间戳" message:@"请输入要减的时间戳（以秒为单位）" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField * aTf;
    [con addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField becomeFirstResponder];
        aTf = textField;
    }];
    [con addAction:[UIAlertAction actionWithTitle:@"转换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        timeHandler = [WZZTimeHandler timeWithTimeTemp:timeHandler.timeTemp-aTf.text.integerValue];
        [self reloadDate];
    }]];
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:con animated:YES completion:nil];
}

- (IBAction)timeIntClick:(id)sender {
    UIAlertController * con = [UIAlertController alertControllerWithTitle:@"时间戳" message:@"请输入时间戳" preferredStyle:UIAlertControllerStyleAlert];
    __block UITextField * aTf;
    [con addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [textField setKeyboardType:UIKeyboardTypeNumberPad];
        [textField becomeFirstResponder];
        [textField setText:_timeIntTF.text];
        aTf = textField;
    }];
    [con addAction:[UIAlertAction actionWithTitle:@"转换" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        timeHandler = [WZZTimeHandler timeWithTimeTemp:aTf.text.integerValue];
        [self reloadDate];
    }]];
    [con addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }]];
    [self presentViewController:con animated:YES completion:nil];
}

- (IBAction)backClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)timeClick:(id)sender {
    hour1 = [NSString stringWithFormat:@"%02d", timeHandler.hour];
    min2 = [NSString stringWithFormat:@"%02d", timeHandler.min];
    sec3 = [NSString stringWithFormat:@"%02d", timeHandler.sec];
    [self creatTimeWithTag:5400];
}

- (void)creatTimeWithTag:(NSInteger)tag {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    pickerBackView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:pickerBackView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [pickerBackView setGestureRecognizers:@[tap]];
    [pickerBackView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [pickerBackView setAlpha:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [pickerBackView setAlpha:1.0f];
    }];
    
    UIPickerView * picker = [[UIPickerView alloc] initWithFrame:CGRectMake(8, pickerBackView.frame.size.height-208, pickerBackView.frame.size.width-16, 216)];
    [pickerBackView addSubview:picker];
    [picker setTag:tag];
    [picker setBackgroundColor:[UIColor whiteColor]];
    [picker setDelegate:self];
    [picker setDataSource:self];
    [picker.layer setCornerRadius:10.0f];
    [picker.layer setMasksToBounds:YES];
    [picker selectRow:timeHandler.hour inComponent:0 animated:YES];
    [picker selectRow:timeHandler.min inComponent:1 animated:YES];
    [picker selectRow:timeHandler.sec inComponent:2 animated:YES];
}

//年
- (IBAction)yearClick:(id)sender {
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    
    pickerBackView = [[UIView alloc] initWithFrame:window.bounds];
    [window addSubview:pickerBackView];
    UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
    [pickerBackView setGestureRecognizers:@[tap]];
    [pickerBackView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
    [pickerBackView setAlpha:0.0f];
    [UIView animateWithDuration:0.3f animations:^{
        [pickerBackView setAlpha:1.0f];
    }];
    
    UIDatePicker * picker = [[UIDatePicker alloc] initWithFrame:CGRectMake(8, pickerBackView.frame.size.height-208, pickerBackView.frame.size.width-16, 216)];
    [pickerBackView addSubview:picker];
    [picker setBackgroundColor:[UIColor whiteColor]];
    [picker setDatePickerMode:UIDatePickerModeDate];
    [picker addTarget:self action:@selector(yearChange:) forControlEvents:UIControlEventValueChanged];
    if (timeHandler.date) {
        [picker setDate:timeHandler.date animated:YES];
    }
    [picker.layer setCornerRadius:10.0f];
    [picker.layer setMasksToBounds:YES];
}

- (void)tapClick:(UITapGestureRecognizer *)tap {
    [UIView animateWithDuration:0.3f animations:^{
        [pickerBackView setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [pickerBackView removeFromSuperview];
    }];
    [_timeIntTF resignFirstResponder];
}

//当前时间
- (IBAction)currentTime:(id)sender {
    timeHandler = [WZZTimeHandler now];
    [self reloadDate];
}

//时间改变
- (void)yearChange:(UIDatePicker *)aPicker {
    timeHandler = [WZZTimeHandler timeWithDate:aPicker.date];
    [self reloadDate];
}

- (void)timeChange:(UIDatePicker *)aPicker {
    timeHandler = [WZZTimeHandler timeWithDate:aPicker.date];
    [self reloadDate];
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    if (textField == _timeIntTF) {
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        pickerBackView = [[UIView alloc] initWithFrame:window.bounds];
        [window addSubview:pickerBackView];
        UITapGestureRecognizer * tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapClick:)];
        [pickerBackView setGestureRecognizers:@[tap]];
        [pickerBackView setBackgroundColor:[UIColor colorWithWhite:0.0f alpha:0.5f]];
        [pickerBackView setAlpha:0.0f];
        [UIView animateWithDuration:0.3f animations:^{
            [pickerBackView setAlpha:1.0f];
        }];
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if (textField == _timeIntTF) {
        NSInteger timeInt = [textField.text integerValue];
        timeHandler = [WZZTimeHandler timeWithTimeTemp:timeInt];
        [self reloadDate];
    }
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    if (component == 0) {
        return 24;
    } else {
        return 60;
    }
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    switch (component) {
        case 0:
            return [NSString stringWithFormat:@"%02zd时", row];
        case 1:
            return [NSString stringWithFormat:@"%02zd分", row];
        case 2:
            return [NSString stringWithFormat:@"%02zd秒", row];
        default:
            return [NSString stringWithFormat:@"%02zd", row];
    }
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            hour1 = [NSString stringWithFormat:@"%02zd", row];
        }
            break;
        case 1: {
            min2 = [NSString stringWithFormat:@"%02zd", row];
        }
            break;
        case 2: {
            sec3 = [NSString stringWithFormat:@"%02zd", row];
        }
            break;
            
        default:
            break;
    }
    if (pickerView.tag == 5400) {
        timeHandler = [WZZTimeHandler timeWithTimeStr:[NSString stringWithFormat:@"%04d-%02d-%02d %@:%@:%@", timeHandler.year, timeHandler.month, timeHandler.day, hour1, min2, sec3]];
        [self reloadDate];
    } else if (pickerView.tag == 5401) {
        timeHandler = [WZZTimeHandler timeWithTimeStr:[NSString stringWithFormat:@"%04d-%02d-%02d %02zd:%02zd:%02zd", timeHandler.year, timeHandler.month, timeHandler.day, timeHandler.hour+hour1.integerValue, timeHandler.min+min2.integerValue, timeHandler.sec+sec3.integerValue]];
        [self reloadDate];
    } else if (pickerView.tag == 5402) {
        timeHandler = [WZZTimeHandler timeWithTimeStr:[NSString stringWithFormat:@"%04d-%02d-%02d %@:%@:%@", timeHandler.year, timeHandler.month, timeHandler.day, hour1, min2, sec3]];
        [self reloadDate];
    }
}

@end
