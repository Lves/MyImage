//
//  CategoryViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "CategoryViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "PhoneImageModel.h"
#import "HomeCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>

@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
static NSInteger kStep = 20;
@implementation CategoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = self.name;
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;//[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestPhoneImages];
    }];

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMore];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
}
-(void)requestPhoneImages{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/vertical/category/%@/vertical?limit=%lu&adult=false&first=0&order=new",self.categoryId,kStep];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"success"]) {
                NSArray *jsonArray = responseObject[@"res"][@"vertical"];
                NSArray *imageArray = [PhoneImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
                weakSelf.dataArray = [imageArray mutableCopy];
            }else {
                weakSelf.dataArray = nil;
            }
            [weakSelf.collectionView reloadData];
        }
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
    [dataTask resume];
}
- (void)requestMore{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/vertical/category/%@/vertical?limit=%lu&adult=false&first=1&skip=%lu&order=new",self.categoryId, kStep, self.dataArray.count];
    NSURL *URL = [NSURL URLWithString:urlStr];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    __weak typeof(self) weakSelf = self;
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
            [weakSelf.collectionView.mj_footer endRefreshing];
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"success"]) {
                NSArray *jsonArray = responseObject[@"res"][@"vertical"];
                NSArray *imageArray = [PhoneImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
                if (imageArray.count == 0) {
                    [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
                }else {
                    [weakSelf.dataArray addObjectsFromArray:imageArray];
                    [weakSelf.collectionView reloadData];
                    [weakSelf.collectionView.mj_footer endRefreshing];
                }
            }else {
                [weakSelf.collectionView.mj_footer endRefreshing];
            }
        }
        
    }];
    [dataTask resume];
}

#pragma mark - TableView
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0*1.5);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    PhoneImageModel *phoneImage = self.dataArray[indexPath.row];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:phoneImage.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.iconImage.image = image;
    }];
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

@end
