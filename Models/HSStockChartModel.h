//
//  HSStockChartModel.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <Foundation/Foundation.h>

//种类
typedef NS_ENUM(NSInteger, HSKLineType) {
    HSKLineType1Min = 0,
    HSKLineType5Min,
    HSKLineType15Min,
    HSKLineType30Min,
    HSKLineType1Hour,
    HSKLineType1Day,
    HSKLineType1Week,
    HSKLineType1Month
};

@interface HSStockChartModel : NSObject

/**********属性***********/
/**
 *  日期
 */
@property (nonatomic, assign) NSTimeInterval date;

/**
 *  开盘价
 */
@property (nonatomic, assign) CGFloat open;


/**
 *  收盘价
 */
@property (nonatomic, assign) CGFloat close;

/**
 *  最高价
 */
@property (nonatomic, assign) CGFloat high;

/**
 *  最低价
 */
@property (nonatomic, assign) CGFloat low;

/**
 *  成交量
 */
@property (nonatomic, assign) CGFloat vol;

/**
 *  MA5
 */
@property (nonatomic, assign) CGFloat MA5_Number;

/**
 *  MA10
 */
@property (nonatomic, assign) CGFloat MA10_Number;

/**
 *  MA20
 */
@property (nonatomic, assign) CGFloat MA20_Number;

/**
 *  是否有涨, 若开盘价低于收盘价，则为true
 */
@property (nonatomic, assign) BOOL isRise;

/**********方法***********/

/**
 *  通过类型和时间戳获取对应应该显示的string
 */
- (NSString *)generateDateStringByType:(HSKLineType)type;

/**
 *  通过类型获取该类型的string
 */
+ (NSString *)getTypeStringByTimeType:(HSKLineType)type;


@end
