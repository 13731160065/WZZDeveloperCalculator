//
//  WZZLiveCollectionCell.m
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import "WZZLiveCollectionCell.h"

@interface WZZLiveCollectionCell () {
    
}
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation WZZLiveCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.backgroundColor = [UIColor colorWithRed:0.97f green:0.55f blue:0.16f alpha:1.0f];
}

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString * title = _dataDic[@"title"];
    [_titleLabel setText:title];
}

@end
