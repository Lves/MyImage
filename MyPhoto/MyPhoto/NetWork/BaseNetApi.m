//
//  BaseNetApi.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "BaseNetApi.h"
#import <AFNetworking/AFNetworking.h>
#import "PhoneImageModel.h"
#import "Image360Model.h"
#import "ImageCategory.h"
#import "SearchImageModel.h"
static NSInteger kCategoryStep = 20;

@implementation BaseNetApi


+ (void)requestWithUrl:(NSString *)url method:(NSString *)method params:(NSDictionary *)params successBlock:(NetSuccessBlock)success failure:(NetFailureBlock)failure{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:params error:nil];

    NSURLSessionDataTask *dataTask = [manager dataTaskWithRequest:request completionHandler:^(NSURLResponse *response, id responseObject, NSError *error) {
        if (error) {
            failure(error);
        } else {
            success(responseObject);
        }
    }];
    [dataTask resume];
}

//首页
+ (void)requestHome:(NSInteger)skip SuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    NSString *url = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/vertical/vertical?limit=40&skip=%lu&adult=false&first=0&order=hot",skip];
    [BaseNetApi requestWithUrl:url method:@"GET" params:nil successBlock:^(id responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            NSArray *jsonArray = responseObject[@"res"][@"vertical"];
            NSArray *imageArray = [PhoneImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
            success(imageArray);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//首页banner
+ (void)requestBannerSuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    [BaseNetApi requestWithUrl:@"http://wallpaper.apc.360.cn/index.php?c=WallPaperAndroid&a=getAppsByCategory&cid=1&start=0&count=5"
                        method:@"GET"
                        params:nil
    successBlock:^(id responseObject) {
        if ([responseObject[@"errno"] integerValue] == 0) {
            NSArray *jsonArray = responseObject[@"data"];
            NSArray *imageArray = [Image360Model mj_objectArrayWithKeyValuesArray:jsonArray];
            success(imageArray);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//分类列表

+(void) requestCategorySuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    [BaseNetApi requestWithUrl:@"http://service.picasso.adesk.com/v1/vertical/category?adult=false&first=1" method:@"GET" params:nil successBlock:^(id responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            NSArray *jsonArray = responseObject[@"res"][@"category"];
            NSArray *imageArray = [ImageCategory mj_objectArrayWithKeyValuesArray:jsonArray];
            success(imageArray);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}


//分类详情
+ (void)requestCategoryDetail:(NSString *)categoryId skip:(NSInteger) skip successBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://service.picasso.adesk.com/v1/vertical/category/%@/vertical?limit=%lu&adult=false&first=1&skip=%lu&order=new",categoryId, kCategoryStep, skip];
    [BaseNetApi requestWithUrl:urlStr method:@"GET" params:nil successBlock:^(id responseObject) {
        if ([responseObject[@"msg"] isEqualToString:@"success"]) {
            NSArray *jsonArray = responseObject[@"res"][@"vertical"];
            NSArray *imageArray = [PhoneImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
            success(imageArray);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}
//搜索
+(void) searchImages:(NSString *)keyword successBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&start=0&count=40&kw=%@&start=0",keyword];
    [BaseNetApi requestWithUrl:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] method:@"GET" params:nil successBlock:^(id responseObject) {
        if ([responseObject[@"errmsg"] isEqualToString:@"success"]) {
            NSArray *jsonArray = responseObject[@"data"];
            NSArray *imageArray = [SearchImageModel mj_objectArrayWithKeyValuesArray:jsonArray];
            success(imageArray);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}



@end
