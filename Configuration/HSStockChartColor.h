//
//  HSStockChartColor.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HSStockChartColor : NSObject


/**
 *  背景颜色
 */
+ (UIColor *)chartBackgroundColor;

/**
 *  涨的颜色
 */
+ (UIColor *)riseColor;

/**
 *  跌的颜色
 */
+ (UIColor *)dropColor;

/**
 *  分割线的颜色
 */
+ (UIColor *)separatorColor;

/**
 *  十字交叉线的颜色
 */
+ (UIColor *)crossLineColor;

/**
 *  刻度线的颜色
 */
+ (UIColor *)scaleLineColor;

/**
 *  刻度字体的颜色
 */
+ (UIColor *)scaleLabelColor;

/**
 *  MA5线颜色
 */
+ (UIColor *)MA5LineColor;

/**
 *  MA10线颜色
 */
+ (UIColor *)MA10LineColor;

/**
 *  MA20线颜色
 */
+ (UIColor *)MA20LineColor;


@end
