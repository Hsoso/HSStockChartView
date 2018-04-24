//
//  HSKLineView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStockChartModelGroup;
@interface HSKLineView : UIView

/**
 *  数据源
 */
@property (nonatomic, strong) HSStockChartModelGroup * modelGroup;


/**
 *  刷新k线图
 */
- (void)reloadData;

@end
