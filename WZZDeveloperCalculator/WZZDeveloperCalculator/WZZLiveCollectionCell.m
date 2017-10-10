//
//  WZZLiveCollectionCell.m
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZLiveCollectionCell.h"

@interface WZZLiveCollectionCell () {
    
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

@end
