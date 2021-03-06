//
//  CategoryViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "CategoryViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "PhoneImageModel.h"
#import "HomeCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BaseNetApi.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "NSArray+ImageModel.h"
@interface CategoryViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;

@end
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
        if (weakSelf.viewType == ViewTypeCategory) {
            [weakSelf requestCategoryPhoneImages];
        }else if (weakSelf.viewType == ViewTypeHot){
            [weakSelf requestPhoneImages];
        }
        
    }];

    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        if (weakSelf.viewType == ViewTypeCategory) {
            [weakSelf requestCategoryMore];
        }else if (weakSelf.viewType == ViewTypeHot){
            [weakSelf requestMorePhoneImages:weakSelf.dataArray.count];
        }
    }];
    
    [self.collectionView.mj_header beginRefreshing];
    
}
//分类
-(void)requestCategoryPhoneImages{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestCategoryDetail:self.categoryId skip:0 successBlock:^(NSArray *images) {
        if (images.count > 0) {
            weakSelf.dataArray = [images mutableCopy];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
- (void)requestCategoryMore{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestCategoryDetail:self.categoryId skip:self.dataArray.count successBlock:^(NSArray *images) {
        if (images.count > 0) {
            [weakSelf.dataArray addObjectsFromArray:images];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
         [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}
//最热
-(void)requestPhoneImages{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestImages:@"hot" skip:0 successBlock:^(NSArray *images) {
        if (images.count > 0) {
            weakSelf.dataArray = [images mutableCopy];
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
-(void)requestMorePhoneImages:(NSInteger)skip{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestImages:@"hot" skip:skip successBlock:^(NSArray *images) {
        if (images.count > 0) {
            [weakSelf.dataArray addObjectsFromArray:images];
            [weakSelf.collectionView reloadData];
            [weakSelf.collectionView.mj_footer endRefreshing];
        }else{
            [weakSelf.collectionView.mj_footer endRefreshingWithNoMoreData];
        }
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_footer endRefreshing];
    }];
}


#pragma mark - collectionView
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0*1.5);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    PhoneImageModel *phoneImage = self.dataArray[indexPath.row];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:phoneImage.img] placeholderImage:[UIImage imageNamed:@"common_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    [HUPhotoBrowser showFromImageView:cell.iconImage withURLStrings:[self.dataArray getPhoneImageModelProperty] placeholderImage:[UIImage imageNamed:@"common_placeholder"] atIndex:indexPath.row dismiss:nil];
    
}

@end
