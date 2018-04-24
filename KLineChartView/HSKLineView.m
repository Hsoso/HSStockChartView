//
//  HSKLineView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSKLineView.h"

#import "HSStockChartModelGroup.h"
#import "HSKLineSegmentView.h"

#import "HSStockChartViewVariable.h"
#import "HSStockChartColor.h"

@interface HSKLineView()

/**
 *  存放k线条的数组
 */
@property (nonatomic, strong) NSMutableArray<HSKLineSegmentView *> * segmentArray;

/**
 *  MA5线
 */
@property (nonatomic, strong) CAShapeLayer * MA5ShapeLayer;

/**
 *  MA10线
 */
@property (nonatomic, strong) CAShapeLayer * MA10ShapeLayer;

/**
 *  MA20线
 */
@property (nonatomic, strong) CAShapeLayer * MA20ShapeLayer;

/**
 *  屏幕内High的最大值
 */
@property (nonatomic, strong) UILabel * maxHighLabel;

/**
 *  屏幕内Low的最小值
 */
@property (nonatomic, strong) UILabel * minLowLabel;

@end

@implementation HSKLineView

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutSegmentViews];
}

#pragma mark private
- (void)layoutSegmentViews{
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    CGFloat segmentWidth = [HSStockChartViewVariable kLineWidth];
    CGFloat maxN = self.modelGroup.kLineChartTopNumber;
    CGFloat minN = self.modelGroup.kLineChartBottomNumber;
    
    //MA5, MA10, MA20
    UIBezierPath * MA5Path = [[UIBezierPath alloc] init];
    UIBezierPath * MA10Path = [[UIBezierPath alloc] init];
    UIBezierPath * MA20Path = [[UIBezierPath alloc] init];
    if(self.segmentArray.count > 0){
        HSKLineSegmentView * segmentView = self.segmentArray[0];
        //线往左多画一格，显得连贯
        NSInteger index = segmentView.index > 0 ? segmentView.index - 1 : 0;
        HSStockChartModel * model = self.modelGroup.chartModelArray[index];
        
        CGFloat positionY5 = [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA5_Number];
        [MA5Path moveToPoint:CGPointMake(gap + (index + 0.5) * (segmentWidth + gap), positionY5)];
        
        CGFloat positionY10 = [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA10_Number];
        [MA10Path moveToPoint:CGPointMake(gap + (index + 0.5) * (segmentWidth + gap), positionY10)];
        
        CGFloat positionY20 = [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA20_Number];
        [MA20Path moveToPoint:CGPointMake(gap + (index + 0.5) * (segmentWidth + gap), positionY20)];
    }
    
    
    for (HSKLineSegmentView * segment in self.segmentArray) {
        HSStockChartModel * model = self.modelGroup.chartModelArray[segment.index];

        CGFloat topY = self.height * (maxN - model.high) / (maxN - minN);
        CGFloat bottomY = self.height * (maxN - model.low) / (maxN - minN);
        
        segment.frame = CGRectMake(gap + segment.index * (segmentWidth + gap), topY, segmentWidth, bottomY - topY == 0 ? 1 : bottomY - topY);
        
        [MA5Path addLineToPoint:CGPointMake(gap + (segment.index + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA5_Number])];
        [MA10Path addLineToPoint:CGPointMake(gap + (segment.index + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA10_Number])];
        [MA20Path addLineToPoint:CGPointMake(gap + (segment.index + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA20_Number])];
        
        //绘制最高价label
        if(model.high == self.modelGroup.maxHighNumber){
            CGSize labelSize = [self.maxHighLabel sizeThatFits:CGSizeMake(200, 200)];
            CGFloat labelX = segment.center.x - labelSize.width / 2;
            if(labelX < self.modelGroup.leftXInScreen){
                labelX = self.modelGroup.leftXInScreen;
            }else if(labelX > self.modelGroup.rightXInScreen - labelSize.width){
                labelX = self.modelGroup.rightXInScreen - labelSize.width;
            }
            CGFloat labelY = segment.y - labelSize.height;
            self.maxHighLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
        }
        
        //绘制最低价label
        if(model.low == self.modelGroup.minLowNumber){
            CGSize labelSize = [self.minLowLabel sizeThatFits:CGSizeMake(200, 200)];
            CGFloat labelX = segment.center.x - labelSize.width / 2;
            if(labelX < self.modelGroup.leftXInScreen){
                labelX = self.modelGroup.leftXInScreen;
            }else if(labelX > self.modelGroup.rightXInScreen - labelSize.width){
                labelX = self.modelGroup.rightXInScreen - labelSize.width;
            }
            CGFloat labelY = segment.y + segment.height;
            self.minLowLabel.frame = CGRectMake(labelX, labelY, labelSize.width, labelSize.height);
        }
    }
    
    HSKLineSegmentView * segmentView = self.segmentArray.lastObject;
    if(segmentView){
        //线往右多画一格，显得连贯
        NSInteger finalIndex = segmentView.index < self.modelGroup.chartModelArray.count - 1 ? segmentView.index + 1 : segmentView.index;
        HSStockChartModel * model = self.modelGroup.chartModelArray[finalIndex];
        [MA5Path addLineToPoint:CGPointMake(gap + (finalIndex + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA5_Number])];
        [MA10Path addLineToPoint:CGPointMake(gap + (finalIndex + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA10_Number])];
        [MA20Path addLineToPoint:CGPointMake(gap + (finalIndex + 0.5) * (segmentWidth + gap), [self.modelGroup calculatePositionYForKLineChartByNumber:model.MA20_Number])];
    }
    
    
    
    self.MA5ShapeLayer.path = MA5Path.CGPath;
    self.MA10ShapeLayer.path = MA10Path.CGPath;
    self.MA20ShapeLayer.path = MA20Path.CGPath;
}

#pragma mark public
- (void)reloadData{
    //清除所有柱状条
    for (HSKLineSegmentView * segmentView in self.segmentArray) {
        [segmentView removeFromSuperview];
    }
    self.segmentArray = nil;
    
    //清除MA线
    self.MA5ShapeLayer.path = nil;

    self.MA10ShapeLayer.path = nil;

    self.MA20ShapeLayer.path = nil;
    
    //重新创建 - 只创建屏幕中用于显示的部分，节省开销
    if(self.modelGroup.chartModelArray.count > 0){
        for (NSInteger i = self.modelGroup.leftIndexInScreen; i <= self.modelGroup.rightIndexInScreen; i++) {
            HSStockChartModel * model = self.modelGroup.chartModelArray[i];
            
            HSKLineSegmentView * segmentView = [[HSKLineSegmentView alloc] initWithModel:model];
            segmentView.index = i;
            [self addSubview:segmentView];
            [self.segmentArray addObject:segmentView];
            
        }
        [self layoutSegmentViews];
    }
    
    CGFloat maxHighNumber = self.modelGroup.maxHighNumber;
    CGFloat minLowNumber = self.modelGroup.minLowNumber;
    
    self.maxHighLabel.text = [NSString stringWithFormat:@"%.0f", maxHighNumber];
    if(maxHighNumber / 1000 < 1){
        self.maxHighLabel.text = [NSString stringWithFormat:@"%.2f", maxHighNumber];
    }
    
    self.minLowLabel.text = [NSString stringWithFormat:@"%.0f", minLowNumber];
    if(minLowNumber / 1000 < 1){
        self.minLowLabel.text = [NSString stringWithFormat:@"%.2f", minLowNumber];
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

- (NSMutableArray<HSKLineSegmentView *> *)segmentArray{
    if(_segmentArray == nil){
        _segmentArray = @[].mutableCopy;
    }
    return _segmentArray;
}

- (CAShapeLayer *)MA5ShapeLayer{
    if(_MA5ShapeLayer == nil){
        _MA5ShapeLayer = [[CAShapeLayer alloc] init];
        _MA5ShapeLayer.strokeColor = [HSStockChartColor MA5LineColor].CGColor;
        _MA5ShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _MA5ShapeLayer.lineWidth = 1;
        _MA5ShapeLayer.zPosition = 10;
        [self.layer addSublayer:_MA5ShapeLayer];
    }
    return _MA5ShapeLayer;
}

- (CAShapeLayer *)MA10ShapeLayer{
    if(_MA10ShapeLayer == nil){
        _MA10ShapeLayer = [[CAShapeLayer alloc] init];
        _MA10ShapeLayer.strokeColor = [HSStockChartColor MA10LineColor].CGColor;
        _MA10ShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _MA10ShapeLayer.lineWidth = 1;
        _MA10ShapeLayer.zPosition = 10;
        [self.layer addSublayer:_MA10ShapeLayer];
    }
    return _MA10ShapeLayer;
}

- (CAShapeLayer *)MA20ShapeLayer{
    if(_MA20ShapeLayer == nil){
        _MA20ShapeLayer = [[CAShapeLayer alloc] init];
        _MA20ShapeLayer.strokeColor = [HSStockChartColor MA20LineColor].CGColor;
        _MA20ShapeLayer.fillColor = [UIColor clearColor].CGColor;
        _MA20ShapeLayer.lineWidth = 1;
        _MA20ShapeLayer.zPosition = 10;
        [self.layer addSublayer:_MA20ShapeLayer];
    }
    return _MA20ShapeLayer;
}

- (UILabel *)maxHighLabel{
    if(_maxHighLabel == nil){
        _maxHighLabel = [[UILabel alloc] init];
        _maxHighLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _maxHighLabel.textColor = [HSStockChartColor scaleLabelColor];
        _maxHighLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_maxHighLabel];
    }
    return _maxHighLabel;
}

- (UILabel *)minLowLabel{
    if(_minLowLabel == nil){
        _minLowLabel = [[UILabel alloc] init];
        _minLowLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _minLowLabel.textColor = [HSStockChartColor scaleLabelColor];
        _minLowLabel.textAlignment = NSTextAlignmentCenter;
        
        [self addSubview:_minLowLabel];
    }
    return _minLowLabel;
}


@end
