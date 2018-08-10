//
//  UIViewController+Route.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "UIViewController+Route.h"

@implementation UIViewController (Route)
-(UIViewController *) instanceViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *controller = [sb instantiateViewControllerWithIdentifier:controllerName];
    controller.hidesBottomBarWhenPushed = true;
    for (NSString *key in params.allKeys) {
        [controller setValue:params[key] forKey:key];
    }
    return controller;
}
+(UIViewController *) instanceViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params{
    UIStoryboard *sb = [UIStoryboard storyboardWithName:sbName bundle:nil];
    UIViewController *controller = [sb instantiateViewControllerWithIdentifier:controllerName];
    controller.hidesBottomBarWhenPushed = true;
    for (NSString *key in params.allKeys) {
        [controller setValue:params[key] forKey:key];
    }
    return controller;
}

-(void)pushToViewController:(NSString *)controllerName storyboardName:(NSString *)sbName params:(NSDictionary *)params{
    UIViewController *contrller = [self instanceViewController:controllerName storyboardName:sbName params:params];
    [self.navigationController pushViewController:contrller animated:true];
}
@end
