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
#import "HomeFunctionCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "HomeCollectionReusableView.h"
#import "SearchViewController.h"
#import "CategoryViewController.h"
#import "BaseNetApi.h"
#import "FunctionModel.h"
#import <HUPhotoBrowser/HUPhotoBrowser.h>
#import "NSArray+ImageModel.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,HColleReusableViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSMutableArray *dataArray;
@property (nonatomic,strong) NSArray *topBannerArray;
@property (nonatomic, strong) NSArray *functionArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"首页";
    [self naviBar];
    self.functionArray = @[[FunctionModel instanceWithTitle:@"最新" imageName:@"function_new_images" address:@"CategoryViewController"],
                           [FunctionModel instanceWithTitle:@"豆瓣评分" imageName:@"function_douban" address:@"DouBanViewController"],
                           [FunctionModel instanceWithTitle:@"票房排行榜" imageName:@"function_ranking_list" address:@"BoxOfficeTableViewController"],
                           [FunctionModel instanceWithTitle:@"其他" imageName:@"function_others" address:@""]];
    //banner
    [self requestBanner];
    
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;//[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeFunctionCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeFunctionCollectionViewCell"];
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
    [BaseNetApi requestImages:@"favs" skip:0 successBlock:^(NSArray *images) {
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
    [BaseNetApi requestImages:@"favs" skip:skip successBlock:^(NSArray *images) {
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
        return  CGSizeMake(kScreenWidth/4.0, 90);
    }
    return CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0*1.5);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        HomeFunctionCollectionViewCell *cell = (HomeFunctionCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeFunctionCollectionViewCell" forIndexPath:indexPath];
        FunctionModel *model = self.functionArray[indexPath.row];
        cell.lblTitle.text = model.title;
        cell.icon.image = [UIImage imageNamed:model.imageName];
        return cell;
    }else{
        HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
        PhoneImageModel *phoneImage = self.dataArray[indexPath.row];
        [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:phoneImage.thumb] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            cell.iconImage.image = image;
        }];
         return cell;
    }
   
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    if (indexPath.section == 0) {
        FunctionModel *model = self.functionArray[indexPath.row];
        if (model.address.length > 0) {
            if ([model.address isEqualToString:@"CategoryViewController"]) {
                CategoryViewController *catController = (CategoryViewController *)[UIViewController instanceViewController:@"CategoryViewController" storyboardName:@"Main" params:@{@"name":@"最新"}];
                catController.viewType = ViewTypeHot;
                [self.navigationController pushViewController:catController animated:true];
                return;
            }
            [self pushToViewController:model.address storyboardName:@"Main" params:nil];
        }
    }else if (indexPath.section == 1){
        HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        [HUPhotoBrowser showFromImageView:cell.iconImage withURLStrings:[self.dataArray getPhoneImageModelProperty] placeholderImage:[UIImage imageNamed:@"common_placeholder"] atIndex:indexPath.row dismiss:nil];
    }
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return section == 0 ? 4 : self.dataArray.count;
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
    header.delegate = self;
    header.dataArray = self.topBannerArray;
    return header;
}
#pragma mark HColleReusableViewDelegate
-(void)pagerView:(FSPagerView *)pagerView cell:(FSPagerViewCell *)cell didSelectItemAtIndex:(NSInteger)index{
   
    [HUPhotoBrowser showFromImageView:cell.imageView withURLStrings:[self.topBannerArray getImage360ModelProperty] placeholderImage:[UIImage imageNamed:@"common_placeholder"] atIndex:index dismiss:nil];
}
    

@end
