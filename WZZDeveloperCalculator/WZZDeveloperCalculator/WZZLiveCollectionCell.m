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

- (void)setDataDic:(NSDictionary *)dataDic {
    _dataDic = dataDic;
    NSString * title = _dataDic[@"title"];
    [_titleLabel setText:title];
}

@end
