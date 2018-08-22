//
//  UIViewController+HUD.m
//  MyPhoto
//
//  Created by lixingle on 2018/8/22.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import "UIViewController+HUD.h"
#import <MBProgressHUD/MBProgressHUD.h>

@implementation UIViewController (HUD)

- (void)showLoading{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)hidenLoading{
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)showLoadingHideAfter:(double)second completion:(HUDCompletionBlock)block{
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (block) {
            block();
        }
    });
}
#pragma mark - 文字
- (void)showHUDText:(NSString *)text hideAfter:(double)second completion:(HUDCompletionBlock)block{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.labelText = text;
    hud.mode = MBProgressHUDModeText;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, second * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (block) {
            block();
        }
    });
}
- (void)showHUDText:(NSString *)text{
    [self showHUDText:text hideAfter:2 completion:nil];
}
- (void)showHUDText:(NSString *)text completion:(HUDCompletionBlock)block{
    [self showHUDText:text hideAfter:2 completion:block];
}

@end
