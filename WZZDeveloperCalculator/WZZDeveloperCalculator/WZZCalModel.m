//
//  WZZCalModel.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZCalModel.h"

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
    _currentCalPad = _calPad10;
    return _calPad10;
}

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
    _currentCalPad = _calPad2;
    return _calPad2;
}

- (NSMutableArray *)calPad8 {
    if (!_calPad8) {
        _calPad8 = [NSMutableArray array];
        [_calPad8 addObject:@{@"title":@"AC"}];
        for (int i = 0; i < 8; i++) {
            [_calPad8 addObject:@{@"title":@(i).stringValue}];
        }
        [_calPad8 addObjectsFromArray:[self normalHandlePad]];
    }
    _currentCalPad = _calPad8;
    return _calPad8;
}

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
    _currentCalPad = _calPad16;
    return _calPad16;
}

//处理文本
- (NSString *)handleText:(NSString *)text {
    //清空
    if ([text isEqualToString:@"AC"]) {
        _d1 = nil;
        _d2 = nil;
        _op = nil;
        _currentNum = @"0";
        return _currentNum;
    } else if ([text isEqualToString:@"÷"]) {
        _op = text;
        _currentNum = _d1;
        return _currentNum;
    }
    
    //数字/运算符
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
            text = [NSString stringWithFormat:@"%@%@", _currentNum.integerValue?_currentNum:@"", text];
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
            case '!':
            case '<':
            case '>':
        {
            _op = text;
            _currentNum = _d1;
        }
            break;
            
            //等
            case '=':
        {
            _currentNum = [self startCal];
        }
            
        default:
        {
            
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
#warning 计算
        }
            break;
            case '-':
        {
            
        }
            break;
            case 'x':
        {
            
        }
            break;
            case '|':
        {
            
        }
            break;
            case '&':
        {
            
        }
            break;
            case '!':
        {
            
        }
            break;
            case '<':
        {
            
        }
            break;
            case '>':
        {
            
        }
            break;
            
        default:
        {
            if ([_op isEqualToString:@"÷"]) {
                //除
                
            }
        }
            break;
    }
    return _currentNum;
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
    NSString * strr = [NSString stringWithFormat:@"%s", a];
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

@end
