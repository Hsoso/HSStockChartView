//
//  HSBarChartView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSBarChartView.h"

#import "HSStockChartModelGroup.h"
#import "HSBarChartSegmentView.h"

#import "HSStockChartViewVariable.h"
#import "HSStockChartColor.h"

@interface HSBarChartView()
/**
 *  与K线图的分割线
 */
@property (nonatomic, strong) UIView * separatorLine;

/**
 *  底部分割线
 */
@property (nonatomic, strong) UIView * bottomSeparatorLine;

/**
 *  存放柱状条的数组
 */
@property (nonatomic, strong) NSMutableArray<HSBarChartSegmentView *> * segmentArray;


@end

@implementation HSBarChartView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.separatorLine.frame = CGRectMake(0, 0, self.width, 1);
    
    self.bottomSeparatorLine.frame = CGRectMake(0, self.height - 1, self.width, 1);
    
    [self layoutSegmentViews];
}

#pragma mark private
- (void)layoutSegmentViews{
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    CGFloat segmentWidth = [HSStockChartViewVariable kLineWidth];
    CGFloat maxNumber = self.modelGroup.maxVolumeNumber;
    
    for (HSBarChartSegmentView * segment in self.segmentArray) {
        HSStockChartModel * model = self.modelGroup.chartModelArray[segment.index];
        
        CGFloat segmentHeight = model.vol / maxNumber * self.height;
        
        segment.frame = CGRectMake(gap + segment.index * (segmentWidth + gap), self.height - segmentHeight, segmentWidth, segmentHeight);
    }
}

#pragma mark public
- (void)reloadData{
    //清除所有柱状条
    for (HSBarChartSegmentView * segmentView in self.segmentArray) {
        [segmentView removeFromSuperview];
    }
    self.segmentArray = nil;
    
    //重新创建 - 只创建屏幕中用于显示的部分，节省开销
    if(self.modelGroup.chartModelArray.count > 0){
        for (NSInteger i = self.modelGroup.leftIndexInScreen; i <= self.modelGroup.rightIndexInScreen; i++) {
            HSStockChartModel * model = self.modelGroup.chartModelArray[i];
            
            HSBarChartSegmentView * segmentView = [[HSBarChartSegmentView alloc] initWithIsRise:model.isRise];
            segmentView.index = i;
            [self addSubview:segmentView];
            [self.segmentArray addObject:segmentView];
        }
        
        [self layoutSegmentViews];
    }

}

#pragma mark getters
- (HSStockChartModelGroup *)modelGroup{
    if(_modelGroup == nil){
        _modelGroup = [[HSStockChartModelGroup alloc] init];
        _modelGroup.chartModelArray = @[];
    }
    
    return _modelGroup;
}

- (NSMutableArray<HSBarChartSegmentView *> *)segmentArray{
    if(_segmentArray == nil){
        _segmentArray = @[].mutableCopy;
    }
    return _segmentArray;
}

- (UIView *)separatorLine{
    if(_separatorLine == nil){
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [HSStockChartColor separatorColor];
        
        [self addSubview:_separatorLine];
    }
    return _separatorLine;
}

- (UIView *)bottomSeparatorLine{
    if(_bottomSeparatorLine == nil){
        _bottomSeparatorLine = [[UIView alloc] init];
        _bottomSeparatorLine.backgroundColor = [HSStockChartColor separatorColor];
        
        [self addSubview:_bottomSeparatorLine];
    }
    return _bottomSeparatorLine;
}


@end
