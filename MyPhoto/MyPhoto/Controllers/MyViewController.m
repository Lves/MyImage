//
//  MyViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "MyViewController.h"
#import "BoxOfficeTableViewController.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "WXApi.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource, WXApiDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation MyViewController
@synthesize dataArray;

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的";
    self.tableView.tableFooterView = [UIView new];
    dataArray = @[@[@"我的收藏",@"意见反馈",@"清理缓存",@"分享给好友"], @[@"设置"]];
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
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        NSUInteger intg = [[SDImageCache sharedImageCache] getSize];
        NSString * currentVolum = [NSString stringWithFormat:@"%@",[self fileSizeWithInterge:intg]];
        cell.textLabel.text = [NSString stringWithFormat:@"%@   %@",dataArray[indexPath.section][indexPath.row],currentVolum];
    }else {
        cell.textLabel.text = dataArray[indexPath.section][indexPath.row];
    }
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        if (indexPath.row == 2) { //清缓存
            [self cleanDisk];
        }else if (indexPath.row == 3){
            [self shareToWeChat];
        }
    }
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}
-(CGFloat) tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
-(UIView *) tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    return view;
}
#pragma mark - 微信
-(void)onResp:(BaseResp *)resp{
    NSLog(@"%@");
}
#pragma mark - private
//清理缓存
- (void)cleanDisk{
    [self showLoading];
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.tableView reloadData];
            [weakSelf showHUDText:@"清理成功" completion:nil];
        });
    });
}
//分享
- (void)shareToWeChat{
    
//    WXMediaMessage *mess = [WXMediaMessage message];
//    [mess setThumbImage:[UIImage imageNamed:@"AppIcon"]];
//
//    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
//    req.message = mess;
//    req.bText = false;
//    req.scene = WXSceneSession;
//    [WXApi sendReq:req];
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.text                = @"简单文本分享测试";
    req.bText               = YES;
    req.scene               = WXSceneSession;
    [WXApi sendReq:req];
}

//计算出大小
- (NSString *)fileSizeWithInterge:(NSInteger)size{
    // 1k = 1024, 1m = 1024k
    if (size < 1024) {// 小于1k
        return [NSString stringWithFormat:@"%ldB",(long)size];
    }else if (size < 1024 * 1024){// 小于1m
        CGFloat aFloat = size/1024;
        return [NSString stringWithFormat:@"%.0fK",aFloat];
    }else if (size < 1024 * 1024 * 1024){// 小于1G
        CGFloat aFloat = size/(1024 * 1024);
        return [NSString stringWithFormat:@"%.1fM",aFloat];
    }else{
        CGFloat aFloat = size/(1024*1024*1024);
        return [NSString stringWithFormat:@"%.1fG",aFloat];
    }
}

@end
