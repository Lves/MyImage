//
//  BoxOfficeTableViewCell.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "BoxOfficeTableViewCell.h"

@implementation BoxOfficeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)setMovie:(NuoMiMovie *)movie{
    _movie = movie;
    self.lblMovieName.text = movie.movieName;
    
    NSArray *attrs = movie.attribute.allValues;
    NSString *day = @"";
    NSString *totalBoxOffice = @"";
    for (NSDictionary *dic in attrs) {//{attrName: "累计票房", attrValue: "30.60亿"}
        if ([dic[@"attrName"] isEqualToString:@"上映天数"]) {
            day = dic[@"attrValue"];
        }else if ([dic[@"attrName"] isEqualToString:@"实时票房"]) {
            totalBoxOffice = dic[@"attrValue"];
        }else if ([dic[@"attrName"] isEqualToString:@"票房占比"]) {
            self.lblPFPercent.text = [NSString stringWithFormat:@"%@%%",dic[@"attrValue"]];
        }else if ([dic[@"attrName"] isEqualToString:@"排片占比"]) {
            self.lblPPPercent.text = [NSString stringWithFormat:@"%@%%",dic[@"attrValue"]];
        }else if ([dic[@"attrName"] isEqualToString:@"平均票价"]) {
            self.lblPrice.text = [NSString stringWithFormat:@"%@元",dic[@"attrValue"]];
        }
    }
    self.lblDetail.text = [NSString stringWithFormat:@"上映%@天 %@",day,totalBoxOffice];
}

@end
