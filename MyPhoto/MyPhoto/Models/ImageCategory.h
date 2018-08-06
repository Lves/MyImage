//
//  ImageCategory.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ImageCategory : NSObject
@property (nonatomic,copy) NSString *ename;
@property (nonatomic,copy) NSString *atime;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *cover;
@property (nonatomic,assign) NSInteger sn;
@property (nonatomic,assign) NSInteger nimgs;
@property (nonatomic,assign) NSInteger type;
@property (nonatomic,copy) NSString *idStr;
@property (nonatomic,copy) NSString *desc;
@end
