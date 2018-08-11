//
//  ViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/3.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "ViewController.h"

#import <SDWebImage/UIImageView+WebCache.h>
#import "Image360Model.h"
#import "PhoneImageModel.h"
#import "HomeCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeCollectionReusableView.h"
#import "SearchViewController.h"
#import "BaseNetApi.h"
@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *topBannerArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self naviBar];
    //banner
    [self requestBanner];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;//[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionReusableView" bundle:nil] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionReusableView"];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestPhoneImages];
    }];
    self.collectionView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [weakSelf requestMorePhoneImages:weakSelf.dataArray.count];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

- (void)naviBar{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"搜索" style:UIBarButtonItemStylePlain target:self action:@selector(search)];
}
-(void)search{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SearchViewController *controller = [sb instantiateViewControllerWithIdentifier:@"SearchViewController"];
    controller.hidesBottomBarWhenPushed = true;
    [self.navigationController pushViewController:controller animated:true];
}

- (void)requestDouban{
    [BaseNetApi requestDouBanSuccessBlock:^(NSArray *array) {
        NSLog(@"%@",array);
    } failure:^(NSError *error) {
        
    }];
}


-(void)requestBanner{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestBannerSuccessBlock:^(NSArray *images) {
        weakSelf.topBannerArray = images;
        [weakSelf.collectionView reloadData];
    } failure:^(NSError *error) {
        
    }];
}

-(void)requestPhoneImages{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestHome:0 SuccessBlock:^(NSArray *images) {
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
    [BaseNetApi requestHome:skip SuccessBlock:^(NSArray *images) {
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

#pragma mark - TableView
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return  CGSizeMake(kScreenWidth/2.0, 60);
    }
    return CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0*1.5);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    if (indexPath.section == 0) {
        
        return cell;
    }else{
        PhoneImageModel *phoneImage = self.dataArray[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:phoneImage.img] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            cell.iconImage.image = image;
        }];
    }
    return cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? 2 : self.dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 2;
}
#pragma mark ColloectionHeader
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return CGSizeMake(kScreenWidth, 230);
    }
    return CGSizeZero;
}
-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionReusableView *header = (HomeCollectionReusableView *)[collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"HomeCollectionReusableView" forIndexPath:indexPath];
    header.dataArray = self.topBannerArray;
    return header;
}

@end
