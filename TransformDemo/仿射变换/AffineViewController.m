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
    // transform无法叠加
    UIImage *image = [UIImage imageNamed:@"1"];
    UIImageView *imageView1 = [[UIImageView alloc] initWithImage:image.copy];
    imageView1.transform = CGAffineTransformMakeRotation(45);
    [self.view addSubview:imageView1];
    
    // 缩放变换
    UIImageView *imageView2 = [[UIImageView alloc] initWithImage:image];
    imageView2.transform = CGAffineTransformMakeScale(0.3, 1);
    [self.view addSubview:imageView2];
    
    // 平移变换
    UIImageView *imageView3 = [[UIImageView alloc] initWithImage:image];
    imageView3.transform = CGAffineTransformMakeTranslation(30, 0);
    [self.view addSubview:imageView3];
    
    // 混合变换 缩放+旋转
    UIImageView *imageView4 = [[UIImageView alloc] initWithImage:image];
    CGAffineTransform transform = CGAffineTransformMakeRotation(45);
    imageView4.transform = CGAffineTransformScale(transform, 1, 0.5);
    [self.view addSubview:imageView4];
    
    // 混合变换 平移+旋转+缩放
    UIImageView *imageView5 = [[UIImageView alloc] initWithImage:image];
    CGAffineTransform scale = CGAffineTransformScale(transform, 0.5, 0.5);
    CGAffineTransform trans = CGAffineTransformMakeTranslation(30, 0);
    CGAffineTransform mix = transform = CGAffineTransformConcat(scale,trans);
    imageView5.layer.affineTransform = CGAffineTransformConcat(mix,
                                                   CGAffineTransformMakeRotation(45));
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
