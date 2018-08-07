//
//  MyViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "MyViewController.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MyViewController
@synthesize dataArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.tableView.tableFooterView = [UIView new];
    dataArray = @[@"我的收藏",@"意见反馈",@"清理缓存"];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyTableViewCell"];
    }
    cell.textLabel.text = dataArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}

@end
