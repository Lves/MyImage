//
//  BaseNetApi.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/7.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NetSuccessBlock)(id responseObject);
typedef void(^NetFailureBlock)(NSError *error);
typedef void(^HomeNetBlock)(NSArray *images);
typedef void(^ArrayNetBlock)(NSArray *array);
@interface BaseNetApi : NSObject
+ (void)requestHome:(NSInteger)skip SuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
+ (void)requestBannerSuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
+ (void)requestCategoryDetail:(NSString *)categoryId skip:(NSInteger) skip successBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
+ (void)requestCategorySuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
+(void) searchImages:(NSString *)keyword skip:(NSInteger)skip successBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
///票房
+(void) requestBoxOfficeSuccessBlock:(ArrayNetBlock)success failure:(NetFailureBlock)failure;
+(void) requestDouBanSuccessBlock:(ArrayNetBlock)success failure:(NetFailureBlock)failure;
@end
