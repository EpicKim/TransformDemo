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
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image];
    CATransform3D transform = CATransform3DIdentity;
    // 分母越小效果越明显
    /* 最终变换矩阵
     |1    0    0       0|   |1   0   0       0|
     |0    1    0       0|   |0   1   0       0|
     |0    0    0   {缩放}| * |0   0   1       0|
     |0    0    0       1|   |0   0 -{偏移量}  0|
     }
     */
    // -1.0/D
    transform.m34 = - 1.0 / 12.0;
    transform = CATransform3DTranslate(transform, 0, 0, -10);
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
    
    imageView3.frame = CGRectMake(50, 300, 50, 100);
    
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
