//
//  DBCollectionViewCell.m
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/12.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "DBCollectionViewCell.h"
#import <SDWebImage/UIImageView+WebCache.h>
#import "NuoMiMovie.h"
@implementation DBCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setMovie:(DoubanMovie *)movie{
    _movie = movie;
    self.lblName.text = movie.title;
    self.lblRating.text = [NSString stringWithFormat:@"%.1f",movie.rating.average.floatValue];
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:movie.images.small] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.iconImageView.image = image;
    }];
}

@end
