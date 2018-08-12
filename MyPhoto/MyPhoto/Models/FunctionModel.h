//
//  FunctionModel.h
//  MyPhoto
//
//  Created by XINGLE LI on 2018/8/11.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FunctionModel : NSObject
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *imageName;
@property (nonatomic,copy) NSString *address;
- (instancetype)initWithTitle:(NSString *)title imageName:(NSString *)imageName address:(NSString *)address;
+ (instancetype) instanceWithTitle:(NSString *)title imageName:(NSString *)imageName address:(NSString *)address;
@end
