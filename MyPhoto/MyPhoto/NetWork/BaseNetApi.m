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
#import "NuoMiMovie.h"
static NSInteger kCategoryStep = 20;

@implementation BaseNetApi


+ (void)requestWithUrl:(NSString *)url method:(NSString *)method params:(NSDictionary *)params httpHeader:(NSDictionary *)headers successBlock:(NetSuccessBlock)success failure:(NetFailureBlock)failure{
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] requestWithMethod:method URLString:url parameters:params error:nil];
    for (NSString *key in headers) {
        [request setValue:headers[key] forHTTPHeaderField:key];
    }
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
    [BaseNetApi requestWithUrl:url method:@"GET" params:nil httpHeader:nil successBlock:^(id responseObject) {
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
                    httpHeader:nil
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
    [BaseNetApi requestWithUrl:@"http://service.picasso.adesk.com/v1/vertical/category?adult=false&first=1" method:@"GET" params:nil httpHeader:nil successBlock:^(id responseObject) {
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
    [BaseNetApi requestWithUrl:urlStr method:@"GET" params:nil httpHeader:nil successBlock:^(id responseObject) {
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
+(void) searchImages:(NSString *)keyword skip:(NSInteger)skip successBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure{
    NSString *urlStr = [NSString stringWithFormat:@"http://wallpaper.apc.360.cn/index.php?c=WallPaper&a=search&count=6&kw=%@&start=%lu",keyword,skip];
    [BaseNetApi requestWithUrl:[urlStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] method:@"GET" params:nil httpHeader:nil successBlock:^(id responseObject) {
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


#pragma mark - 票房
+(void) requestBoxOfficeSuccessBlock:(ArrayNetBlock)success failure:(NetFailureBlock)failure{
    NSString *url = @"http://dianying.nuomi.com/movie/boxrefresh";
    NSDictionary *headers = @{@"User-Agent":@"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_13_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/67.0.3396.99 Safari/537.36",
                              @"Origin":@"http://dianying.nuomi.com",
                              @"Referer":@"http://dianying.nuomi.com/movie/boxoffice"};
    
    [BaseNetApi requestWithUrl:url method:@"POST" params:nil  httpHeader:headers successBlock:^(id responseObject) {
        if ([responseObject[@"real"][@"errorMsg"] isEqualToString:@"Success"]) {
            NSArray *jsonArray = responseObject[@"real"][@"data"][@"detail"];
            NSArray *nuoMiMovieList = [NuoMiMovie mj_objectArrayWithKeyValuesArray:jsonArray];
            success(nuoMiMovieList);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}

+(void) requestDouBanSuccessBlock:(ArrayNetBlock)success failure:(NetFailureBlock)failure{
    NSString *url = @"https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=北京&start=0&count=100&client=&udid=";
    [BaseNetApi requestWithUrl:[url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] method:@"GET" params:nil  httpHeader:nil successBlock:^(id responseObject) {
        if ([responseObject[@"count"] integerValue] > 0) {
            NSArray *jsonArray = responseObject[@"subjects"];
            NSArray *doubanMovieList = [DoubanMovie mj_objectArrayWithKeyValuesArray:jsonArray];
            success(doubanMovieList);
        }else {
            failure([NSError errorWithDomain:@"数组为空" code:0 userInfo:nil]);
        }
    } failure:^(NSError *error) {
        failure(error);
    }];
}



@end
