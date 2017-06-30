//
//  JKColorPicker.h
//  ColorPicker
//
//  Created by jacky on 2017/6/29.
//  Copyright © 2017年 jacky. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JKColorPicker : NSObject

/**
 获取view上任何一点的颜色

 @param point 位置
 @param view  寻找的view

 @return 得到该点像素的颜色
 */
+ (UIColor *)colorOfPoint:(CGPoint)point inView:(UIView *)view;

@end


@class JKColorPanel;
@protocol JKColorPanelDelegate <NSObject>
- (void)colorPanel:(JKColorPanel *)panel pickedColor:(UIColor *)color;
- (void)colorPanel:(JKColorPanel *)panel pickedColorRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue alpha:(CGFloat)alpha;
@end

@interface JKColorPanel : UIView
@property (nonatomic,weak) id<JKColorPanelDelegate> delegate;
@end


@class JKColorSlider;
@protocol JKColorSliderDelegate <NSObject>
- (void)colorSlider:(JKColorSlider *)sliderView valueDidChange:(CGFloat)value;
@end

@interface JKColorSlider : UIView

@property (nonatomic,weak) id<JKColorSliderDelegate> delegate;


/**
 初始化滑条

 @param red   红色值0~1
 @param green 绿色值0~1
 @param blue  蓝色值0~1

 @return 实例对象
 */
- (instancetype)initWithColorRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue;


/**
 更新滑条背景颜色

 @param red   红色值
 @param green 绿色值
 @param blue  蓝色值
 */
- (void)updateColorWithRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue;

@end
