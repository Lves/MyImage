//
//  SearchImageModel.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SearchImageModel : NSObject
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *class_id;
@property (nonatomic,copy) NSString *resolution;
@property (nonatomic,copy) NSString *url_mobile;
@property (nonatomic,copy) NSString *url;
@property (nonatomic,copy) NSString *url_thumb;
@property (nonatomic,copy) NSString *url_mid;
@property (nonatomic,copy) NSString *download_times;
@property (nonatomic,assign) NSInteger imgcut;
@property (nonatomic,copy) NSString *tag;
@property (nonatomic,copy) NSString *create_time;
@property (nonatomic,copy) NSString *update_time;
@property (nonatomic,copy) NSString *utag;
@property (nonatomic,copy) NSString *tempdata;
@property (nonatomic,strong) NSArray *rdata;
@end
