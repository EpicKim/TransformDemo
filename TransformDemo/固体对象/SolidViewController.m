//
//  SolidViewController.m
//  TransformDemo
//
//  Created by wangk on 17/3/29.
//  Copyright © 2017年 wangk. All rights reserved.
//

#import "SolidViewController.h"

@interface SolidViewController ()
{
    CALayer *_rootLayer;
    int count;
}
@end

@implementation SolidViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.title = @"固体对象";
    count = 0;
    //创建主Layer
    _rootLayer = [CALayer layer];
    _rootLayer.contentsScale = [UIScreen mainScreen].scale;
    _rootLayer.frame = self.view.bounds;
    
    int angle = 45;
    //前
    [self addLayer:@[@0, @0, [NSNumber numberWithInt:angle], @0, @0, @0, @0]];
    //后
    [self addLayer:@[@0, @0, [NSNumber numberWithInt:-angle], @(M_PI), @0, @0, @0]];
    //左
    [self addLayer:@[[NSNumber numberWithInt:-angle], @0, @0, @(-M_PI_2), @0, @1, @0]];
    //右
    [self addLayer:@[[NSNumber numberWithInt:angle], @0, @0, @(M_PI_2), @0, @1, @0]];
    //上
    [self addLayer:@[@0, [NSNumber numberWithInt:-angle], @0, @(-M_PI_2), @1, @0, @0]];
    //下
    [self addLayer:@[@0, [NSNumber numberWithInt:angle], @0, @(M_PI_2), @1, @0, @0]];
    
    //主Layer的3D变换
    CATransform3D transform = CATransform3DIdentity;
    transform.m34 = -1.0 / 700;
    //在X轴上做一个20度的小旋转
    transform = CATransform3DRotate(transform, M_PI / 9, 1, 0, 0);
    //设置CALayer的sublayerTransform
    _rootLayer.sublayerTransform = transform;
    //添加Layer
    [self.view.layer addSublayer:_rootLayer];
    
    _rootLayer.sublayerTransform = CATransform3DIdentity;
    CATransform3D trans = CATransform3DMakeRotation(-M_PI_4, 1, 0, 0);
    _rootLayer.sublayerTransform = CATransform3DRotate(trans, -M_PI_4, 0, 1, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addLayer:(NSArray*)params
{
    //创建支持渐变背景的CAGradientLayer
    CAGradientLayer *gradient = [CAGradientLayer layer];
    //设置位置，和颜色等参数
    gradient.contentsScale = [UIScreen mainScreen].scale;
    gradient.bounds = CGRectMake(0, 0, 100, 100);
    gradient.position = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
//    gradient.colors = @[(id)[UIColor grayColor].CGColor, (id)[UIColor blackColor].CGColor];
    gradient.backgroundColor = [UIColor yellowColor].CGColor;
    gradient.locations = @[@0, @1];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(0, 1);
    
    //根据参数对CALayer进行偏移和旋转Transform
    CATransform3D transform = CATransform3DMakeTranslation([[params objectAtIndex:0] floatValue], [[params objectAtIndex:1] floatValue], [[params objectAtIndex:2] floatValue]);
    transform = CATransform3DRotate(transform, [[params objectAtIndex:3] floatValue], [[params objectAtIndex:4] floatValue], [[params objectAtIndex:5] floatValue], [[params objectAtIndex:6] floatValue]);
    //设置transform属性并把Layer加入到主Layer中
    gradient.transform = transform;
    if (count == 0) {
        gradient.backgroundColor = [UIColor redColor].CGColor;
    }
    else if (count == 1) {
        gradient.backgroundColor = [UIColor orangeColor].CGColor;
    }
    else if (count == 2) {
        gradient.backgroundColor = [UIColor yellowColor].CGColor;
    }
    else if (count == 3) {
        gradient.backgroundColor = [UIColor greenColor].CGColor;
    }
    else if (count == 4) {
        gradient.backgroundColor = [UIColor orangeColor].CGColor;
    }
    else if (count == 5) {
        gradient.backgroundColor = [UIColor blueColor].CGColor;
    }
    else if (count == 6) {
        gradient.backgroundColor = [UIColor purpleColor].CGColor;
    }
    count ++;
    [_rootLayer addSublayer:gradient];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
