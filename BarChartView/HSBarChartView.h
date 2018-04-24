//
//  HSBarChartView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStockChartModelGroup;
@interface HSBarChartView : UIView

/**
 *  数据源
 */
@property (nonatomic, strong) HSStockChartModelGroup * modelGroup;


/**
 *  刷新柱状图
 */
- (void)reloadData;

@end
