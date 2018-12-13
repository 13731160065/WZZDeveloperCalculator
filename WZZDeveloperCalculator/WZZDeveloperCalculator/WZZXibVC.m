//
//  WZZXibVC.m
//  WZZDeveloperCalculator
//
//  Created by mac on 2018/12/13.
//  Copyright © 2018 wzz. All rights reserved.
//

#import "WZZXibVC.h"

@interface WZZXibVC ()

@end

@implementation WZZXibVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
}

- (IBAction)makeXib:(id)sender {
    NSString * str =
    @"<?xml version=\"1.0\" encoding=\"UTF-8\"?>"
    "<document type=\"com.apple.InterfaceBuilder3.CocoaTouch.XIB\" version=\"3.0\" toolsVersion=\"14460.31\" targetRuntime=\"iOS.CocoaTouch\" propertyAccessControl=\"none\" useAutolayout=\"YES\" useTraitCollections=\"YES\" useSafeAreas=\"YES\" colorMatched=\"YES\">"
    "<device id=\"retina4_7\" orientation=\"portrait\">"
    "<adaptation id=\"fullscreen\"/>"
    "</device>"
    "<dependencies>"
    "<deployment identifier=\"iOS\"/>"
    "<plugIn identifier=\"com.apple.InterfaceBuilder.IBCocoaTouchPlugin\" version=\"14460.20\"/>"
    "<capability name=\"Safe area layout guides\" minToolsVersion=\"9.0\"/>"
    "<capability name=\"documents saved in the Xcode 8 format\" minToolsVersion=\"8.0\"/>"
    "</dependencies>"
    "<objects>"
    "<placeholder placeholderIdentifier=\"IBFilesOwner\" id=\"-1\" userLabel=\"File's Owner\" customClass=\"WZZXibVC\">"
    "<connections>"
    "<outlet property=\"view\" destination=\"i5M-Pr-FkT\" id=\"sfx-zR-JGt\"/>"
    "</connections>"
    "</placeholder>"
    "<placeholder placeholderIdentifier=\"IBFirstResponder\" id=\"-2\" customClass=\"UIResponder\"/>"
    "<view clearsContextBeforeDrawing=\"NO\" contentMode=\"scaleToFill\" id=\"i5M-Pr-FkT\">"
    "<rect key=\"frame\" x=\"0.0\" y=\"0.0\" width=\"375\" height=\"667\"/>"
    "<autoresizingMask key=\"autoresizingMask\" widthSizable=\"YES\" heightSizable=\"YES\"/>";
    
    //拼接subview
    
    //颜色
    str = [str stringByAppendingString:@"<color key=\"backgroundColor\" red=\"1\" green=\"1\" blue=\"1\" alpha=\"1\" colorSpace=\"custom\" customColorSpace=\"sRGB\"/>"];
}

- (void)appendColor:(UIColor *)color {
    const CGFloat * colorCom = CGColorGetComponents(color.CGColor);
    NSLog(@"r:%g, g:%g, b:%g, a:%g", colorCom[0], colorCom[1], colorCom[2], colorCom[3]);
    
}


@end
