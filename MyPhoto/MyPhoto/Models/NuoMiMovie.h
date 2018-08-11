//
//  NuoMiMovie.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DBRating;
@class DBImage;
///百度糯米
@interface NuoMiMovie : NSObject
@property(nonatomic,copy) NSString *movieId;
@property(nonatomic,copy) NSString *movieName;
@property(nonatomic,strong) NSDictionary *attribute;
@end
///豆瓣
@interface DoubanMovie: NSObject
@property(nonatomic,copy) NSString *title;
@property(nonatomic,strong) NSArray *duration; //电影时长
@property(nonatomic,copy) NSString *mainland_pubdate;//大陆上映时间
@property(nonatomic,assign) Boolean has_video;//是否有资源
@property(nonatomic,copy) NSString *alt;//网页链接
@property(nonatomic,copy) NSString *idStr;
@property(nonatomic,strong) DBImage *images;
@property(nonatomic, strong) DBRating *rating;
@property (nonatomic, strong) NSArray *genres; //电影分类
@end
///豆瓣图片
@interface DBImage:NSObject
@property(nonatomic,copy) NSString *large;
@property(nonatomic,copy) NSString *medium;
@property(nonatomic,copy) NSString *small;
@end
///排名信息
@interface DBRating:NSObject
@property(nonatomic,copy) NSString *max;
@property(nonatomic,copy) NSString *average;
@property(nonatomic,copy) NSString *min;
@end
