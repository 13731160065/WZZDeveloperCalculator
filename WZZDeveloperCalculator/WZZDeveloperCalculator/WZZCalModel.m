//
//  WZZCalModel.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZCalModel.h"
@import UIKit;

#warning wzz算小数有问题

static WZZCalModel * model;

@interface WZZCalModel () {
    NSMutableArray * _calPad2;
    NSMutableArray * _calPad8;
    NSMutableArray * _calPad10;
    NSMutableArray * _calPad16;
}

@end

@implementation WZZCalModel

+ (instancetype)shareInstance {
    if (!model) {
        model = [[WZZCalModel alloc] init];
    }
    return model;
}

- (NSArray *)normalHandlePad {
    return @[
             @{@"title":@"+"},
             @{@"title":@"-"},
             @{@"title":@"x"},
             @{@"title":@"÷"},
             @{@"title":@"="},
             ];
}

#pragma mark - 改变键盘时的操作
//变成16
- (void)changeCurrentNumberTo16 {
    if (_currentCalPad == _calPad2) {
        _currentNum = [self change16From10:[self change10From2:_currentNum]];
    } else if (_currentCalPad == _calPad8) {
        _currentNum = [self change16From10:[self change10From8:_currentNum]];
    } else if (_currentCalPad == _calPad10) {
        _currentNum = [self change16From10:_currentNum];
    }
}

//变成10
- (void)changeCurrentNumberTo10 {
    if (_currentCalPad == _calPad2) {
        _currentNum = [self change10From2:_currentNum];
    } else if (_currentCalPad == _calPad8) {
        _currentNum = [self change10From8:_currentNum];
    } else if (_currentCalPad == _calPad16) {
        _currentNum = [self change10From16:_currentNum];
    }
}

//变成8
- (void)changeCurrentNumberTo8 {
    if (_currentCalPad == _calPad2) {
        _currentNum = [self change8From10:[self change10From2:_currentNum]];
    } else if (_currentCalPad == _calPad16) {
        _currentNum = [self change8From10:[self change10From16:_currentNum]];
    } else if (_currentCalPad == _calPad10) {
        _currentNum = [self change8From10:_currentNum];
    }
}

//变成2
- (void)changeCurrentNumberTo2 {
    if (_currentCalPad == _calPad8) {
        _currentNum = [self change2From10:[self change10From8:_currentNum]];
    } else if (_currentCalPad == _calPad10) {
        _currentNum = [self change2From10:_currentNum];
    } else if (_currentCalPad == _calPad16) {
        _currentNum = [self change2From10:[self change10From16:_currentNum]];
    }
}

#pragma mark - 获取键盘
//键盘10
- (NSMutableArray *)calPad10 {
    if (!_calPad10) {
        _calPad10 = [NSMutableArray array];
        [_calPad10 addObject:@{@"title":@"AC"}];
        //0123456789
        for (int i = 0; i < 10; i++) {
            [_calPad10 addObject:@{@"title":@(i).stringValue}];
        }
        
        //+-x÷=
        [_calPad10 addObjectsFromArray:[self normalHandlePad]];
    }
    [self changeCurrentNumberTo10];
    _currentCalPad = _calPad10;
    return _calPad10;
}

//键盘2
- (NSMutableArray *)calPad2 {
    if (!_calPad2) {
        _calPad2 = [NSMutableArray array];
        [_calPad2 addObject:@{@"title":@"AC"}];
        [_calPad2 addObjectsFromArray:@[
                                        @{@"title":@"0"},
                                        @{@"title":@"1"},
                                        @{@"title":@"<<"},
                                        @{@"title":@">>"},
                                        @{@"title":@"|"},
                                        @{@"title":@"&"},
                                        @{@"title":@"^"},
                                        @{@"title":@"!"}
                                        ]];
        [_calPad2 addObjectsFromArray:[self normalHandlePad]];
    }
    [self changeCurrentNumberTo2];
    _currentCalPad = _calPad2;
    return _calPad2;
}

//键盘8
- (NSMutableArray *)calPad8 {
    if (!_calPad8) {
        _calPad8 = [NSMutableArray array];
        [_calPad8 addObject:@{@"title":@"AC"}];
        for (int i = 0; i < 8; i++) {
            [_calPad8 addObject:@{@"title":@(i).stringValue}];
        }
        [_calPad8 addObjectsFromArray:[self normalHandlePad]];
    }
    [self changeCurrentNumberTo8];
    _currentCalPad = _calPad8;
    return _calPad8;
}

//键盘16
- (NSMutableArray *)calPad16 {
    if (!_calPad16) {
        _calPad16 = [NSMutableArray array];
        [_calPad16 addObject:@{@"title":@"AC"}];
        for (int i = 0; i < 10; i++) {
            [_calPad16 addObject:@{@"title":@(i).stringValue}];
        }
        for (int i = 0; i < 6; i++) {
            [_calPad16 addObject:@{@"title":[NSString stringWithFormat:@"%c", 'A'+i]}];
        }
        [_calPad16 addObjectsFromArray:[self normalHandlePad]];
    }
    [self changeCurrentNumberTo16];
    _currentCalPad = _calPad16;
    return _calPad16;
}

#pragma mark - 处理文本
//处理文本
- (NSString *)handleText:(NSString *)text {
    //清空
    if ([text isEqualToString:@"AC"]) {
        _d1 = nil;
        _d2 = nil;
        _op = nil;
        _currentNum = @"0";
        return _currentNum;
    }
    
    //数字/运算符
    return [self handleTextNumber:text];
}

- (NSString *)inputLongText:(NSString *)text {
    if (_currentCalPad == _calPad2) {
        text = [self change2From10:text];
    } else if (_currentCalPad == _calPad8) {
        text = [self change8From10:text];
    } else if (_currentCalPad == _calPad16) {
        text = [self change16From10:text];
    } else if (_currentCalPad == _calPad10) {
        text = text;
    }
    return [self handleTextNumber:text];
}

//处理
- (NSString *)handleTextNumber:(NSString *)text {
    //输入数字
    switch ([text characterAtIndex:0])
    {
            //数字
        case '0':
        case '1':
        case '2':
        case '3':
        case '4':
        case '5':
        case '6':
        case '7':
        case '8':
        case '9':
        case 'A':
        case 'B':
        case 'C':
        case 'D':
        case 'E':
        case 'F':
        {
            if (_currentNum && ![_currentNum isEqualToString:@"0"]) {
                //如果是0
                text = [NSString stringWithFormat:@"%@%@", _currentNum, text];
            }
            if (!_op) {
                //操作数1
                _d1 = text;
                _currentNum = text;
            } else {
                //操作数2
                _d2 = text;
                _currentNum = text;
            }
        }
            break;
            
            //运算符
        case '+':
        case '-':
        case 'x':
        case '|':
        case '&':
        case '<':
        case '>':
        case '^':
        {
            //如果操作数2不为空，则先计算
            if (_d2) {
                _currentNum = [self startCal];
            }
            
            //然后d2被置空，再给操作符赋值
            if (_op) {
                _op = text;
            } else {
                _op = text;
                _d1 = _currentNum;
                _currentNum = @"0";
            }
            return _d1;
        }
            break;
            
            //等
        case '=':
        {
            _currentNum = [self startCal];
        }
            break;
        case '!':
        {
            if (_d1) {
                _op = @"!";
                _d2 = nil;
                _currentNum = [self startCal];
            }
        }
            break;
            
        default:
        {
            if ([text isEqualToString:@"÷"]) {
                //除
                //如果操作数2不为空，则先计算
                if (_d2) {
                    _currentNum = [self startCal];
                }
                
                //然后d2被置空，再给操作符赋值
                if (_op) {
                    _op = text;
                } else {
                    _op = text;
                    _d1 = _currentNum;
                    _currentNum = @"0";
                }
                return _d1;
            }
        }
            break;
    }
    return _currentNum;
}

//开始计算
- (NSString *)startCal {
    switch ([_op characterAtIndex:0]) {
        case '+':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue+[self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '-':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue-[self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case 'x':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue*[self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '|':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue | [self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '&':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue & [self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '!':
        {
            if (_currentCalPad == _calPad2) {
                NSString * answer = @"";
                NSString * num2 = _currentNum;
                for (int i = 0; i < num2.length; i++) {
                    answer = [answer stringByAppendingFormat:@"%d", !([num2 characterAtIndex:i]-'0')];
                }
                _currentNum = answer;
            }
        }
            break;
        case '<':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue<<[self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '>':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue>>[self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
        case '^':
        {
            NSString * answer = @([self numberTo10:_d1].integerValue ^ [self numberTo10:_d2].integerValue).stringValue;
            _currentNum = [self handleAnswer:answer];
        }
            break;
            
        default:
        {
            if ([_op isEqualToString:@"÷"]) {
                //除
                NSString * answer = @([self numberTo10:_d1].doubleValue/[self numberTo10:_d2].doubleValue).stringValue;
                _currentNum = [self handleAnswer:answer];
            }
        }
            break;
    }
    _d1 = _currentNum;
    _d2 = nil;
    _op = nil;
    return _currentNum;
}

//处理结果
- (NSString *)handleAnswer:(NSString *)answer {
    NSString * answerR;
    if (_currentCalPad == _calPad2) {
        answerR = [self change2From10:answer];
    } else if (_currentCalPad == _calPad8) {
        answerR = [self change8From10:answer];
    } else if (_currentCalPad == _calPad16) {
        answerR = [self change16From10:answer];
    } else if (_currentCalPad == _calPad10) {
        answerR = answer;
    }
    return answerR;
}

//任何数变成10进制(根据当前选择的键盘来判断)
- (NSString *)numberTo10:(NSString *)n {
    if (_currentCalPad == _calPad2) {
        n = [self change10From2:n];
    } else if (_currentCalPad == _calPad8) {
        n = [self change10From8:n];
    } else if (_currentCalPad == _calPad16) {
        n = [self change10From16:n];
    }
    return n;
}

#pragma mark - 进制转换
//2转10
- (NSString *)change10From2:(NSString *)n2 {
    //补齐4的倍数位
    for (int i = 0; i < n2.length%4; i++) {
        n2 = [@"0" stringByAppendingString:n2];
    }
    
    //遍历二进制字符串，每位有1的地方，算出2的他所在位置次方的得数，累加
    NSInteger sum = 0;
    int j = 0;
    for (NSInteger i = (NSInteger)n2.length-1; i >= 0; i--) {
        long aa = [n2 characterAtIndex:i]-'0';
        if (aa) {
            sum += (NSInteger)pow(2, j);
        }
        if (j == 63) {
            sum += 1;
        }
        j++;
    }
    
    return [NSString stringWithFormat:@"%ld", sum];
}

//16转10
- (NSString *)change10From16:(NSString *)n16 {
    n16 = [n16 lowercaseString];
    //生成对照表
    NSDictionary * dic = @{
                           @"0":@"0000",
                           @"1":@"0001",
                           @"2":@"0010",
                           @"3":@"0011",
                           @"4":@"0100",
                           @"5":@"0101",
                           @"6":@"0110",
                           @"7":@"0111",
                           @"8":@"1000",
                           @"9":@"1001",
                           @"a":@"1010",
                           @"b":@"1011",
                           @"c":@"1100",
                           @"d":@"1101",
                           @"e":@"1110",
                           @"f":@"1111"
                           };
    NSString * returnStr = @"";
    for (int i = 0; i < n16.length; i++) {
        returnStr = [returnStr stringByAppendingString:dic[[NSString stringWithFormat:@"%c", [n16 characterAtIndex:i]]]];
    }
    return [self change10From2:returnStr];
}

//8转10
- (NSString *)change10From8:(NSString *)n8 {
    //生成对照表
    NSDictionary * dic = @{
                           @"0":@"000",
                           @"1":@"001",
                           @"2":@"010",
                           @"3":@"011",
                           @"4":@"100",
                           @"5":@"101",
                           @"6":@"110",
                           @"7":@"111"
                           };
    NSString * returnStr = @"";
    for (int i = 0; i < n8.length; i++) {
        returnStr = [returnStr stringByAppendingString:dic[[NSString stringWithFormat:@"%c", [n8 characterAtIndex:i]]]];
    }
    return [self change10From2:returnStr];
}

//10转2
- (NSString *)change2From10:(NSString *)n10 {
    
    NSInteger nnn = n10.integerValue;
    BOOL isFu = NO;
    if (nnn < 0) {
        nnn = -nnn;
        isFu = YES;
    }
    //预判断2进制位数
    long num = [NSString stringWithFormat:@"%lx", nnn].length*4;
    char a[num+1];
    long i;
    
    //从后往前便利入参，取2的模模存入数组，再除以2
    for (i = num-1; i >= 0; i--) {
        a[i] = nnn % 2+'0';
        nnn /= 2;
    }
    a[num] = '\0';
    
    //转换字符串
    NSMutableString * strr = [NSMutableString stringWithFormat:@"%s", a];
    
    //如果是负数
    if (isFu) {
        //补0
        for (int i = 0; i < 64-num; i++) {
            [strr insertString:@"0" atIndex:0];
        }
        
        //取反
        NSString * num2 = strr;
        strr = [NSMutableString stringWithString:@""];
        for (int i = 0; i < num2.length; i++) {
            [strr appendFormat:@"%d", !([num2 characterAtIndex:i]-'0')];
        }
        
        //加1
        NSInteger jjj = strr.length-1;
        int strJJJ = [strr characterAtIndex:jjj]-'0';
        
        do {
            strJJJ = [strr characterAtIndex:jjj]-'0';
            if (strJJJ) {
                //1
                [strr replaceCharactersInRange:NSMakeRange(jjj, 1) withString:@"0"];
            } else {
                //0
                [strr replaceCharactersInRange:NSMakeRange(jjj, 1) withString:@"1"];
                break;
            }
            jjj--;
            if (jjj < 0) {
                break;
            }
        } while (strJJJ);
    }
    
    return strr;
}

//10转8
- (NSString *)change8From10:(NSString *)n10 {
    return [NSString stringWithFormat:@"%lo", n10.integerValue];
}

//10转16
- (NSString *)change16From10:(NSString *)n10 {
    return [[NSString stringWithFormat:@"%lx", n10.integerValue] uppercaseString];
}

//字符串转相同16进制
- (UInt32)strToSame16WithStr:(NSString *)str {
    UInt32 bbb = 0x0;
    for (int i = 0; i < str.length; i++) {
        bbb += ([str characterAtIndex:i]-'0')*pow(16, str.length-i-1);
    }
    return bbb;
}

//复制文字
+ (NSString *)copyWithText:(NSString *)text {
    UIPasteboard *pab = [UIPasteboard generalPasteboard];
    [pab setString:text];
    if (pab == nil) {
        return @"复制失败";
    } else {
        return @"已复制";
    }
}

@end
