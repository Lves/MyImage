//
//  NuoMiMovie.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/10.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NuoMiMovie : NSObject
@property(nonatomic,copy) NSString *movieId;
@property(nonatomic,copy) NSString *movieName;
@property(nonatomic,strong) NSDictionary *attribute;
@end

//@interface MovieAttribute: NSObject
//@property(nonatomic,copy) NSString *attrName;
//@property(nonatomic,copy) NSString *attrValue;
//@end

