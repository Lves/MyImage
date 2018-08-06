//
//  CategoryTableViewCell.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ImageCategory;
@interface CategoryTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (nonatomic,strong) ImageCategory *imageCategory;
@end
