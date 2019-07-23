//
//  WZZBaseView.h
//  SiNanQingSu
//
//  Created by 王泽众 on 2018/6/22.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface WZZBaseView : UIView

@property (nonatomic, assign) IBInspectable BOOL clipw;
@property (nonatomic, assign) IBInspectable CGFloat cornerRadiow;
@property (nonatomic, assign) IBInspectable CGFloat borderWidthw;
@property (nonatomic, assign) IBInspectable UIColor * borderColorw;
@property (nonatomic, assign) IBInspectable CGSize shadowOffsetw;
@property (nonatomic, assign) IBInspectable UIColor * shadowColorw;
@property (nonatomic, assign) IBInspectable CGFloat shadowAlphaw;

@end
