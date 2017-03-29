//
//  SolidViewController.m
//  TransformDemo
//
//  Created by wangk on 17/3/29.
//  Copyright © 2017年 wangk. All rights reserved.
//

#import "SolidViewController.h"
#import <QuartzCore/QuartzCore.h>
#import <GLKit/GLKit.h>

#define LIGHT_DIRECTION 0, 1, -0.5
#define AMBIENT_LIGHT 0.5


@interface SolidViewController ()
{
    UIView *_rootView;
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
    _rootView = [[UIView alloc] init];
    _rootView.layer.contentsScale = [UIScreen mainScreen].scale;
    _rootView.frame = self.view.bounds;
    [self.view addSubview:_rootView];
    int angle = 100;
//    _rootView.layer.sublayerTransform = CATransform3DIdentity;
    CATransform3D trans = CATransform3DMakeRotation(-M_PI_4, 1, 0, 0);
    _rootView.layer.sublayerTransform = CATransform3DRotate(trans, -M_PI_4, 0, 1, 0);
    //前
    [self addFaceWithParams:@[@0, @0, [NSNumber numberWithInt:angle], @0, @0, @0, @0]];
    //后
    [self addFaceWithParams:@[@0, @0, [NSNumber numberWithInt:-angle], @(M_PI), @0, @0, @0]];
    //左
    [self addFaceWithParams:@[[NSNumber numberWithInt:-angle], @0, @0, @(-M_PI_2), @0, @1, @0]];
    //右
    [self addFaceWithParams:@[[NSNumber numberWithInt:angle], @0, @0, @(M_PI_2), @0, @1, @0]];
    //上
    [self addFaceWithParams:@[@0, [NSNumber numberWithInt:-angle], @0, @(-M_PI_2), @1, @0, @0]];
    //下
    [self addFaceWithParams:@[@0, [NSNumber numberWithInt:angle], @0, @(M_PI_2), @1, @0, @0]];

    [self.view addSubview:_rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)addFaceWithParams:(NSArray*)params
{
    UIView *view = [[UIView alloc] init];
    //设置位置，和颜色等参数
    view.bounds = CGRectMake(0, 0, 100, 100);
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 100, 100);

    //根据参数对CALayer进行偏移和旋转Transform
    CATransform3D transform = CATransform3DMakeTranslation([[params objectAtIndex:0] floatValue], [[params objectAtIndex:1] floatValue], [[params objectAtIndex:2] floatValue]);
    transform = CATransform3DRotate(transform, [[params objectAtIndex:3] floatValue], [[params objectAtIndex:4] floatValue], [[params objectAtIndex:5] floatValue], [[params objectAtIndex:6] floatValue]);
    //设置transform属性并把Layer加入到主Layer中
    view.layer.transform = transform;
    UILabel *label = [[UILabel alloc] init];
    label.text = [NSString stringWithFormat:@"%d", count];
    [view addSubview:label];
    
    [self applyLightingToFace:view.layer];
    label.frame = CGRectMake(40, 40, 20, 20);
    if (count == 0) {
        view.backgroundColor = [UIColor redColor];
    }
    else if (count == 1) {
        view.backgroundColor = [UIColor orangeColor];
    }
    else if (count == 2) {
        view.backgroundColor = [UIColor yellowColor];
    }
    else if (count == 3) {
        view.backgroundColor = [UIColor greenColor];
    }
    else if (count == 4) {
        view.backgroundColor = [UIColor orangeColor];
    }
    else if (count == 5) {
        view.backgroundColor = [UIColor blueColor];
    }
    else if (count == 6) {
        view.backgroundColor = [UIColor purpleColor];
    }
    count ++;
//    [_rootLayer addSublayer:gradient];
    [_rootView addSubview:view];
}


- (void)applyLightingToFace:(CALayer *)face
{
    //add lighting layer
    CALayer *layer = [CALayer layer];
    layer.frame = face.bounds;
    [face addSublayer:layer];
    //convert the face transform to matrix
    //(GLKMatrix4 has the same structure as CATransform3D)
    //译者注：GLKMatrix4和CATransform3D内存结构一致，但坐标类型有长度区别，所以理论上应该做一次float到CGFloat的转换，感谢[@zihuyishi](https://github.com/zihuyishi)同学~
    CATransform3D transform = face.transform;
    GLKMatrix4 matrix4 = *(GLKMatrix4 *)&transform;
    GLKMatrix3 matrix3 = GLKMatrix4GetMatrix3(matrix4);
    //get face normal
    GLKVector3 normal = GLKVector3Make(0, 0, 1);
    normal = GLKMatrix3MultiplyVector3(matrix3, normal);
    normal = GLKVector3Normalize(normal);
    //get dot product with light direction
    GLKVector3 light = GLKVector3Normalize(GLKVector3Make(LIGHT_DIRECTION));
    float dotProduct = GLKVector3DotProduct(light, normal);
    //set lighting layer opacity
    CGFloat shadow = 1 + dotProduct - AMBIENT_LIGHT;
    UIColor *color = [UIColor colorWithWhite:0 alpha:shadow];
    layer.backgroundColor = color.CGColor;
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
