//
//  ViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/3.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "ViewController.h"
#import <AFNetworking/AFNetworking.h>
#import "ImageTableViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "Image360Model.h"
#import <MJExtension/MJExtension.h>

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    
    [self requestApi];
    
    
    
}


-(void)requestApi{
    //http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=9&start=0&count=99"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            NSArray *jsonArray = responseObject[@"data"];
            NSArray *imageArray = [Image360Model mj_objectArrayWithKeyValuesArray:jsonArray];
            self.dataArray = imageArray;
            [self.tableView reloadData];
        }
    }];
    [dataTask resume];
}



#pragma mark - TableView


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return  100;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ImageTableViewCell *cell = (ImageTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"ImageTableViewCell"];
    if (cell == nil) {
        cell = [[ImageTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"ImageTableViewCell"];
    }
    Image360Model *imageModel = self.dataArray[indexPath.row];
    [cell.icon sd_setImageWithURL:[NSURL URLWithString:imageModel.url]];
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}


@end
