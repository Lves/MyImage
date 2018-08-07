//
//  SearchViewController.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "SearchViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import <MJExtension/MJExtension.h>
#import "HomeCollectionViewCell.h"
#import "SearchImageModel.h"
@interface SearchViewController ()<UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic,strong) NSArray *dataArray;

@end

@implementation SearchViewController
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (!_searchBar.isFirstResponder) {
        [self.searchBar becomeFirstResponder];
    }
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.searchBar resignFirstResponder];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"搜索";
    [self setCollectionView];
    //隐藏导航栏上的返回按钮
    [self.navigationItem setHidesBackButton:YES];
    [self setSearchBar];
}
- (void)setCollectionView{
    UICollectionViewFlowLayout *flowLayout = (UICollectionViewFlowLayout *)self.collectionView.collectionViewLayout;//[UICollectionViewFlowLayout new];
    flowLayout.minimumLineSpacing = 0;
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
    [self.collectionView registerNib:[UINib nibWithNibName:@"HomeCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"HomeCollectionViewCell"];
    
}

- (void)searchImages:(NSString *)keyWord{
    if (keyWord.length > 0) {
        NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
        
        NSString *urlStr = [NSString stringWithFormat:@"http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&start=0&count=40&kw=%@&start=0",keyWord];
        NSURL *URL = [NSURL URLWithString:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        NSURLRequest *request = [NSURLRequest requestWithURL:URL];
        
        __weak typeof(self) weakSelf = self;
        NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
            if (error) {
                NSLog(@"Error: %@", error);
            } else {
                NSLog(@"%@ %@", response, responseObject);
                if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
                    NSArray *jsonArray = responseObject[@"data"];
                    NSArray *imageArray = [SearchImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
                    weakSelf.dataArray = imageArray;
                }else {
                    weakSelf.dataArray = nil;
                }
                [weakSelf.collectionView reloadData];
            }
        }];
        [dataTask resume];
    }else {
        
    }
}


- (void)setSearchBar{
    //用来放searchBar的View
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(5, 7, self.view.frame.size.width, 30)];
    //创建searchBar
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(titleView.frame) - 15, 30)];
    //默认提示文字
    searchBar.placeholder = @"搜索内容";
    //背景图片
    //    searchBar.backgroundImage = [UIImage imageNamed:@"clearImage"];
    //代理
    searchBar.delegate = self;
    //显示右侧取消按钮
    searchBar.showsCancelButton = YES;
    
    //光标颜色
    //    searchBar.tintColor = HEXCOLOR(0x595959);
    //拿到searchBar的输入框
    UITextField *searchTextField = [searchBar valueForKey:@"_searchField"];
    //字体大小
    searchTextField.font = [UIFont systemFontOfSize:15];
    //输入框背景颜色
    //    searchTextField.backgroundColor = [UIColor colorWithRed:234/255.0 green:235/255.0 blue:237/255.0 alpha:1];
    //拿到取消按钮
    UIButton *cancleBtn = [searchBar valueForKey:@"cancelButton"];
    //设置按钮上的文字
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    //设置按钮上文字的颜色
    //    [cancleBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [titleView addSubview:searchBar];
    self.searchBar = searchBar;
    self.navigationItem.titleView = titleView;
}

#pragma mark - UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    return YES;
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    searchBar.showsCancelButton = YES;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self searchImages:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
     [self.searchBar resignFirstResponder];
     [self.navigationController popViewControllerAnimated:YES];
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    searchBar.showsCancelButton = YES;
}
- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
}

#pragma mark - CollectionView Delegare
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(kScreenWidth/2.0, kScreenWidth/2.0*0.85);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section{
    return UIEdgeInsetsZero;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HomeCollectionViewCell *cell = (HomeCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"HomeCollectionViewCell" forIndexPath:indexPath];
    SearchImageModel *phoneImage = self.dataArray[indexPath.row];
    [cell.iconImage sd_setImageWithURL:[NSURL URLWithString:phoneImage.url] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
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
