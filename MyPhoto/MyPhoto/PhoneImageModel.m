//
//  PhoneImageModel.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "PhoneImageModel.h"

@implementation PhoneImageModel
+(NSDictionary *)mj_replacedKeyFromPropertyName{
    return @{@"idStr":@"id"};
}
@end
