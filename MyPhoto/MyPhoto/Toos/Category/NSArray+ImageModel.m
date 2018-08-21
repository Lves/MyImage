//
//  NSArray+ImageModel.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/21.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "NSArray+ImageModel.h"
#import "PhoneImageModel.h"
#import "Image360Model.h"
#import "SearchImageModel.h"
@implementation NSArray (ImageModel)

- (NSArray *)getPhoneImageModelProperty{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        if ([object isKindOfClass:[PhoneImageModel class]]){
            [array addObject:((PhoneImageModel *)object).img];
        }
    }
    return array;
}
- (NSArray *)getImage360ModelProperty{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        if ([object isKindOfClass:[Image360Model class]]){
            [array addObject:((Image360Model *)object).url];
        }
    }
    return array;
}
- (NSArray *)getSearchImageModelProperty{
    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
    for (id object in self) {
        if ([object isKindOfClass:[SearchImageModel class]]){
            [array addObject:((SearchImageModel *)object).url];
        }
    }
    return array;
}
@end

//@implementation NSMutableArray (ImageModel)
//
//- (NSArray *)getPhoneImageModelProperty{
//    NSMutableArray *array = [NSMutableArray arrayWithCapacity:self.count];
//    for (id object in self) {
//        if ([object isKindOfClass:[PhoneImageModel class]]){
//            [array addObject:((PhoneImageModel *)object).img];
//        }
//    }
//    return array;
//}
//@end
