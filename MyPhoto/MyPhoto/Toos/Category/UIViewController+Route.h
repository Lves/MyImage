//
//  UIViewController+Route.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Route)
-(UIViewController *) instanceViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params;
+(UIViewController *) instanceViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params;
-(void)pushToViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params;
@end
