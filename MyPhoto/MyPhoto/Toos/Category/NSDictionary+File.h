//
//  NSDictionary+File.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/21.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (File)
- (void)writeToPlist:(NSString *)name;
+ (NSMutableDictionary *)arrayFromPlist:(NSString *)name;
@end
