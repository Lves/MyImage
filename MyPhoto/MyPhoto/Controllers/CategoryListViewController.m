//
//  CategoryListViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "CategoryListViewController.h"
#import <MJRefresh/MJRefresh.h>
#import <MJExtension/MJExtension.h>
#import <AFNetworking/AFNetworking.h>
#import "ImageCategory.h"
#import "CategoryTableViewCell.h"
#import "CategoryViewController.h"
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
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://service.picasso.adesk.com/v1/vertical/category?adult=false&first=1"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"success"]) {
                NSArray *jsonArray = responseObject[@"res"][@"category"];
                NSArray *imageArray = [ImageCategory mj_objectArrayWithKeyValuesArray:jsonArray];
                weakSelf.dataArray = imageArray;
            }else {
                weakSelf.dataArray = nil;
            }
            [weakSelf.tableView reloadData];
        }
        [weakSelf.tableView.mj_header endRefreshing];
    }];
    [dataTask resume];
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
