//
//  UIViewController+HUD.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/22.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^HUDCompletionBlock)(void);

@interface UIViewController (HUD)
- (void)showLoading;
- (void)hidenLoading;
- (void)showLoadingHideAfter:(double)second completion:(HUDCompletionBlock)block;
- (void)showHUDText:(NSString *)text hideAfter:(double)second completion:(HUDCompletionBlock)block;
- (void)showHUDText:(NSString *)text;
- (void)showHUDText:(NSString *)text completion:(HUDCompletionBlock)block;
@end
