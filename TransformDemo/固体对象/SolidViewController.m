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
    count = 1;
    //创建主Layer
    _rootView = [[UIView alloc] init];
    CATransform3D perspective = CATransform3DIdentity;
    perspective.m34 = -1.0 / 500.0;
    perspective = CATransform3DRotate(perspective, -M_PI_4, 1, 0, 0);
    perspective = CATransform3DRotate(perspective, -M_PI_4, 0, 1, 0);
    _rootView.layer.sublayerTransform = perspective;
    [self.view addSubview:_rootView];

    CATransform3D trans = CATransform3DMakeRotation(-M_PI_4, 1, 0, 0);
    _rootView.layer.sublayerTransform = CATransform3DRotate(trans, -M_PI_4, 0, 1, 0);
    //前
   CATransform3D transform = CATransform3DMakeTranslation(0, 0, 100);
    [self addFace:transform].backgroundColor = [UIColor redColor];
    // 2
    transform = CATransform3DMakeTranslation(100, 0, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 0, 1, 0);
    [self addFace:transform].backgroundColor = [UIColor orangeColor];
    // 3
    transform = CATransform3DMakeTranslation(0, -100, 0);
    transform = CATransform3DRotate(transform, M_PI_2, 1, 0, 0);
    [self addFace:transform].backgroundColor = [UIColor yellowColor];
    // 4
    transform = CATransform3DMakeTranslation(0, 100, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 1, 0, 0);
    [self addFace:transform].backgroundColor = [UIColor greenColor];
    // 5
    transform = CATransform3DMakeTranslation(-100, 0, 0);
    transform = CATransform3DRotate(transform, -M_PI_2, 0, 1, 0);
    [self addFace:transform].backgroundColor = [UIColor blueColor];
    // 6
    transform = CATransform3DMakeTranslation(0, 0, -100);
    transform = CATransform3DRotate(transform, M_PI, 0, 1, 0);
    [self addFace:transform].backgroundColor = [UIColor purpleColor];
    
    [self.view addSubview:_rootView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIView *)addFace:(CATransform3D)transform
{
    UIView *view = [[UIView alloc] init];
    //设置位置，和颜色等参数
    view.bounds = CGRectMake(0, 0, 200, 200);
    view.backgroundColor = [UIColor whiteColor];
    view.frame = CGRectMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds), 200, 200);
    
    view.layer.transform = transform;
    
    //设置transform属性并把Layer加入到主Layer中
    view.layer.transform = transform;
    UILabel *label = [[UILabel alloc] init];
    label.font = [UIFont systemFontOfSize:30];
    label.text = [NSString stringWithFormat:@"%d", count];
    [view addSubview:label];
    
    [self applyLightingToFace:view.layer];
    label.frame = CGRectMake(80, 80, 20, 20);

    count ++;
    [_rootView addSubview:view];
    return view;
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
