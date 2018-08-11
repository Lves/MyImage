//
//  BoxOfficeTableViewCell.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NuoMiMovie.h"
@interface BoxOfficeTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblMovieName;
@property (weak, nonatomic) IBOutlet UILabel *lblDetail;
@property (weak, nonatomic) IBOutlet UILabel *lblPFPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblPPPercent;
@property (weak, nonatomic) IBOutlet UILabel *lblPrice;
@property (nonatomic,strong) NuoMiMovie *movie;
@end
