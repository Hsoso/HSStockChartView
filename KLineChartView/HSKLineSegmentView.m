//
//  HSKLineSegmentView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSKLineSegmentView.h"
#import "HSStockChartModel.h"
#import "HSStockChartColor.h"

@interface HSKLineSegmentView()

@property (nonatomic, strong) HSStockChartModel * model;

@property (nonatomic, strong) CAShapeLayer * barLayer;
@property (nonatomic, strong) CAShapeLayer * lineLayer;

@end

@implementation HSKLineSegmentView

- (instancetype)initWithModel:(HSStockChartModel *)model{
    self = [super init];
    if(self){
        self.model = model;
        [self setupUI];
    }
    
    return self;
}

- (void)setupUI{
    self.barLayer = [[CAShapeLayer alloc] init];
    self.barLayer.backgroundColor = self.model.isRise ? [HSStockChartColor riseColor].CGColor : [HSStockChartColor dropColor].CGColor;
    
    self.lineLayer = [[CAShapeLayer alloc] init];
    self.lineLayer.backgroundColor = self.barLayer.backgroundColor;
    
    [self.layer addSublayer:self.barLayer];
    [self.layer addSublayer:self.lineLayer];
}


- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat topNumber = self.model.open > self.model.close ? self.model.open : self.model.close;
    CGFloat bottomNumber = self.model.open > self.model.close ? self.model.close : self.model.open;

    CGFloat topY = self.height * (self.model.high - topNumber) / (self.model.high - self.model.low == 0 ? 1 : (self.model.high - self.model.low));
    CGFloat bottomY = self.height * (self.model.high - bottomNumber) / (self.model.high - self.model.low == 0 ? 1 : (self.model.high - self.model.low));

    self.barLayer.frame = CGRectMake(0, topY, self.width, bottomY - topY == 0 ? 1 : bottomY - topY);
    
    self.lineLayer.frame = CGRectMake(self.width / 2 - 0.5, 0, 1, self.height);
}


@end
