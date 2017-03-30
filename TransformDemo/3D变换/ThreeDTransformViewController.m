//
//  3DTransformViewController.m
//  TransformDemo
//
//  Created by wangk on 17/3/29.
//  Copyright © 2017年 wangk. All rights reserved.
//

#import "ThreeDTransformViewController.h"
#import "Masonry.h"

#define WS(weakSelf) __weak __typeof(&*self)weakSelf = self;

@interface ThreeDTransformViewController ()

@end

@implementation ThreeDTransformViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    /*
     3维空间内的平移变换及旋转变换,为什么要用4*4的矩阵来表示?
     
     为了解决三维矢量和4×4矩阵相乘的问题，我们机智的为三维矢量添加了第四个分量，这样之前的三维矢量(x,y,z)就变成了四维的(x,y,z,w)，这样由4个分量组成的矢量便被称为齐次坐标。需要说明的是，齐次坐标(x,y,z,w)等价于三维坐标(x/w,y/w,z/w)，因此只要w分量的值是1，那么这个齐次坐标就可以被当作三维坐标来使用，而且所表示的坐标就是以x，y，z这3个值为坐标值的点。
     */
    
    /* 缩放矩阵
     |Sx    0    0       0|
     |0    Sy    0       0|
     |0    0    Sz   {缩放}|
     |0    0     0       1|
     }
     // 平移矩阵   D代表各个轴的移动距离
     |1   0   0     0|
     |0   1   0     0|
     |0   0   1     0|
     |Dx  Dy  Dz    0|
     */
    
    self.view.backgroundColor = [UIColor whiteColor];

    self.title = @"3D变换";
    CGFloat angle = 60 * M_PI / 180;
    
    UIImage *image = [UIImage imageNamed:@"1"];
    // *******X轴旋转  60°******
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image.copy];
    imageView1.layer.transform = CATransform3DMakeRotation(angle, 1, 0, 0);
    [self.view addSubview:imageView1];
    
    // *****X、Y轴旋转*****
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    imageView2.layer.transform = CATransform3DMakeRotation(angle, 1, 1, 0);
    [self.view addSubview:imageView2];
    
    // *******透视***********
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"1"]];
    CATransform3D transform = CATransform3DIdentity;
    // 分母越小效果越明显
    // -1.0/D
//    transform.m34 = - 1.0 / 12.0;
//    transform.m43 = 1000;
//    transform.m41 = 30;
//    transform.m42 = 130;
    transform.m22 = 0.5;
    transform.m11 = 0.5;
    transform = CATransform3DTranslate(transform, 0, 0, -1000);
    imageView3.layer.transform = transform;
    [self.view addSubview:imageView3];
    
    // ******sublayerTransform******
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor yellowColor];
    contentView.layer.sublayerTransform = CATransform3DMakeRotation(M_PI_4, 1, 1, 0);
    [self.view addSubview:contentView];
    
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:image.copy];
    [contentView addSubview:imageView4];
    
    /*
     绕坐标轴旋转的公式：
     
     （1）绕Z轴旋转
     |cosA   sinA   0    0|
     |-sinA  coasA  0    0|
     |0       0     1    0|
     |0       0     0    1|
     
     （2）绕X轴旋转
     
     |1   0     0      0|
     |0  cosA  sinA    0|
     |0 -sinA  cosA    0|
     |0   0     0      1|
     
     （3）绕Y轴旋转
     
     |cosA   0   -sinA  0|
     |-sinA  1     0    0|
     |sinA   0   cosA   0|
     |0      0     0    1|
     
     */
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:image.copy];;
    CATransform3D trans = CATransform3DIdentity;
    trans.m22 = 0.5;
    trans.m23 = 0.866;
    trans.m33 = 0.5;
    trans.m32 = -0.866;
    imageView5.layer.transform = trans;
    [self.view addSubview:imageView5];
    
    // *****Y轴旋转180度*****
    UIImageView *imageView6 = [[UIImageView alloc] initWithImage:image];
    imageView6.layer.transform = CATransform3DMakeRotation(M_PI, 0, 1, 0);
//    imageView6.layer.doubleSided = false;
    [self.view addSubview:imageView6];
    
    WS(ws)
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.top.equalTo(ws.view.mas_top).offset(50);
    }];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_right).offset(5);
        make.top.equalTo(imageView1.mas_top);
    }];
    
//    imageView3.frame = CGRectMake(50, 300, 50, 100);
    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_left);
        make.top.equalTo(imageView1.mas_bottom).offset(20);
    }];
    
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_left);
        make.top.equalTo(imageView2.mas_bottom).offset(20);
        make.width.equalTo(@150);
        make.height.equalTo(@150);
    }];
    
    [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(contentView.mas_centerX);
        make.centerY.equalTo(contentView.mas_centerY);
    }];
    
    [imageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.top.equalTo(imageView3.mas_bottom).offset(20);
    }];
    
    [imageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_left);
        make.top.equalTo(contentView.mas_bottom).offset(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
