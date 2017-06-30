//
//  ViewController.m
//  ColorPicker
//
//  Created by jacky on 2017/6/26.
//  Copyright © 2017年 jacky. All rights reserved.
//

#import "ViewController.h"
#import "JKColorPicker.h"


@interface ViewController ()

@property (nonatomic,weak) UIImageView *imgView;

@property (nonatomic,weak) CALayer *sliderBackLayer;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    JKColorPanel *panel = [[JKColorPanel alloc] init];
    panel.backgroundColor = [UIColor lightGrayColor];
    panel.frame = CGRectMake(self.view.center.x - 100, self.view.center.y, 250, 150);
    [self.view addSubview:panel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    CGPoint point = [[touches anyObject] locationInView:self.view];
    UIColor *color = [JKColorPicker colorOfPoint:point inView:self.view];
    self.view.backgroundColor = color;
    
}


-(void) screenShotAction
{
    UIView *view = [self.view snapshotViewAfterScreenUpdates:YES];
    
    /*
    UIGraphicsBeginImageContext(view.bounds.size);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image= UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    UIImageView *imgView = [[UIImageView alloc] initWithImage:image];
    imgView.frame = CGRectMake(0, 64, 100, 200);
    imgView.layer.shadowOffset = CGSizeMake(1, 1);
    imgView.layer.shadowOpacity = 1;
    [self.view addSubview:imgView];
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);*/
    
//    view.frame = CGRectMake(0, 64 , 100, 200);
    [self.view addSubview:view];
    
    
}


@end
