//
//  HSStockChartViewVariable.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSStockChartViewVariable : NSObject

/**
 *  整个chart的宽度 - 不包括留白
 */
+ (CGFloat)chartWidth;
+ (void)setChartWidth:(CGFloat)width;

/**
 *  整个chart的高度 - 不包括留白
 */
+ (CGFloat)chartHeight;
+ (void)setChartHeight:(CGFloat)height;

/**
 *  k线图柱宽：通过k线图间隔以及k线图屏幕需要显示个数计算
 */
+ (CGFloat)kLineWidth;


/**
 *  K线图的间隔，通过当前屏幕显示的k线图个数与最大个数的比例进行计算
 */
+ (CGFloat)kLineGap;

/**
 *  屏幕需要显示的K线图个数
 */
+ (NSInteger)kLineNumberPerScreen;
+ (void)setkLineNumberPerScreen:(NSInteger)number;

/**
 *  屏幕需要显示的K线图默认个数,为48
 */
+ (NSInteger)defaultKLineNumberPerScreen;

/**
 *  屏幕需要显示的K线图个数最小15个
 */
+ (NSInteger)minKLineNumberPerScreen;

/**
 *  VolumeView的高度占比,默认为0.2
 */
+ (CGFloat)kLineVolumeViewRatio;
+ (void)setkLineVolumeViewRatio:(CGFloat)ratio;

/**
 *  表格右边留白宽度，用于显示数据
 */
+ (CGFloat)chartRightSpaceWidth;
+ (void)setchartRightSpaceWidth:(CGFloat)width;

/**
 *  表格下面留白高度，用于显示日期
 */
+ (CGFloat)chartBottomSpaceHeight;
+ (void)setchartBottomSpaceHeight:(CGFloat)height;

/**
 *  表格上面留白高度，用于显示数据
 */
+ (CGFloat)chartTopSpaceHeight;
+ (void)setchartTopSpaceHeight:(CGFloat)height;

/**
 *  K线图刻度个数
 */
+ (NSInteger)kLineScaleNumber;
+ (void)setkLineScaleNumber:(NSInteger)number;

/**
 *  Volume图刻度个数
 */
+ (NSInteger)volumeScaleNumber;
+ (void)setvolumeScaleNumber:(NSInteger)number;

/**
 *  刻度字体大小
 */
+ (CGFloat)scaleFontSize;




@end
