//
//  HSStockChartModelGroup.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/20.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSStockChartModelGroup.h"
#import "HSStockChartViewVariable.h"


@implementation HSStockChartModelGroup

- (instancetype)init{
    self = [super init];
    if(self){
        [self setupKVO];
    }
    return self;
}

- (void)setupKVO{
    [self addObserver:self forKeyPath:@"chartModelArray" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context{
    [self generateMANumbers];
}

- (void)dealloc{
    [self removeObserver:self forKeyPath:@"chartModelArray"];
}


#pragma mark public
- (void)generateMANumbers{
    for (int i = 0; i < self.chartModelArray.count; i++) {
        HSStockChartModel * model = self.chartModelArray[i];

        model.MA5_Number = [self generateMANumberByCount:5 index:i];
        model.MA10_Number = [self generateMANumberByCount:10 index:i];
        model.MA20_Number = [self generateMANumberByCount:20 index:i];
    }
}

- (NSDictionary *)findModelByTouchPoint:(CGPoint)point contentOffsetX:(CGFloat)contentOffsetX{
    CGFloat kLineWidth = [HSStockChartViewVariable kLineWidth];
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    
    //预估的index位置
    NSInteger estimateIndex = (NSInteger)((point.x - gap) / (kLineWidth + gap));
    if(estimateIndex == self.chartModelArray.count - 1){
        estimateIndex -= 1;
    }
    
    //左右两边的segment的中心X
    CGFloat leftSegmentCenterX = gap + (kLineWidth + gap) * estimateIndex + kLineWidth / 2.0 ;
    CGFloat rightSegmentCenterX = gap + (kLineWidth + gap) * (estimateIndex + 1) + kLineWidth / 2.0 ;
    
    //如果左边的segment中点已经超出右边屏幕了，则显示左边再减少一个的那一个
    if(leftSegmentCenterX - [HSStockChartViewVariable chartWidth] > contentOffsetX){
        estimateIndex -= 1;
        leftSegmentCenterX = gap + (kLineWidth + gap) * estimateIndex + kLineWidth / 2.0 ;
        rightSegmentCenterX = leftSegmentCenterX;
    }
    
    //如果左边的segment中点已经超出左边屏幕了，则显示在右边segment上
    if(leftSegmentCenterX < contentOffsetX){
        leftSegmentCenterX = rightSegmentCenterX;
    }
    
    //如果右边的segment中点已经不在屏幕内了，则显示在左边segment上
    if(rightSegmentCenterX - [HSStockChartViewVariable chartWidth] > contentOffsetX){
        CGFloat rightMax = gap + (kLineWidth + gap) * self.rightIndexInScreen + kLineWidth / 2;
        if(estimateIndex > self.rightIndexInScreen){
            leftSegmentCenterX = rightMax;
            rightSegmentCenterX = rightMax;
            estimateIndex = self.rightIndexInScreen;
        }else{
            rightSegmentCenterX = leftSegmentCenterX;
        }
        
    }
    
    //左右两边的中心x与用户点击的位置的距离差
    CGFloat leftDifference = fabs(point.x - leftSegmentCenterX);
    CGFloat rightDifference = fabs(point.x - rightSegmentCenterX);
    if(leftDifference <= rightDifference){
        return [self generateDictionaryByModel:self.chartModelArray[estimateIndex] centerPoint:CGPointMake(leftSegmentCenterX, point.y)];
    }
    
    return [self generateDictionaryByModel:self.chartModelArray[estimateIndex + 1] centerPoint:CGPointMake(rightSegmentCenterX, point.y)];
}

- (void)CalculateLeftAndRightIndexInScreenByContentOffsetX:(CGFloat)contentOffsetX{
    CGFloat kLineWidth = [HSStockChartViewVariable kLineWidth];
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    CGFloat chartWidth = [HSStockChartViewVariable chartWidth];
    
    self.leftXInScreen = contentOffsetX;
    self.rightXInScreen = contentOffsetX + chartWidth;
    
    //预估的左边index位置
    NSInteger estimateLeftIndex = (NSInteger)((contentOffsetX - gap) / (kLineWidth + gap));
    CGFloat leftSegmentCenterX = gap + (kLineWidth + gap) * estimateLeftIndex + kLineWidth / 2.0 ;
    //如果左边的segment中点已经超出左边屏幕了
    if(leftSegmentCenterX < contentOffsetX){
        estimateLeftIndex += 1;
    }
    self.leftIndexInScreen = estimateLeftIndex;
    
    //预估的右边index位置
    NSInteger estimateRightIndex = (NSInteger)((contentOffsetX + chartWidth - gap) / (kLineWidth + gap));
    CGFloat rightSegmentCenterX = gap + (kLineWidth + gap) * estimateRightIndex + kLineWidth / 2.0 ;
    //如果右边的segment中点已经超出右边屏幕了
    if(rightSegmentCenterX - chartWidth > contentOffsetX){
        estimateRightIndex -= 1;
    }
    
    //如果右边segment直接超出范围了
    if(estimateRightIndex >= self.chartModelArray.count){
        self.leftIndexInScreen -=  estimateRightIndex - (self.chartModelArray.count - 1);
        estimateRightIndex = self.chartModelArray.count - 1;
    }
    
    self.rightIndexInScreen = estimateRightIndex;
}

- (CGFloat)calculateContentOffsetXByRightIndex{
    CGFloat kLineWidth = [HSStockChartViewVariable kLineWidth];
    CGFloat gap = [HSStockChartViewVariable kLineGap];
    CGFloat chartWidth = [HSStockChartViewVariable chartWidth];
    
    CGFloat offsetX = gap + (self.rightIndexInScreen + 1) * (kLineWidth + gap) - chartWidth;
    if(offsetX < 0){
        offsetX = 0;
    }
    
    return offsetX;
}

- (NSDictionary *)generateScaleDictionaryForKLineChart{
    NSMutableDictionary * mutDic = @{}.mutableCopy;
    NSMutableArray * scaleArr = @[].mutableCopy;
    NSMutableArray * scalePostionArr = @[].mutableCopy;
    

    CGFloat maxNum = self.kLineChartTopNumber;
    CGFloat minNum = self.kLineChartBottomNumber;
    NSInteger scaleNumber = [HSStockChartViewVariable kLineScaleNumber];
    
    
    CGFloat diff0 = [self hsEffectiveFloatNumber:maxNum - minNum effectiveN:2];
    
    for (int i = 0; i < scaleNumber; i++) {
        CGFloat scaleNum = minNum + floor(diff0 * (scaleNumber - i) / scaleNumber);
        CGFloat positionY = [self calculatePositionYForKLineChartByNumber:scaleNum];
        
        [scaleArr addObject:[NSNumber numberWithFloat:scaleNum]];
        [scalePostionArr addObject:[NSNumber numberWithFloat:positionY]];
    }
    
    [mutDic setObject:scaleArr forKey:ScaleNumberKey];
    [mutDic setObject:scalePostionArr forKey:ScalePositionYKey];
    
    return mutDic.copy;
}

- (NSDictionary *)generateScaleDictionaryForVolumeChart{
    NSMutableDictionary * mutDic = @{}.mutableCopy;
    NSMutableArray * scalePostionArr = @[].mutableCopy;
    
    
    CGFloat maxNum = self.maxVolumeNumber;
    CGFloat minNum = 0;
    NSInteger scaleNumber = [HSStockChartViewVariable volumeScaleNumber];
    
    CGFloat scaleNum_1 = 0;
    CGFloat scaleNum_3 = [self hsEffectiveFloatNumber:minNum + maxNum * 22 / 30 effectiveN:2];
    CGFloat scaleNum_2 = [self hsZeroAlignment:minNum + maxNum * 11 / 30 alignmentNumber:scaleNum_3];
    NSArray * scaleArr = @[@(scaleNum_3), @(scaleNum_2), @(scaleNum_1)];
    
    for (int i = 0; i < scaleNumber; i++) {
        CGFloat scaleNum = [scaleArr[i] floatValue];
        CGFloat positionY = [self calculatePositionYForVolumeChartByNumber:scaleNum];
        
        [scalePostionArr addObject:[NSNumber numberWithFloat:positionY]];
    }
    
    [mutDic setObject:scaleArr forKey:ScaleNumberKey];
    [mutDic setObject:scalePostionArr forKey:ScalePositionYKey];
    
    return mutDic.copy;
}

- (CGFloat)calculatePositionYForKLineChartByNumber:(CGFloat)number{
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    CGFloat bottomSpaceHeight = [HSStockChartViewVariable chartBottomSpaceHeight];
    
    CGFloat kLineHeihgt = [HSStockChartViewVariable chartHeight] * (1 - volumeViewRatio) - bottomSpaceHeight;
    CGFloat maxNum = self.kLineChartTopNumber;
    CGFloat minNum = self.kLineChartBottomNumber;
    
    return kLineHeihgt * (maxNum - number) / (maxNum - minNum == 0 ? 1 : (maxNum - minNum));
}

- (CGFloat)calculatePositionYForVolumeChartByNumber:(CGFloat)number{
    CGFloat volumeViewRatio = [HSStockChartViewVariable kLineVolumeViewRatio];
    CGFloat chartHeight = [HSStockChartViewVariable chartHeight];
    CGFloat volumeHeihgt = chartHeight * volumeViewRatio;
    
    CGFloat maxNum = self.maxVolumeNumber;
    CGFloat minNum = 0;
    
    return volumeHeihgt * (maxNum - number) / (maxNum - minNum == 0 ? 1 : (maxNum - minNum));
}

#pragma mark private
- (NSDictionary *)generateDictionaryByModel:(HSStockChartModel *)model centerPoint:(CGPoint)centerPoint{
    NSMutableDictionary * mutDic = @{}.mutableCopy;
    [mutDic setObject:model forKey:ChartModelKey];
    [mutDic setObject:NSStringFromCGPoint(centerPoint) forKey:CenterPointKey];
    [mutDic setObject:self forKey:ChartModelGroupKey];
    return mutDic.copy;
}

//取n位有效数字，比如n = 2时，12345变为12000，234变味230
- (CGFloat)hsEffectiveFloatNumber:(CGFloat)number effectiveN:(NSInteger)n{
    NSInteger intNumber = (NSInteger)number;
    
    int i = 0;
    while (YES) {
        if(intNumber < pow(10, n)){
            break;
        }
        
        intNumber = intNumber / 10;
        i += 1;
    }
    intNumber = intNumber * pow(10, i);
    return (CGFloat)intNumber;
}

//与所给的数据0个数对齐，比如给出alignmentNumber为15000，number为7894，则number取7000
- (CGFloat)hsZeroAlignment:(CGFloat)number alignmentNumber:(CGFloat)alignmentNumber{
    if(alignmentNumber == 0){
        return 0;
    }
    
    //先计算参照数据有几个0
    int i = 0;
    while (ceil((double)alignmentNumber / 10.0) == alignmentNumber / 10) {
        i += 1;
        alignmentNumber = alignmentNumber / 10;
    }
    
    //再计算需要修改的数字有几位数
    NSString * fString = [NSString stringWithFormat:@"%.0f", number];
    
    //最后取有效数字
    return [self hsEffectiveFloatNumber:number effectiveN:fString.length - i];
}

- (CGFloat)generateMANumberByCount:(NSInteger)count index:(NSInteger)index{
    NSInteger j = 0;
    CGFloat sum = 0;
    
    if(index < count){
        j = index + 1;
    }else{
        j = count;
    }
    for (int i = 0; i < j; i++) {
        sum += self.chartModelArray[index - i].close;
    }
    
    return sum / j;
}

#pragma mark getters
- (NSArray<HSStockChartModel *> *)chartModelArray{
    if(_chartModelArray == nil){
        _chartModelArray = @[];
    }
    
    return _chartModelArray;
}

- (NSInteger)rightIndexInScreen{
    if(_rightIndexInScreen == 0){
        
        CGFloat kLineWidth = [HSStockChartViewVariable kLineWidth];
        CGFloat gap = [HSStockChartViewVariable kLineGap];
        CGFloat chartWidth = [HSStockChartViewVariable chartWidth];
        
        _rightIndexInScreen = (NSInteger)((chartWidth - gap) / (kLineWidth + gap));
    }
    
    if(_rightIndexInScreen > self.chartModelArray.count - 1){
        _rightIndexInScreen = self.chartModelArray.count - 1;
    }
    
    return _rightIndexInScreen;
}

- (NSInteger)leftIndexInScreen{
    if(_leftIndexInScreen < 0){
        _leftIndexInScreen = 0;
    }
    return _leftIndexInScreen;
}

- (CGFloat)helpMaxTopNumber{
    if(self.chartModelArray.count == 0){
        return 0.0;
    }
    
    CGFloat max  = CGFLOAT_MIN;
    NSRange range = NSMakeRange(self.leftIndexInScreen, self.rightIndexInScreen - self.leftIndexInScreen + 1);
    
    for (HSStockChartModel * model in [self.chartModelArray subarrayWithRange:range]) {
        if(max < model.high){
            max = model.high;
        }
        if(max < model.MA5_Number){
            max = model.MA5_Number;
        }
        if(max < model.MA10_Number){
            max = model.MA10_Number;
        }
        if(max < model.MA20_Number){
            max = model.MA20_Number;
        }
    }
    
    if(max == CGFLOAT_MIN){
        max = 0;
    }
    
    return max;
}

- (CGFloat)helpMinLowNumber{
    if(self.chartModelArray.count == 0){
        return 0.0;
    }
    
    CGFloat min  = CGFLOAT_MAX;
    NSRange range = NSMakeRange(self.leftIndexInScreen, self.rightIndexInScreen - self.leftIndexInScreen + 1);
    
    for (HSStockChartModel * model in [self.chartModelArray subarrayWithRange:range]) {
        if(min > model.low){
            min = model.low;
        }
        if(min > model.MA5_Number){
            min = model.MA5_Number;
        }
        if(min > model.MA10_Number){
            min = model.MA10_Number;
        }
        if(min > model.MA20_Number){
            min = model.MA20_Number;
        }
    }
    
    if(min == CGFLOAT_MAX){
        min = 0;
    }
    
    return min;
}

- (CGFloat)kLineChartTopNumber{
    CGFloat max  = [self helpMaxTopNumber];
    CGFloat min = [self helpMinLowNumber];
    CGFloat diff = max - min;
    return ceil(max + diff * 0.05);
}

- (CGFloat)kLineChartBottomNumber{
    CGFloat max  = [self helpMaxTopNumber];
    CGFloat min = [self helpMinLowNumber];
    CGFloat diff = max - min;
    return floor(min - diff * 0.05);
}

- (CGFloat)maxHighNumber{
    if(self.chartModelArray.count == 0){
        return 0.0;
    }
    
    CGFloat max  = CGFLOAT_MIN;
    NSRange range = NSMakeRange(self.leftIndexInScreen, self.rightIndexInScreen - self.leftIndexInScreen + 1);
    
    for (HSStockChartModel * model in [self.chartModelArray subarrayWithRange:range]) {
        if(max < model.high){
            max = model.high;
        }
    }
    
    if(max == CGFLOAT_MIN){
        max = 0;
    }
    return max;
}

- (CGFloat)minLowNumber{
    if(self.chartModelArray.count == 0){
        return 0.0;
    }
    
    CGFloat min  = CGFLOAT_MAX;
    NSRange range = NSMakeRange(self.leftIndexInScreen, self.rightIndexInScreen - self.leftIndexInScreen + 1);
    
    for (HSStockChartModel * model in [self.chartModelArray subarrayWithRange:range]) {
        if(min > model.low){
            min = model.low;
        }
    }
    
    if(min == CGFLOAT_MAX){
        min = 0;
    }
    
    return min;
}

- (CGFloat)maxVolumeNumber{
    if(self.chartModelArray.count == 0){
        return 0.0;
    }
    
    CGFloat max  = CGFLOAT_MIN;
    NSRange range = NSMakeRange(self.leftIndexInScreen, self.rightIndexInScreen - self.leftIndexInScreen + 1);
    
    for (HSStockChartModel * model in [self.chartModelArray subarrayWithRange:range]) {
        if(max < model.vol){
            max = model.vol;
        }
    }
    
    if(max == CGFLOAT_MIN){
        max = 0;
    }
    
    return max;
}

@end
