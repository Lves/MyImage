//
//  BoxOfficeTableViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
// 电影票房

#import "BoxOfficeTableViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "BaseNetApi.h"
#import "BoxOfficeTableViewCell.h"
@interface BoxOfficeTableViewController ()
@property (strong, nonatomic) IBOutlet UIView *header;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation BoxOfficeTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"票房排行榜";
    self.tableView.tableFooterView = [UIView new];
    
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestBoxOffice];
    }];
    [self.tableView.mj_header beginRefreshing];

}

-(void)requestBoxOffice{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestBoxOfficeSuccessBlock:^(NSArray *array) {
        weakSelf.dataArray = array;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BoxOfficeTableViewCell *cell = (BoxOfficeTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"BoxOfficeTableViewCell"];
    if (cell == nil) {
        cell = [[BoxOfficeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"BoxOfficeTableViewCell"];
    }
    cell.movie = self.dataArray[indexPath.row];
    
    return cell;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 100;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return self.header;
    }
    return [UIView new];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 60;
}

@end
