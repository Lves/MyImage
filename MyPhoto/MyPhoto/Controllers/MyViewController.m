//
//  MyViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "MyViewController.h"
#import "BoxOfficeTableViewController.h"

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
    dataArray = @[@[@"我的收藏",@"意见反馈",@"清理缓存"], @[@"电影票房"]];
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return dataArray.count;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [dataArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyTableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"MyTableViewCell"];
    }
    cell.textLabel.text = dataArray[indexPath.section][indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            [self pushToViewController:@"BoxOfficeTableViewController" storyboardName:@"Main" params:nil];
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 50;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

@end
