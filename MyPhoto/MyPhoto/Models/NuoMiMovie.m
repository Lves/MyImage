//
//  NuoMiMovie.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "NuoMiMovie.h"
#import <MJExtension/MJExtension.h>
@implementation NuoMiMovie
//+ (NSDictionary *)mj_objectClassInArray{
//    return @{@"attribute": @"MovieAttribute"};
//}
@end

@implementation DoubanMovie
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idStr":@"id"};
}
+ (NSDictionary *)mj_objectClassInArray{
    return @{@"images": @"DBImage"};
}
@end
@implementation DBImage
@end
@implementation DBRating
@end
