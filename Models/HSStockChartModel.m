//
//  HSStockChartModel.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSStockChartModel.h"

@implementation HSStockChartModel

#pragma mark public

- (NSString *)generateDateStringByType:(HSKLineType)type{
    NSString * dateFomatter = @"";
    switch (type) {
        case HSKLineType1Min:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType5Min:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType15Min:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType30Min:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType1Hour:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType1Day:
            dateFomatter = @"YYYY/MM/dd";
            break;
            
        case HSKLineType1Week:
            dateFomatter = @"MM/dd HH:mm";
            break;
            
        case HSKLineType1Month:
            dateFomatter = @"YYYY/MM";
            break;
            
        default:
            break;
    }
    
    return [NSDate stringFromDateWithTimeInterval:self.date dateFormatterString:dateFomatter];
}

+ (NSString *)getTypeStringByTimeType:(HSKLineType)type{
    switch (type) {
        case HSKLineType1Min:
            return @"1min";
            break;
            
        case HSKLineType5Min:
            return @"5min";
            break;
            
        case HSKLineType15Min:
            return @"15min";
            break;
            
        case HSKLineType30Min:
            return @"30min";
            break;
            
        case HSKLineType1Hour:
            return @"1hour";
            break;
            
        case HSKLineType1Day:
            return @"1day";
            break;
            
        case HSKLineType1Week:
            return @"1week";
            break;
            
        case HSKLineType1Month:
            return @"1month";
            break;
            
        default:
            return @"";
            break;
    }
}


#pragma mark getters
- (BOOL)isRise{
    return self.close - self.open >= 0;
}

@end
