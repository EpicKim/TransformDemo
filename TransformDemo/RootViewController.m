//
//  RootViewController.m
//  TransformDemo
//
//  Created by wangk on 17/3/29.
//  Copyright © 2017年 wangk. All rights reserved.
//

#import "RootViewController.h"
#import "Masonry.h"
#import "AffineViewController.h"
#import "ThreeDTransformViewController.h"
#import "SolidViewController.h"

#define WS(weakSelf)                    __weak __typeof(&*self)weakSelf = self;

@interface RootViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation RootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UITableView *tableView = [[UITableView alloc] init];
    tableView.delegate = self;
    tableView.dataSource = self;
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    [self.view addSubview:tableView];
    
    WS(ws)
    [tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(ws.view.mas_left);
        make.top.equalTo(ws.view.mas_top);
        make.right.equalTo(ws.view.mas_right);
        make.bottom.equalTo(ws.view.mas_bottom);
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - TableView Delegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if(indexPath.row == 0) {
        cell.textLabel.text = @"仿射变换";
    }
    else if(indexPath.row == 1) {
        cell.textLabel.text = @"3D变换";
    }
    else if(indexPath.row == 2) {
        cell.textLabel.text = @"固体对象";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if(indexPath.row == 0) {
        [self.navigationController pushViewController:[[AffineViewController alloc] init] animated:true];
    }
    else if(indexPath.row == 1) {
        [self.navigationController pushViewController:[[ThreeDTransformViewController alloc] init] animated:true];
    }
    else if(indexPath.row == 2) {
        [self.navigationController pushViewController:[[SolidViewController alloc] init] animated:true];
    }
}


@end
