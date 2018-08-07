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

@interface BaseNetApi : NSObject
+ (void)requestHome:(NSInteger)skip SuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
+ (void)requestBannerSuccessBlock:(HomeNetBlock)success failure:(NetFailureBlock)failure;
@end
