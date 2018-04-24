//
//  HSCrossLineView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSCrossLineView.h"

#import "HSCrossLineModel.h"

#import "HSStockChartColor.h"

typedef NS_ENUM(NSInteger, HSLineType) {
    HSLineTypeVertical = 1,
    HSLineTypeHorizontal = 2,
};

static CGFloat kTapLength = 10;

@interface HSCrossLineView()

@property (nonatomic, strong) UIView * verticalLine;//用于感应触摸
@property (nonatomic, strong) UIView * horizontalLine;//用于感应触摸

@property (nonatomic, strong) UIView * realVerticalLine;//用于显示
@property (nonatomic, strong) UIView * realHorizontalLine;//用于显示



@end

@implementation HSCrossLineView

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutCrossLines];
}

#pragma mark private
- (void)layoutCrossLines{
    [UIView animateWithDuration:0.15 animations:^{
        self.horizontalLine.frame = CGRectMake(0, self.crossLineModel.crossPoint.y - kTapLength / 2, self.width, kTapLength);
        self.verticalLine.frame = CGRectMake(self.crossLineModel.crossPoint.x - kTapLength / 2, 0, kTapLength, self.height);
        
        self.realHorizontalLine.frame = CGRectMake(0, (kTapLength - 1) / 2, self.horizontalLine.width, 1);
        self.realVerticalLine.frame = CGRectMake((kTapLength - 1) / 2, 0, 1, self.verticalLine.height);
    }];

}

- (void)panGestureInvoked:(UIPanGestureRecognizer *)panGesture{
    CGPoint point = [panGesture locationInView:self];
    CGPoint nPoint = CGPointZero;
    if(point.y < 0 || point.y > self.height){
        return;
    }
    if(panGesture.view.tag == HSLineTypeHorizontal){
        nPoint = CGPointMake(self.crossLineModel.crossPoint.x, point.y);
    }else if(panGesture.view.tag == HSLineTypeVertical){
        nPoint = CGPointMake(point.x, self.crossLineModel.crossPoint.y);
    }
    
    if([self.delegate respondsToSelector:@selector(crossLineView:didPanToPoint:)]){
        [self.delegate crossLineView:self didPanToPoint:nPoint];
    }
}

#pragma mark public
- (void)reloadData{
    
    [self layoutCrossLines];
}

#pragma mark getters
- (UIView *)verticalLine{
    if(_verticalLine == nil){
        _verticalLine = [[UIView alloc] init];
        _verticalLine.backgroundColor = [UIColor clearColor];
        _verticalLine.tag = HSLineTypeVertical;
        
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureInvoked:)];
        [_verticalLine addGestureRecognizer:panGesture];
        
        [self addSubview:_verticalLine];
        
        self.realVerticalLine = [[UIView alloc] init];
        self.realVerticalLine.backgroundColor = [HSStockChartColor crossLineColor];
        [_verticalLine addSubview:self.realVerticalLine];
    }
    return _verticalLine;
}

- (UIView *)horizontalLine{
    if(_horizontalLine == nil){
        _horizontalLine = [[UIView alloc] init];
        _horizontalLine.backgroundColor = [UIColor clearColor];
        _horizontalLine.tag = HSLineTypeHorizontal;
        
        UIPanGestureRecognizer * panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGestureInvoked:)];
        [_horizontalLine addGestureRecognizer:panGesture];
        
        [self addSubview:_horizontalLine];
        
        self.realHorizontalLine = [[UIView alloc] init];
        self.realHorizontalLine.backgroundColor = [HSStockChartColor crossLineColor];
        [_horizontalLine addSubview:self.realHorizontalLine];
    }
    return _horizontalLine;
}

@end
