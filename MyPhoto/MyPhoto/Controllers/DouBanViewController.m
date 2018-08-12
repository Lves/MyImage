//
//  DouBanViewController.m
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/12.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "DouBanViewController.h"
#import "DBCollectionViewCell.h"
#import <MJRefresh/MJRefresh.h>
#import "BaseNetApi.h"
#import "NuoMiMovie.h"
@interface DouBanViewController ()
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation DouBanViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"豆瓣评分";
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"DBCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"DBCollectionViewCell"];
    
    __weak typeof(self) weakSelf = self;
    self.collectionView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [weakSelf requestDouban];
    }];
    
    [self.collectionView.mj_header beginRefreshing];
}
//豆瓣评分
- (void)requestDouban{
    __weak typeof(self) weakSelf = self;
    [BaseNetApi requestDouBanSuccessBlock:^(NSArray *array) {
        if (array.count > 0) {
            weakSelf.dataArray = array;
        }
        [weakSelf.collectionView reloadData];
        [weakSelf.collectionView.mj_header endRefreshing];
    } failure:^(NSError *error) {
        [weakSelf.collectionView.mj_header endRefreshing];
    }];
}
#pragma mark <UICollectionViewDataSource & UICollectionViewDelegate>

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake((kScreenWidth-18)/3.0, (kScreenWidth-18)/3.0*2);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsMake(0, 0, 3, 3);
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    DBCollectionViewCell *cell = (DBCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"DBCollectionViewCell" forIndexPath:indexPath];
    cell.movie = self.dataArray[indexPath.row];
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
    DoubanMovie *movie = self.dataArray[indexPath.row];
    [self pushToViewController:@"DouBanDetailViewController" storyboardName:@"Main" params:@{@"doubanId":movie.idStr}];
}



@end
