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
#import "PhoneImageModel.h"
#import "HomeCollectionViewCell.h"

@interface ViewController ()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic,strong) NSArray *dataArray;
@end

@implementation ViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;//[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    [self requestPhoneImages];
}


//-(void)requestApi{
//    //http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory
//    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
//    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
//
//    NSURL *URL = [NSURL URLWithString:@"http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=9&start=0&count=99"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
//
//    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
//        if (error) {
//            NSLog(@"Error: %@", error);
//        } else {
//            NSLog(@"%@ %@", response, responseObject);
//            NSArray *jsonArray = responseObject[@"data"];
//            NSArray *imageArray = [Image360Model mj_objectArrayWithKeyValuesArray:jsonArray];
//            self.dataArray = imageArray;
//            [self.tableView reloadData];
//        }
//    }];
//    [dataTask resume];
//}

-(void)requestPhoneImages{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSURL *URL = [NSURL URLWithString:@"http://service.picasso.adesk.com/v1/vertical/vertical?limit=30&skip=180&adult=false&first=0&order=hot"];
    NSURLRequest *request = [NSURLRequest requestWithURL:URL];
    
    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            NSLog(@"Error: %@", error);
        } else {
            NSLog(@"%@ %@", response, responseObject);
            if ([responseObject[@"msg"] isEqualToString:@"success"]) {
                NSArray *jsonArray = responseObject[@"res"][@"vertical"];
                NSArray *imageArray = [PhoneImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
                self.dataArray = imageArray;
            }else {
                self.dataArray = nil;
            }
            [self.collectionView reloadData];
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
