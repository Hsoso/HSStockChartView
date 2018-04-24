//
//  HSCrossLineModel.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/21.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSCrossLineModel.h"
#import "HSStockChartViewVariable.h"

@implementation HSCrossLineModel

- (instancetype)initWithChartModel:(HSStockChartModel *)model crossPoint:(CGPoint)crossPoint modelGroup:(HSStockChartModelGroup *)modelGroup{
    self = [super init];
    if(self){
        _chartModel = model;
        _crossPoint = crossPoint;
        _modelGroup = modelGroup;
    }
    return self;
}

#pragma mark public
- (BOOL)isInKLineChart{
    CGFloat bottomSpaceHeight = [HSStockChartViewVariable chartBottomSpaceHeight];
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    
    if(self.crossPoint.y <= [HSStockChartViewVariable chartHeight] * (1 - volumeViewRatio) - bottomSpaceHeight){
        return YES;
    }
    
    return NO;
}

- (BOOL)isInVolumeChart{
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    
    if(self.crossPoint.y >= [HSStockChartViewVariable chartHeight] * (1 - volumeViewRatio)){
        return YES;
    }
    
    return NO;
}


#pragma mark private


#pragma mark getters
- (HSStockChartModelGroup *)modelGroup{
    if(_modelGroup == nil){
        _modelGroup = [[HSStockChartModelGroup alloc] init];
        _modelGroup.chartModelArray = @[];
    }
    
    return _modelGroup;
}

- (CGFloat)rightInfo{
    CGFloat bottomSpaceHeight = [HSStockChartViewVariable chartBottomSpaceHeight];
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    CGFloat chartHeight = [HSStockChartViewVariable chartHeight];
    
    CGFloat kLineHeight = chartHeight * (1 - volumeViewRatio) - bottomSpaceHeight;
    CGFloat volumeHeight = chartHeight * volumeViewRatio;
    
    if([self isInKLineChart]){
        CGFloat maxNumber = self.modelGroup.kLineChartTopNumber;
        CGFloat minNumber = self.modelGroup.kLineChartBottomNumber;
        CGFloat number = maxNumber - self.crossPoint.y * (maxNumber - minNumber) / kLineHeight;
        return number;
    }else if([self isInVolumeChart]){
        CGFloat maxNumber = self.modelGroup.maxVolumeNumber;
        CGFloat number = maxNumber - (self.crossPoint.y - kLineHeight - bottomSpaceHeight) * maxNumber / volumeHeight;
        return number;
    }
    
    return 0;
}

- (NSTimeInterval)bottomInfo{
    return self.chartModel.date;
}

@end
