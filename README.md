# ColorPicker  
拾色器，调色板

# 使用方法

JKColorPicker类  
<pre><code>  
/**
获取view上任何一点的颜色

 @param point 位置
 @param view  寻找的view

 @return 得到该点像素的颜色
 */
+ (UIColor *)colorOfPoint:(CGPoint)point inView:(UIView *)view;
</code></pre>

JKColorPanel类  
直接类似view创建即可
<pre><code>  
    JKColorPanel *panel = [[JKColorPanel alloc] init];  
    panel.backgroundColor = [UIColor lightGrayColor];  
    panel.frame = CGRectMake(self.view.center.x - 100, self.view.center.y, 250, 150);  
    [self.view addSubview:panel];
</code></pre>
实现JKColorPanel的代理即可获得调配的颜色
<pre><code>
@protocol JKColorPanelDelegate <NSObject>
- (void)colorPanel:(JKColorPanel *)panel pickedColor:(UIColor *)color;
- (void)colorPanel:(JKColorPanel *)panel pickedColorRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue alpha:(CGFloat)alpha;
@end
</code></pre>

# 预览图

![image](https://github.com/spxvszero/ColorPicker/blob/master/ScreenShot/colorpicker.gif)
