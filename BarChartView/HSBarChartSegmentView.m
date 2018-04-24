//
//  HSBarChartSegmentView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSBarChartSegmentView.h"
#import "HSStockChartColor.h"

@interface HSBarChartSegmentView()

@property (nonatomic, strong) CAShapeLayer * barLayer;

@end

@implementation HSBarChartSegmentView

- (instancetype)initWithIsRise:(BOOL)isRise{
    self = [super init];
    if(self){
        [self setupUI:isRise];
    }
    return self;
}

- (void)setupUI:(BOOL)isRise{
    self.barLayer = [[CAShapeLayer alloc] init];
    self.barLayer.backgroundColor = isRise ? [HSStockChartColor riseColor].CGColor : [HSStockChartColor dropColor].CGColor;
    
    [self.layer addSublayer:self.barLayer];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    self.barLayer.frame = self.bounds;
}

@end
