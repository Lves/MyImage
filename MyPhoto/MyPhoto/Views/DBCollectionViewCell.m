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
    
    NSString *title = [NSString stringWithFormat:@"%@ %.1f",movie.title ,movie.rating.average.floatValue];
    NSMutableAttributedString *str3 = [[NSMutableAttributedString alloc] initWithString:title];
    [str3 addAttribute:NSForegroundColorAttributeName value:HEXCOLOR(0xe09015) range:NSMakeRange(movie.title.length,title.length-movie.title.length)];
    self.lblName.attributedText = str3;
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:movie.images.small]  placeholderImage:[UIImage imageNamed:@"common_placeholder"] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.iconImageView.image = image;
    }];
}

@end
