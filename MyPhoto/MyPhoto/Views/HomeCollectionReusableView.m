//
//  HomeCollectionReusableView.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "HomeCollectionReusableView.h"
#import "Image360Model.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import <FSPagerView/FSPagerView-Swift.h>
@implementation HomeCollectionReusableView
@synthesize pagerView;
- (void)awakeFromNib {
    [super awakeFromNib];
    
    [pagerView registerClass:[FSPagerViewCell class] forCellWithReuseIdentifier:@"TopBannerCollectionViewCell"];
    pagerView.itemSize = CGSizeZero;
    pagerView.isInfinite = true;
    pagerView.delegate = self;
    pagerView.dataSource = self;
    CGAffineTransform transform = CGAffineTransformMakeScale(0.84, 1.7);
    pagerView.itemSize =  CGSizeApplyAffineTransform(pagerView.frame.size, transform);
    pagerView.transformer = [[FSPagerViewTransformer alloc] initWithType:FSPagerViewTransformerTypeOverlap];
    pagerView.automaticSlidingInterval = 4;
}

#pragma mark
-(void)setDataArray:(NSArray *)dataArray{
    _dataArray = dataArray;
    pagerView.isInfinite = true;
}



#pragma mark - delegate&datasource

- (NSInteger)numberOfItemsInPagerView:(FSPagerView * _Nonnull)pagerView {
    return self.dataArray.count;
}

- (FSPagerViewCell * _Nonnull)pagerView:(FSPagerView * _Nonnull)pagerView cellForItemAtIndex:(NSInteger)index {
    FSPagerViewCell *cell = [pagerView dequeueReusableCellWithReuseIdentifier:@"TopBannerCollectionViewCell" atIndex:index];
    Image360Model *image360 = (Image360Model *)[self.dataArray objectAtIndex:index];
    [cell.imageView sd_setImageWithURL:[NSURL URLWithString:image360.url] placeholderImage:[UIImage imageNamed:@"common_item_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        cell.imageView.image = image;
    }];
    return cell;
}

-(void)pagerView:(FSPagerView *)pagerView didSelectItemAtIndex:(NSInteger)index{
    [pagerView deselectItemAtIndex:index animated:true];
    
    FSPagerViewCell *cell = [self pagerView:pagerView cellForItemAtIndex:index];
    if (self.delegate && [self.delegate respondsToSelector:@selector(pagerView:cell:didSelectItemAtIndex:)]){
        [self.delegate pagerView:pagerView cell:cell didSelectItemAtIndex:index];
    }
}
@end
