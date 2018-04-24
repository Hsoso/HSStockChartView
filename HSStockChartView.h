//
//  HSStockChartView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HSStockChartModelGroup.h"

@class HSStockChartView;
@protocol HSStockChartViewDelegate <NSObject>

- (void)chartViewNeedLoadNewData:(HSStockChartView *)chartView complete:(void (^)(NSArray * array))complete;

@end


@interface HSStockChartView : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id<HSStockChartViewDelegate> delegate;


/**
 *  数据源
 */
@property (nonatomic, strong) HSStockChartModelGroup * modelGroup;

/**
 *  表的时间间隔类型
 */
@property (nonatomic, assign) HSKLineType timeType;


/**
 *  刷新整个表图
 */
- (void)reloadData;

@end
