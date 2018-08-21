//
//  HomeCollectionReusableView.h
//  MyPhoto
//
//  Created by lixingle on 2018/8/6.
//  Copyright © 2018年 com.pintec. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FSPagerView/FSPagerView-umbrella.h>

@class HomeCollectionReusableView;
@protocol HColleReusableViewDelegate <NSObject>
-(void) pagerView:(FSPagerView *)pagerView cell:(FSPagerViewCell *)cell didSelectItemAtIndex:(NSInteger)index;
@end


@interface HomeCollectionReusableView : UICollectionReusableView<FSPagerViewDelegate, FSPagerViewDataSource>
@property (weak, nonatomic) IBOutlet FSPagerView *pagerView;
@property (nonatomic,strong) NSArray *dataArray;
@property (nonatomic,weak) id <HColleReusableViewDelegate> delegate;
@end
