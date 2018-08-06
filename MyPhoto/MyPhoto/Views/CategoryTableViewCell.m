//
//  CategoryTableViewCell.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "CategoryTableViewCell.h"
#import "ImageCategory.h"
#import <SDWebImage/UIImageView+WebCache.h>
@implementation CategoryTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (void)setImageCategory:(ImageCategory *)imageCategory{
    _imageCategory = imageCategory;
    
    [self.iconImageView sd_setImageWithURL:[NSURL URLWithString:imageCategory.cover] completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
        self.iconImageView.image = image;
    }];
    self.lblTitle.text = imageCategory.name;
    
}

@end
