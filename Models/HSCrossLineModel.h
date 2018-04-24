//
//  HSCrossLineModel.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/21.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSStockChartModelGroup.h"

@interface HSCrossLineModel : NSObject
/**********属性***********/

/**
*  数据源
*/
@property (nonatomic, strong) HSStockChartModelGroup * modelGroup;

/**
 *  选取的数据model
 */
@property (nonatomic, strong) HSStockChartModel * chartModel;

/**
 *  中心点坐标
 */
@property (nonatomic, assign) CGPoint crossPoint;

/**
 *  右边需要显示的信息
 */
@property (nonatomic, assign) CGFloat rightInfo;

/**
 *  底下需要显示的信息
 */
@property (nonatomic, assign) NSTimeInterval bottomInfo;



/**********方法***********/
/**
 *  初始化方法
 */
- (instancetype)initWithChartModel:(HSStockChartModel *)model crossPoint:(CGPoint)crossPoint modelGroup:(HSStockChartModelGroup *)modelGroup;

/**
 *  点击点是否在k线图内
 */
- (BOOL)isInKLineChart;

/**
 *  点击点是否在柱状图内
 */
- (BOOL)isInVolumeChart;

@end
