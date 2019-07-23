//
//  WZZBaseView.m
//  SiNanQingSu
//
//  Created by 王泽众 on 2018/6/22.
//  Copyright © 2018年 王泽众. All rights reserved.
//

#import "WZZBaseView.h"

@implementation WZZBaseView
- (void)setClipw:(BOOL)clipw {
    self.clipsToBounds = clipw;
}

- (void)setCornerRadiow:(CGFloat)cornerRadiow {
    self.layer.cornerRadius = cornerRadiow;
}

- (void)setBorderWidthw:(CGFloat)borderWidthw {
    self.layer.borderWidth = borderWidthw;
}

- (void)setBorderColorw:(UIColor *)borderColorw {
    self.layer.borderColor = borderColorw.CGColor;
}

- (void)setShadowOffsetw:(CGSize)shadowOffsetw {
    self.layer.shadowOffset = shadowOffsetw;
}

- (void)setShadowColorw:(UIColor *)shadowColorw {
    self.layer.shadowColor = shadowColorw.CGColor;
}

- (void)setShadowAlphaw:(CGFloat)shadowAlphaw {
    self.layer.shadowOpacity = shadowAlphaw;
}

@end
