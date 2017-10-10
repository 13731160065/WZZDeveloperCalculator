//
//  WZZLiveCollectionCell.h
//  WZZDeveloperCalculator
//
//  Created by 王泽众 on 17/4/1.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZLiveCollectionCell : UICollectionViewCell

@property (strong, nonatomic) NSDictionary * dataDic;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

/**
 按钮被点击了
 */
- (void)buttonClickBlock:(void(^)())buttonClick;

@end
