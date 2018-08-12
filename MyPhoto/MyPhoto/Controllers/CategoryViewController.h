//
//  CategoryViewController.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger,ViewType) {
    ViewTypeCategory,
    ViewTypeHot,
};

@interface CategoryViewController : UIViewController
@property (nonatomic,copy) NSString *categoryId;
@property (nonatomic,copy) NSString *name;
@property (nonatomic, assign) ViewType viewType;
@end
