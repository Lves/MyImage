//
//  CategoryListViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "CategoryListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import "ImageCategory.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"
#import "BaseNetApi.h"
@interface CategoryListViewController ()<UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation CategoryListViewController
@synthesize dataArray;
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分类";
    self.tableView.tableFooterView = [UIView new];
    __weak typeof(self) weakSelf = self;
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestCategory];
    }];
    [self.tableView.mj_header beginRefreshing];
}

-(void)requestCategory{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestCategorySuccessBlock:^(NSArray *images) {
        weakSelf.dataArray = images;
        [weakSelf.tableView reloadData];
        [weakSelf.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.tableView.mj_header endRefreshing];
    }];
}
#pragma mark - TableView Delegate & DataSource

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CategoryTableViewCell *cell = (CategoryTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CategoryTableViewCell"];
    if (cell == nil) {
        cell = [[CategoryTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"CategoryTableViewCell"];
    }
    ImageCategory *cat = dataArray[indexPath.row];
    cell.imageCategory = cat;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CategoryViewController *controller = [sb instantiateViewControllerWithIdentifier:@"CategoryViewController"];
    controller.hidesBottomBarWhenPushed = true;
    ImageCategory *cat = dataArray[indexPath.row];
    controller.categoryId = cat.idStr;
    controller.name = cat.name;
    [self.navigationController pushViewController:controller animated:true];
    
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}


@end
