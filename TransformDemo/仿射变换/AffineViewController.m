//
//  ViewController.m
//  TransformDemo
//
//  Created by wangk on 17/3/29.
//  Copyright © 2017年 wangk. All rights reserved.
//

#import "AffineViewController.h"
#import "Masonry.h"

#define WS(weakSelf)                    __weak __typeof(&*self)weakSelf = self;
#define MAS_SHORTHAND

@interface AffineViewController ()

@end

@implementation AffineViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.title = @"仿射变换";
    self.view.backgroundColor = [UIColor whiteColor];
    /*
     CGAffineTransform存储了一个变换矩阵
     | a,  b,  0 |
     | c,  d,  0 |
     | tx, ty, 1 |
     */
    // ***************旋转变换*****************
    /*
     设某点与原点连线和X轴夹角为b度，以原点为圆心，逆时针转过a度  , 原点与该点连线长度为R, [x,y]为变换前坐标， [X,Y]为变换后坐标。
     x = Rcos(b) ; y = Rsin(b);
     X = Rcos(a+b) = Rcosacosb - Rsinasinb = xcosa - ysina; (合角公式)
     Y = Rsin(a+b) = Rsinacosb + Rcosasinb = xsina + ycosa ;
     
     用矩阵表示：
     cosA   sinA  0
     [X, Y, 1] = [x, y, 1][-sinA  cosA  0  ]
     |0        0     1|
     |cosA   sina    0|
     |-sinA  cosA    0|  为旋转变换矩阵。
     |0       0      1|
     */
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image.copy];
    imageView1.transform = CGAffineTransformMakeRotation(M_PI_2);
    [self.view addSubview:imageView1];
    
    // ***************缩放变换*****************
    /*
     缩放
     设某点坐标，在x轴方向扩大 sx倍，y轴方向扩大 sy倍，[x,y]为变换前坐标， [X,Y]为变换后坐标。
     X = Sx*x; Y = Sy*y;
     则用矩阵表示：
     sx    0    0
     [X, Y, 1] = [x, y, 1][ 0    sy    0  ] ;
     |0     0     1|
     |Sx    0     0|
     |0    Sy     0|  即为缩放矩阵。
     |0     0     1|
     */
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    imageView2.transform = CGAffineTransformMakeScale(0.3, 0.3);
    [self.view addSubview:imageView2];
    
    // ***************平移变换*****************
    /*
     平移：
     设某点向x方向移动 dx, y方向移动 dy ,[x,y]为变换前坐标， [X,Y]为变换后坐标。
     则 X = x+dx;  Y = y+dy;
     以矩阵表示：
     1    0    0
     [X, Y, 1] = [x, y, 1][ 0    1    0  ] ;
     |dx   dy   1|
     |1    0    0|
     |0    1    0|   即平移变换矩阵。
     |dx   dy   1|
     */
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image];
    imageView3.transform = CGAffineTransformMakeTranslation(30, 0);
    [self.view addSubview:imageView3];
    
    /*
     2D基本的模型视图变换，就只有上面这3种，所有的复杂2D模型视图变换，都可以分解成上述3个。
     比如某个变换，先经过平移，对应平移矩阵A， 再旋转, 对应旋转矩阵B，再经过缩放，对应缩放矩阵C.
     则最终变换矩阵 T = ABC. 即3个矩阵按变换先后顺序依次相乘(矩阵乘法不满足交换律，因此先后顺序一定要讲究)。
     */
    
    // 混合变换 缩放+旋转
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:image];
    CGAffineTransform transform = CGAffineTransformMakeRotation(M_PI_2);
    imageView4.transform = CGAffineTransformScale(transform, 1, 0.5);
    [self.view addSubview:imageView4];
    // 混合变换 缩放+旋转 (对照组)
    UIImageView *imageView6 = [[UIImageView alloc] initWithImage:image];
    CGAffineTransform tmp = CGAffineTransformIdentity;
    tmp = CGAffineTransformScale(transform, 1, 0.5);
    tmp = CGAffineTransformRotate(transform, M_PI_2);
    imageView6.transform = tmp;
    [self.view addSubview:imageView6];
    
    // 混合变换 平移+旋转+缩放
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:image];
    CGAffineTransform mix = CGAffineTransformIdentity;
    mix = CGAffineTransformScale(transform, 1, 0.5);
    mix = CGAffineTransformRotate(transform, M_PI_2);
    mix = CGAffineTransformTranslate(transform, 130, 0);
    imageView5.transform = mix;
    [self.view addSubview:imageView5];
    
    WS(ws)
    [imageView1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.top.equalTo(ws.view.mas_top).offset(50);
    }];
    
    [imageView2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_right).offset(5);
        make.top.equalTo(imageView1.mas_top);
    }];

    [imageView3 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_left);
        make.top.equalTo(imageView1.mas_bottom).offset(20);
    }];
    
    [imageView4 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView2.mas_left);
        make.top.equalTo(imageView2.mas_bottom).offset(20);
    }];
    
    [imageView5 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView1.mas_left);
        make.top.equalTo(imageView3.mas_bottom).offset(20);
    }];
    
    [imageView6 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(imageView4.mas_left);
        make.top.equalTo(imageView4.mas_bottom).offset(20);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
