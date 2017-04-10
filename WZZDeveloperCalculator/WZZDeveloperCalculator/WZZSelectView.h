//
//  WZZSelectView.h
//  WZZDeveloperCalculator
//
//  Created by 舞蹈圈 on 17/4/10.
//  Copyright © 2017年 wzz. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WZZSelectView : UIView

/**
 选择block
 */
- (void)selectBlock:(void(^)(NSString * selectStr))aBlock;

@end
