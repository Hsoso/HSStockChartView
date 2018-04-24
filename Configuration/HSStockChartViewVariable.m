//
//  HSStockChartViewVariable.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSStockChartViewVariable.h"
/**
 *  整个chart的宽度 - 不包括留白,默认值不重要，因为在设置了chart的frame以后会自动将宽度设置上去
 */
static CGFloat HSStockChartWidth = 375;

/**
 *  整个chart的高度 - 不包括留白,默认值不重要，因为在设置了chart的frame以后会自动将高度设置上去
 */
static CGFloat HSStockChartHeight = 750;

/**
 *  K线图的最小间隔
 */
static CGFloat HSStockChartKLineMinGap = 1;

/**
 *  VolumeView的高度占比,默认为0.2
 */
static CGFloat HSStockChartKLineVolumeViewRatio = 0.2;

/**
 *  屏幕需要显示的K线图个数
 */
static CGFloat HSKLineNumberPerScreen = 48;

/**
 *  屏幕需要显示的K线图个数,默认为48
 */
static CGFloat HSDefaultKLineNumberPerScreen = 48;

/**
 *  屏幕需要显示的K线图个数最小15个
 */
static CGFloat HSMinKLineNumberPerScreen = 15;

/**
 *  K线图最小宽度
 */
static CGFloat HSMinKLineWidth = 2;

/**
 *  表格右边留白宽度，用于显示数据
 */
static CGFloat HSChartRightSpaceWidth = 40;

/**
 *  表格下面留白高度，用于显示日期
 */
static CGFloat HSChartBottomSpaceHeight = 13;

/**
 *  表格上面留白高度，用于显示数据
 */
static CGFloat HSChartTopSpaceHeight = 34;

/**
 *  K线图刻度个数,默认为5
 */
static NSInteger HSKLineScaleNumber = 5;

/**
 *  Volume图刻度个数,默认为3
 */
static NSInteger HSVolumeScaleNumber = 3;

/**
 *  刻度字体大小
 */
static CGFloat HSScaleFontSize = 10.0;


@implementation HSStockChartViewVariable

+ (CGFloat)chartWidth{
    return HSStockChartWidth;
}
+ (void)setChartWidth:(CGFloat)width{
    HSStockChartWidth = width;
}

+ (CGFloat)chartHeight{
    return HSStockChartHeight;
}
+ (void)setChartHeight:(CGFloat)height{
    HSStockChartHeight = height;
}


+ (CGFloat)kLineWidth{
    CGFloat gap = [self kLineGap];
    NSInteger number = [self kLineNumberPerScreen];
    
    CGFloat width = (HSStockChartWidth - gap) / number - gap;
    if(width < HSMinKLineWidth){
        width = HSMinKLineWidth;
    }
    
    return width;
}

+ (CGFloat)kLineGap{
    NSInteger maxNumber = [self maxKLineNumberPerScreen];
    return 1.0 + (maxNumber - HSKLineNumberPerScreen) / ((CGFloat)maxNumber) * 5.0;
}

+ (NSInteger)kLineNumberPerScreen{
    return HSKLineNumberPerScreen;
}
+ (void)setkLineNumberPerScreen:(NSInteger)number{
    NSInteger maxNumber = [self maxKLineNumberPerScreen];
    if(number > maxNumber){
        HSKLineNumberPerScreen = maxNumber;
    }else if(number < HSMinKLineNumberPerScreen){
        HSKLineNumberPerScreen = HSMinKLineNumberPerScreen;
    }else{
        HSKLineNumberPerScreen = number;
    }
}

+ (NSInteger)defaultKLineNumberPerScreen{
    return HSDefaultKLineNumberPerScreen;
}

+ (NSInteger)maxKLineNumberPerScreen{
    return (NSInteger)((HSStockChartWidth - HSStockChartKLineMinGap) / (HSMinKLineWidth + HSStockChartKLineMinGap));
}

+ (NSInteger)minKLineNumberPerScreen{
    return HSMinKLineNumberPerScreen;
}


+ (CGFloat)kLineVolumeViewRatio{
    return HSStockChartKLineVolumeViewRatio;
}
+ (void)setkLineVolumeViewRatio:(CGFloat)ratio{
    HSStockChartKLineVolumeViewRatio = ratio;
}

+ (CGFloat)chartRightSpaceWidth{
    return HSChartRightSpaceWidth;
}
+ (void)setchartRightSpaceWidth:(CGFloat)width{
    HSChartRightSpaceWidth = width;
}

+ (CGFloat)chartBottomSpaceHeight{
    return HSChartBottomSpaceHeight;
}
+ (void)setchartBottomSpaceHeight:(CGFloat)height{
    HSChartBottomSpaceHeight = height;
}

+ (CGFloat)chartTopSpaceHeight{
    return HSChartTopSpaceHeight;
}
+ (void)setchartTopSpaceHeight:(CGFloat)height{
    HSChartTopSpaceHeight = height;
}

+ (NSInteger)kLineScaleNumber{
    return HSKLineScaleNumber;
}
+ (void)setkLineScaleNumber:(NSInteger)number{
    HSKLineScaleNumber = number;
}

+ (NSInteger)volumeScaleNumber{
    return HSVolumeScaleNumber;
}
+ (void)setvolumeScaleNumber:(NSInteger)number{
    HSVolumeScaleNumber = number;
}

+ (CGFloat)scaleFontSize{
    return HSScaleFontSize;
}








@end
