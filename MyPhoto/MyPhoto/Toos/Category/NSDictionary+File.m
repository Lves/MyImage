//
//  NSDictionary+File.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/21.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "NSDictionary+File.h"

@implementation NSDictionary (File)
- (void)writeToPlist:(NSString *)name{
    //这个方法获取出的结果是一个数组.因为有可以搜索到多个路径.
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    NSString *cachePath = array[0];
    //拼接文件路径
    NSString *filePathName = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"collection_%@.plist",name]];
    //ToFile:要写入的沙盒路径
    [self writeToFile:filePathName atomically:YES];
}
+ (NSMutableDictionary *)arrayFromPlist:(NSString *)name{
    NSArray *array =  NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    //在这里,我们指定搜索的是Cache目录,所以结果只有一个,取出Cache目录
    NSString *cachePath = array[0];
    //拼接文件路径
    NSString *filePathName = [cachePath stringByAppendingPathComponent:[NSString stringWithFormat:@"collection_%@.plist",name]];
    //从文件当中读取字典, 保存的plist文件就是一个字典,这里直接填写plist文件所存的路径
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:filePathName];
    return [dict mutableCopy];
}
@end
