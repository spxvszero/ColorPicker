//
//  JKColorPicker.m
//  ColorPicker
//
//  Created by jacky on 2017/6/29.
//  Copyright © 2017年 jacky. All rights reserved.
//

#import "JKColorPicker.h"
#import <QuartzCore/QuartzCore.h>


@implementation JKColorPicker


+ (UIColor *)colorOfPoint:(CGPoint)point inView:(UIView *)view {
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4, colorSpace, (CGBitmapInfo)kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [view.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    UIColor *color = [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}

@end


@interface JKColorPanel()<JKColorSliderDelegate>

@property (nonatomic,assign) CGFloat red;
@property (nonatomic,assign) CGFloat green;
@property (nonatomic,assign) CGFloat blue;
@property (nonatomic,weak) JKColorSlider *redSlider;
@property (nonatomic,weak) JKColorSlider *greenSlider;
@property (nonatomic,weak) JKColorSlider *blueSlider;
@property (nonatomic,strong) CALayer *preViewLayer;
@property (nonatomic,strong) UILabel *label;


@end
@implementation JKColorPanel

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.red = 0;
        self.green = 0;
        self.blue = 0;
        [self setupSubviews];
    }
    return self;
}

- (void)setupSubviews
{
    self.preViewLayer = [[CALayer alloc] init];
    self.preViewLayer.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1].CGColor;
    self.preViewLayer.borderColor = [UIColor blackColor].CGColor;
    self.preViewLayer.borderWidth = 2;
    [self.layer addSublayer:self.preViewLayer];
    
    self.label = [[UILabel alloc] init];
    self.label.textColor = [UIColor blackColor];
    self.label.textAlignment = NSTextAlignmentCenter;
    self.label.font = [UIFont systemFontOfSize:11];
    self.label.text = @"#000000";
    [self addSubview:self.label];
    
    JKColorSlider *redSlider = [[JKColorSlider alloc] initWithColorRValue:1 GValue:0 BValue:0];
    redSlider.delegate = self;
    [self addSubview:redSlider];
    self.redSlider = redSlider;
    
    JKColorSlider *greenSlider = [[JKColorSlider alloc] initWithColorRValue:0 GValue:1 BValue:0];
    greenSlider.delegate = self;
    [self addSubview:greenSlider];
    self.greenSlider = greenSlider;
    
    JKColorSlider *blueSlider = [[JKColorSlider alloc] initWithColorRValue:0 GValue:0 BValue:1];
    blueSlider.delegate = self;
    [self addSubview:blueSlider];
    self.blueSlider = blueSlider;
}

- (void)colorSlider:(JKColorSlider *)sliderView valueDidChange:(CGFloat)value
{
    if ([sliderView isEqual:self.redSlider]) {
        self.red = value;
        [self.greenSlider updateColorWithRValue:value GValue:0 BValue:self.blue];
        [self.blueSlider updateColorWithRValue:value GValue:self.green BValue:0];
    }
    if ([sliderView isEqual:self.greenSlider]) {
        self.green = value;
        [self.redSlider updateColorWithRValue:0 GValue:value BValue:self.blue];
        [self.blueSlider updateColorWithRValue:self.red GValue:value BValue:0];
    }
    if ([sliderView isEqual:self.blueSlider]) {
        self.blue = value;
        [self.greenSlider updateColorWithRValue:self.red GValue:0 BValue:value];
        [self.redSlider updateColorWithRValue:0 GValue:self.green BValue:value];
    }
    
    self.preViewLayer.backgroundColor = [UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1].CGColor;
    self.label.text = [NSString stringWithFormat:@"#%02x%02x%02x",(int)(self.red * 255),(int)(self.green * 255),(int)(self.blue * 255)];
    
    if ([self.delegate respondsToSelector:@selector(colorPanel:pickedColor:)]) {
        [self.delegate colorPanel:self pickedColor:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1]];
    }
    
    if ([self.delegate respondsToSelector:@selector(colorPanel:pickedColorRValue:GValue:BValue:alpha:)]) {
        [self.delegate colorPanel:self pickedColorRValue:self.red GValue:self.green BValue:self.blue alpha:1];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.preViewLayer.frame = CGRectMake(10, 30 * 3 * 0.5 - 20, 40, 40);
    self.label.frame = CGRectMake(0, CGRectGetMaxY(self.preViewLayer.frame), 55, 30);
    
    self.redSlider.frame = CGRectMake(60, 0, self.bounds.size.width - 60, 30);
    self.greenSlider.frame = CGRectMake(60, 40, self.bounds.size.width - 60, 30);
    self.blueSlider.frame = CGRectMake(60, 80, self.bounds.size.width - 60, 30);
}


@end


@interface JKColorSlider()

@property (nonatomic,assign) CGFloat red;
@property (nonatomic,assign) CGFloat green;
@property (nonatomic,assign) CGFloat blue;
@property (nonatomic,strong) UISlider *slider;
@property (nonatomic,strong) CAGradientLayer *gLayer;

@end
@implementation JKColorSlider

- (instancetype)init
{
    if ([super init]) {
        self.red = 0;
        self.green = 0;
        self.blue = 0;
        [self setupSubviews:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1]];
    }
    
    return self;
}

- (instancetype)initWithColorRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue
{
    if (self = [super init]) {
        self.red = red;
        self.green = green;
        self.blue = blue;
        [self setupSubviews:[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1]];
    }
    return self;
}

- (void)setupSubviews:(UIColor *)color
{
    self.backgroundColor = color;
    self.layer.borderColor = [UIColor darkGrayColor].CGColor;
    self.layer.borderWidth = 1;
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithRed:0 green:0 blue:0 alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:self.red green:self.green blue:self.blue alpha:1].CGColor];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(1.0, 0);
    [self.layer addSublayer:gradientLayer];
    self.gLayer = gradientLayer;
    
    self.slider = [[UISlider alloc] init];
    self.slider.maximumValue = 1.f;
    self.slider.minimumValue = 0.f;
    [self.slider setThumbImage:[self createRectImage] forState:UIControlStateNormal];
    [self.slider setMinimumTrackTintColor:[UIColor clearColor]];
    [self.slider setMaximumTrackTintColor:[UIColor clearColor]];
    [self.slider addTarget:self action:@selector(valueChange:) forControlEvents:UIControlEventValueChanged];
    [self addSubview:self.slider];
}

- (void)valueChange:(UISlider *)slider
{
    if ([self.delegate respondsToSelector:@selector(colorSlider:valueDidChange:)]) {
        [self.delegate colorSlider:self valueDidChange:slider.value];
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.slider.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    self.gLayer.frame = CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height);
    
}

- (UIImage *)createRectImage
{
    CGSize size = CGSizeMake(10, 30);
    UIGraphicsBeginImageContextWithOptions(size, 0, [UIScreen mainScreen].scale);
    [[UIColor darkGrayColor] set];
    UIRectFill(CGRectMake(0, 0, size.width, size.height));
    [[UIColor whiteColor] set];
    UIRectFill(CGRectMake(1, 1, size.width-2, size.height-2));
    UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return img;
}


- (void)updateColorWithRValue:(CGFloat)red GValue:(CGFloat)green BValue:(CGFloat)blue
{
    self.gLayer.colors = @[(__bridge id)[UIColor colorWithRed:MAX(red, 0) green:MAX(green, 0) blue:MAX(blue, 0) alpha:1].CGColor, (__bridge id)[UIColor colorWithRed:MAX(red, self.red) green:MAX(green,self.green) blue:MAX(blue, self.blue) alpha:1].CGColor];
    
    [self setNeedsDisplay];
}

@end
