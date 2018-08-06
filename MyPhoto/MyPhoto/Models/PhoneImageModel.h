//
//  PhoneImageModel.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MJExtension/MJExtension.h>
@interface PhoneImageModel : NSObject
@property (nonatomic,copy) NSString *preview;
@property (nonatomic,copy) NSString *thumb;
@property (nonatomic,copy) NSString *img;
@property (nonatomic,assign) NSInteger views; //查看数
@property (nonatomic,copy) NSString *store;
@property (nonatomic,strong) NSArray *tag;
@property (nonatomic,assign) NSInteger rank;//点赞数
@property (nonatomic,assign) NSInteger favs;//收藏数
@property (nonatomic,copy) NSString *atime; //创建时间
@property (nonatomic,copy) NSString *idStr;
@end
