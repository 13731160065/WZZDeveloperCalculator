//
//  WZZLiveCollectionCell.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZLiveCollectionCell.h"

@interface WZZLiveCollectionCell () {
    void(^_buttonClickBlock)();
}

@end

@implementation WZZLiveCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString * title = _dataDic[@"title"];
    [_titleLabel setText:title];
}

- (void)buttonClickBlock:(void (^)())buttonClick {
    _buttonClickBlock = buttonClick;
}

- (IBAction)touchCancel:(id)sender {
    [UIView animateWithDuration:0.2f animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    }];
}

- (IBAction)buttonTouchDown:(id)sender {
    [self setTransform:CGAffineTransformMakeScale(0.95f, 0.95f)];
}

- (IBAction)buttonClick:(id)sender {
    if (_buttonClickBlock) {
        _buttonClickBlock();
    }
    [UIView animateWithDuration:0.1f animations:^{
        [self setTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];
    }];
}

@end
