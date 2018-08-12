//
//  FunctionModel.m
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/11.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "FunctionModel.h"

@implementation FunctionModel
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName address:(NSString *)address{
    if (self = [super init]) {
        self.title = title;
        self.imageName = imageName;
        self.address = address;
    }
    return self;
}
+ (instancetype) instanceWithTitle:(NSString *)title imageName:(NSString *)imageName address:(NSString *)address{
    FunctionModel *model = [[FunctionModel alloc] initWithTitle:title imageName:imageName address:address];
    return model;
}
@end
