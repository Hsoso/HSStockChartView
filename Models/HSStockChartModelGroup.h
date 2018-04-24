//
//  HSStockChartModelGroup.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HSStockChartModel.h"

#define CenterPointKey @"CenterPointKey"
#define ChartModelKey @"ChartModelKey"
#define ChartModelGroupKey @"ChartModelGroupKey"

#define ScaleNumberKey @"ScaleNumberKey"
#define ScalePositionYKey @"ScalePositionYKey"

@interface HSStockChartModelGroup : NSObject
/**********属性***********/
/**
 *  数据源数组
 */
@property (nonatomic, copy) NSArray<HSStockChartModel *> * chartModelArray;

/**
 *  在当前屏幕内的最左边的model的index,随着滑动而改变
 */
@property (nonatomic, assign) NSInteger leftIndexInScreen;

/**
 *  在当前屏幕内的最右边的model的index,随着滑动而改变
 */
@property (nonatomic, assign) NSInteger rightIndexInScreen;

/**
 *  k线图内最高点(屏幕内)
 */
@property (nonatomic, assign) CGFloat kLineChartTopNumber;

/**
 *  k线图内最低点(屏幕内)
 */
@property (nonatomic, assign) CGFloat kLineChartBottomNumber;

/**
 *  屏幕内的最高价顶点
 */
@property (nonatomic, assign) CGFloat maxHighNumber;

/**
 *  屏幕内的最低价底点
 */
@property (nonatomic, assign) CGFloat minLowNumber;

/**
 *  屏幕内的出货量最顶点
 */
@property (nonatomic, assign) CGFloat maxVolumeNumber;

/**
 *  屏幕左边的坐标点
 */
@property (nonatomic, assign) CGFloat leftXInScreen;

/**
 *  屏幕右边的坐标点
 */
@property (nonatomic, assign) CGFloat rightXInScreen;




/**********方法***********/

/**
 *  改变数据源时，需要运行该方法，重新设定所有model的MA数值, 目前使用KVO监听，会自动运行，不需要手动调用
 */
//- (void)generateMANumbers;

/**
 *  通过用户点击的位置以及当前scrollview滑动偏移量来获取离得最近的model及crossLine的中心点
 */
- (NSDictionary *)findModelByTouchPoint:(CGPoint)point contentOffsetX:(CGFloat)contentOffsetX;

/**
 *  通过滑动距离，算出屏幕内的models的最左index和最右index
 */
- (void)CalculateLeftAndRightIndexInScreenByContentOffsetX:(CGFloat)contentOffsetX;

/**
 *  固定住屏幕最右端的model，缩放过后获取需要滚动的距离
 */
- (CGFloat)calculateContentOffsetXByRightIndex;

/**
 *  生成k线图的刻度字典，包含一个代表刻度数字的数组，一个代表刻度所在y轴位置的数组
 */
- (NSDictionary *)generateScaleDictionaryForKLineChart;

/**
 *  生成Volume图的刻度字典，包含一个代表刻度数字的数组，一个代表刻度所在y轴位置的数组
 */
- (NSDictionary *)generateScaleDictionaryForVolumeChart;

/**
 *  计算在k线图里某个数据对应的y轴大小
 */
- (CGFloat)calculatePositionYForKLineChartByNumber:(CGFloat)number;

/**
 *  计算在Volume图里某个数据对应的y轴大小
 */
- (CGFloat)calculatePositionYForVolumeChartByNumber:(CGFloat)number;
@end
