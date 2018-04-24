//
//  HSKLineSegmentView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStockChartModel;
@interface HSKLineSegmentView : UIView

/**
 *  初始化方法
 */
- (instancetype)initWithModel:(HSStockChartModel *)model;


/**
 *  index代表这个segment存在于modelArray的坐标
 */
@property (nonatomic, assign) NSInteger index;

@end
