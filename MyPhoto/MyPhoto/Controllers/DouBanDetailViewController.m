//
//  DouBanDetailViewController.m
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/12.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "DouBanDetailViewController.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "DBTrailerCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BaseNetApi.h"
#import "NuoMiMovie.h"

@interface DouBanDetailViewController ()
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation DouBanDetailViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"预告片";
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DBTrailerCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DBTrailerCollectionViewCell"];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDetail:weakSelf.doubanId];
    }];
    [self.collectionView.mj_header beginRefreshing];
}

//豆瓣详情
- (void)requestDetail:(NSString *)idStr{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestDBMovie:idStr successBlock:^(id responseObject) {
        DBMovieDetail *detail = (DBMovieDetail *)responseObject;
        self.dataArray = detail.trailers;
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}

#pragma mark <UICollectionViewDataSource & UICollectionViewDelegate>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth, kScreenWidth*217/383.0+50);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBTrailerCollectionViewCell *cell = (DBTrailerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DBTrailerCollectionViewCell" forIndexPath:indexPath];
    DBTrailer *trailer = self.dataArray[indexPath.row];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:trailer.medium] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.iconImageView.image = image;
    }];
    cell.lblTitle.text = trailer.title;
    return cell;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [collectionView deselectItemAtIndexPath:indexPath animated:true];
    DBTrailer *trailer = self.dataArray[indexPath.row];
    [self pushToViewController:@"WebViewController" storyboardName:@"Main" params:@{@"sourceUrl":trailer.resource_url ,@"titleName": trailer.title}];
}


@end
