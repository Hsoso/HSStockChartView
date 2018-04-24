//
//  HSStockChartView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSStockChartView.h"

#import "HSKLineView.h"
#import "HSBarChartView.h"
#import "HSCrossLineView.h"

#import "HSCrossLineModel.h"
#import "HSKLineScaleInfoView.h"
#import "HSVolumeScaleInfoView.h"
#import "HSDateScaleInfoView.h"
#import "HSDetailInfoView.h"

#import "HSStockChartViewVariable.h"
#import "HSStockChartColor.h"



@interface HSStockChartView()<UIScrollViewDelegate, HSCrossLineViewDelegate>

@property (nonatomic, strong) UIScrollView * scrollView;

@property (nonatomic, strong) UIView * scrollContainerView;

@property (nonatomic, strong) HSKLineView * kLineView;

@property (nonatomic, strong) HSBarChartView * barChartView;

@property (nonatomic, strong) HSCrossLineView * crossLineView;

@property (nonatomic, strong) HSKLineScaleInfoView * kLineScaleInfoView;

@property (nonatomic, strong) HSVolumeScaleInfoView * volumeScaleInfoView;

@property (nonatomic, strong) HSDateScaleInfoView * dateScaleInfoView;

@property (nonatomic, strong) HSDetailInfoView * detailInfoView;

//用于显示当前volume的label
@property (nonatomic, strong) UILabel * currentVolumeLabel;

//用于第一次layout完毕，将scrollview滚到最后面
@property (nonatomic, assign) BOOL isFirstLayout;

//用于判断是否发送过需要加载新数据的需求了
@property (nonatomic, assign) BOOL needLoadNewData;

@end

@implementation HSStockChartView

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    self.backgroundColor = [HSStockChartColor chartBackgroundColor];
    self.isFirstLayout = YES;
    self.needLoadNewData = YES;
}


- (void)layoutSubviews{
    [super layoutSubviews];

    [self layoutChartViews];
}

#pragma mark HSCrossLineViewDelegate
- (void)crossLineView:(HSCrossLineView *)crossLineView didPanToPoint:(CGPoint)point{
    [self crossLineMoveToPoint:point];
}


#pragma mark UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    //拖拽时先隐藏交叉线
    [self hideCrossLineView:YES];
    
    //更新屏幕内models
    [self.modelGroup CalculateLeftAndRightIndexInScreenByContentOffsetX:scrollView.contentOffset.x];
    
    [self reloadData];
    
    if(self.modelGroup.leftIndexInScreen < self.modelGroup.chartModelArray.count / 2 && self.needLoadNewData && !self.isFirstLayout){
        self.needLoadNewData = NO;

        if([self.delegate respondsToSelector:@selector(chartViewNeedLoadNewData:complete:)]){
            [self.delegate chartViewNeedLoadNewData:self complete:^(NSArray *array) {
                CGFloat oldContentWidth = self.scrollView.contentSize.width;
                
                NSMutableArray * mutArr = self.modelGroup.chartModelArray.mutableCopy;
                NSRange range = NSMakeRange(0, array.count);
                NSIndexSet * set = [NSIndexSet indexSetWithIndexesInRange:range];
                [mutArr insertObjects:array atIndexes:set];
                
                self.modelGroup.chartModelArray = mutArr.copy;
                
                //更新屏幕内models
                [self.modelGroup CalculateLeftAndRightIndexInScreenByContentOffsetX:scrollView.contentOffset.x];
                
                [self reloadData];
                
                //最后滚动scrollView，保持与最右边界的距离不变
                CGFloat nContentWidth = self.scrollView.contentSize.width;
                [self.scrollView setContentOffset:CGPointMake(nContentWidth - (oldContentWidth - self.scrollView.contentOffset.x), 0) animated:NO];
                
                if(array.count == 0){
                    self.needLoadNewData = NO;
                }else{
                    self.needLoadNewData = YES;
                }
                
            }];
        }
    }
}

#pragma mark Gestures
- (void)pinchGestureInvoked:(UIPinchGestureRecognizer *)pinchGesture{
    //1. 缩放时先隐藏交叉线
    [self hideCrossLineView:YES];
    
    //2. 缩放操作
    NSInteger plus = 0;
    if(pinchGesture.velocity > 0){
        plus = -2;
    }else if(pinchGesture.velocity < 0){
        plus = 2;
    }
    
    NSInteger numberPerScreen = [HSStockChartViewVariable kLineNumberPerScreen] + plus;
    
    [HSStockChartViewVariable setkLineNumberPerScreen:numberPerScreen];

    pinchGesture.scale = 1.0;
    
    //3. 在更新屏幕内model前计算需要滚动的距离
    CGFloat nOffsetX = [self.modelGroup calculateContentOffsetXByRightIndex];

    
    //4. 更新屏幕内models
    [self.modelGroup CalculateLeftAndRightIndexInScreenByContentOffsetX:nOffsetX];

    [self reloadData];
    
    //5. 最后滚动scrollView，保持最右边model不变
    [self.scrollView setContentOffset:CGPointMake(nOffsetX, 0) animated:NO];
}

- (void)tapGestureInvoked:(UITapGestureRecognizer *)tapGesture{
    CGPoint tapPoint = [tapGesture locationInView:self.scrollContainerView];
    [self crossLineMoveToPoint:tapPoint];
}

#pragma mark private
- (void)layoutChartViews{
    CGFloat rightSpaceWidth = [HSStockChartViewVariable chartRightSpaceWidth];
    CGFloat bottomSpaceHeight = [HSStockChartViewVariable chartBottomSpaceHeight];
    CGFloat topSpaceHeight = [HSStockChartViewVariable chartTopSpaceHeight];
    
    //设置整张表的宽度和高度 - 不包括留白
    [HSStockChartViewVariable setChartWidth:self.width - rightSpaceWidth];
    [HSStockChartViewVariable setChartHeight:self.height  - bottomSpaceHeight - topSpaceHeight];

    CGFloat scrollContentWidth = [self updateScrollViewContentSizeWidth];
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    
    self.scrollView.frame = CGRectMake(0, topSpaceHeight, self.width - rightSpaceWidth, self.height - bottomSpaceHeight - topSpaceHeight);
    
    self.scrollContainerView.frame = CGRectMake(0, 0, scrollContentWidth, self.scrollView.height);
    
    self.kLineView.frame = CGRectMake(0, 0, scrollContentWidth, self.scrollContainerView.height * (1 - volumeViewRatio) - bottomSpaceHeight);
    
    self.barChartView.frame = CGRectMake(0, self.scrollContainerView.height * (1 - volumeViewRatio), scrollContentWidth, self.scrollContainerView.height * volumeViewRatio);
    
    self.crossLineView.frame = self.scrollContainerView.bounds;
    
    self.kLineScaleInfoView.frame = CGRectMake(self.scrollView.width, topSpaceHeight, rightSpaceWidth, self.kLineView.height);
    
    self.volumeScaleInfoView.frame = CGRectMake(self.scrollView.width, topSpaceHeight + self.barChartView.y, rightSpaceWidth, self.barChartView.height);
    
    self.dateScaleInfoView.frame = CGRectMake(0, self.height - bottomSpaceHeight, self.scrollView.width, bottomSpaceHeight);
    
    self.detailInfoView.frame = CGRectMake(0, 0, self.width - rightSpaceWidth, topSpaceHeight);
    
    CGSize actualSize = [self.currentVolumeLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
    self.currentVolumeLabel.frame = CGRectMake(3, self.barChartView.y + topSpaceHeight + 5, self.width, actualSize.height + 1);
    
    self.scrollView.contentSize = CGSizeMake(scrollContentWidth, self.scrollView.height);
    
    if(self.isFirstLayout && self.modelGroup.chartModelArray.count > 0 && self.width > 0){
        self.isFirstLayout = NO;
        [self.scrollView setContentOffset:CGPointMake(scrollContentWidth - [HSStockChartViewVariable chartWidth], 0) animated:NO];
        [self scrollViewDidScroll:self.scrollView];
    }
}

- (CGFloat)updateScrollViewContentSizeWidth{
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    CGFloat segmentWidth = [HSStockChartViewVariable kLineWidth];
    return self.modelGroup.chartModelArray.count * (segmentWidth + gap) + gap;
}

- (void)hideCrossLineView:(BOOL)hidden{
    [self.crossLineView setHidden:hidden];
    
    //更新刻度盘上的显示
    self.kLineScaleInfoView.shouldHideInfo = hidden || ![self.crossLineView.crossLineModel isInKLineChart];
    [self.kLineScaleInfoView reloadData];
    
    self.volumeScaleInfoView.shouldHideInfo = hidden || ![self.crossLineView.crossLineModel isInVolumeChart];
    [self.volumeScaleInfoView reloadData];
    
    self.dateScaleInfoView.shouldHideInfo = hidden;
    [self.dateScaleInfoView reloadData];
    
    self.detailInfoView.shouldHideInfo = hidden;
    [self.detailInfoView reloadData];
    
    //更新柱状图上volume显示
    if(hidden){
        self.currentVolumeLabel.text = @"Volume";
    }else{
        self.currentVolumeLabel.text = [NSString stringWithFormat:@"Volume %.0f", self.crossLineView.crossLineModel.chartModel.vol];
    }
}

- (void)crossLineMoveToPoint:(CGPoint)point{
    NSDictionary * dic = [self.modelGroup findModelByTouchPoint:point contentOffsetX:self.scrollView.contentOffset.x];
    
    HSCrossLineModel * crossLineModel = [[HSCrossLineModel alloc] initWithChartModel:dic[ChartModelKey] crossPoint:CGPointFromString(dic[CenterPointKey]) modelGroup:self.modelGroup];
    
    self.crossLineView.crossLineModel = crossLineModel;
    
    //更新刻度盘上的显示
    self.kLineScaleInfoView.infoNum = crossLineModel.rightInfo;
    self.volumeScaleInfoView.infoNum = crossLineModel.rightInfo;
    self.dateScaleInfoView.infoLabel.text = [crossLineModel.chartModel generateDateStringByType:self.timeType];
    self.dateScaleInfoView.crossPoint = CGPointMake(crossLineModel.crossPoint.x - self.scrollView.contentOffset.x, 0);
    self.detailInfoView.chartModel = crossLineModel.chartModel;
    
    //更新交叉线显示
    [self.crossLineView reloadData];
    
    //点击时显示交叉线
    [self hideCrossLineView:NO];
    [self bringSubviewToFront:self.crossLineView];
}
    


#pragma mark public
- (void)reloadData{
    //重新绘制K线图
    self.kLineView.modelGroup = self.modelGroup;
    [self.kLineView reloadData];
    
    //重新绘制k线图刻度表
    self.kLineScaleInfoView.modelGroup = self.modelGroup;
    [self.kLineScaleInfoView reloadData];

    //重新绘制柱状图
    self.barChartView.modelGroup = self.modelGroup;
    [self.barChartView reloadData];
    
    //重新绘制柱状图刻度表
    self.volumeScaleInfoView.modelGroup = self.modelGroup;
    [self.volumeScaleInfoView reloadData];
    
    [self layoutChartViews];
}

#pragma mark getters
- (UIScrollView *)scrollView{
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.clipsToBounds = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.bounces = NO;
        
        _scrollView.delegate = self;
        
        [_scrollView addSubview:self.scrollContainerView];
        
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIView *)scrollContainerView{
    if(_scrollContainerView == nil){
        _scrollContainerView = [[UIView alloc] init];
        _scrollContainerView.backgroundColor = [HSStockChartColor chartBackgroundColor];
        
        //缩放手势
        UIPinchGestureRecognizer * pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchGestureInvoked:)];
        [_scrollContainerView addGestureRecognizer:pinchGesture];
        
        //点击手势
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureInvoked:)];
        [_scrollContainerView addGestureRecognizer:tapGesture];
        
        [_scrollContainerView addSubview:self.kLineView];
        [_scrollContainerView addSubview:self.barChartView];
        [_scrollContainerView addSubview:self.crossLineView];
    }
    return _scrollContainerView;
}

- (HSKLineView *)kLineView{
    if(_kLineView == nil){
        _kLineView = [[HSKLineView alloc] init];
        _kLineView.backgroundColor = [HSStockChartColor chartBackgroundColor];
    }
    
    return _kLineView;
}

- (HSBarChartView *)barChartView{
    if(_barChartView == nil){
        _barChartView = [[HSBarChartView alloc] init];
        _barChartView.backgroundColor = [HSStockChartColor chartBackgroundColor];
    }
    return _barChartView;
}

- (HSCrossLineView *)crossLineView{
    if(_crossLineView == nil){
        _crossLineView = [[HSCrossLineView alloc] init];
        _crossLineView.delegate = self;
        [_crossLineView setHidden:YES];
    }
    
    return _crossLineView;
}

- (HSKLineScaleInfoView *)kLineScaleInfoView{
    if(_kLineScaleInfoView == nil){
        _kLineScaleInfoView = [[HSKLineScaleInfoView alloc] init];
        _kLineScaleInfoView.backgroundColor = [HSStockChartColor chartBackgroundColor];
        [self addSubview:_kLineScaleInfoView];
    }
    return _kLineScaleInfoView;
}

- (HSVolumeScaleInfoView *)volumeScaleInfoView{
    if(_volumeScaleInfoView == nil){
        _volumeScaleInfoView = [[HSVolumeScaleInfoView alloc] init];
        _volumeScaleInfoView.backgroundColor = [HSStockChartColor chartBackgroundColor];
        [self addSubview:_volumeScaleInfoView];
    }
    return _volumeScaleInfoView;
}

- (HSDateScaleInfoView *)dateScaleInfoView{
    if(_dateScaleInfoView == nil){
        _dateScaleInfoView = [[HSDateScaleInfoView alloc] init];
        _dateScaleInfoView.backgroundColor = [HSStockChartColor chartBackgroundColor];
        [self addSubview:_dateScaleInfoView];
    }
    return _dateScaleInfoView;
}

- (HSDetailInfoView *)detailInfoView{
    if(_detailInfoView == nil){
        _detailInfoView = [[HSDetailInfoView alloc] init];
        _detailInfoView.backgroundColor = [HSStockChartColor chartBackgroundColor];
        [self addSubview:_detailInfoView];
    }
    return _detailInfoView;
}

- (UILabel *)currentVolumeLabel{
    if(_currentVolumeLabel == nil){
        _currentVolumeLabel = [[UILabel alloc] init];
        _currentVolumeLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _currentVolumeLabel.textColor = [HSStockChartColor scaleLabelColor];
        _currentVolumeLabel.textAlignment = NSTextAlignmentLeft;
        _currentVolumeLabel.layer.zPosition = 10;
        _currentVolumeLabel.text = @"Volume";
        [self addSubview:_currentVolumeLabel];
    }
    return _currentVolumeLabel;
}

- (HSStockChartModelGroup *)modelGroup{
    if(_modelGroup == nil){
        _modelGroup = [[HSStockChartModelGroup alloc] init];
        _modelGroup.chartModelArray = @[];
    }
    
    return _modelGroup;
}






@end
