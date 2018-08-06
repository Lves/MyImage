//
//  HomeCollectionReusableView.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSPagerView/FSPagerView-umbrella.h>
@interface HomeCollectionReusableView : UICollectionReusableView<FSPagerViewDelegate, FSPagerViewDataSource>
@property (weak, nonatomic) IBOutlet FSPagerView *pagerView;
@property (nonatomic,strong) NSArray *dataArray;
@end
