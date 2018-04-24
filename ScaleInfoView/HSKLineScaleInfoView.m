//
//  HSKLineScaleInfoView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/21.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSKLineScaleInfoView.h"
#import "HSStockChartModelGroup.h"

#import "HSStockChartColor.h"
#import "HSStockChartViewVariable.h"

@implementation HSKLineScaleInfoView


#pragma mark private
- (void)layoutScaleViews{
    self.separatorLine.frame = CGRectMake(0, -[HSStockChartViewVariable chartTopSpaceHeight], 1, self.height + [HSStockChartViewVariable chartBottomSpaceHeight] + [HSStockChartViewVariable chartTopSpaceHeight]);
    
    NSArray * scalePositionYArr = [[self.modelGroup generateScaleDictionaryForKLineChart] objectForKey:ScalePositionYKey];
    for (int i = 0; i < self.lineArray.count; i++) {
        CGFloat scalePostionY = [scalePositionYArr[i] floatValue];
        UIView * scaleView = self.lineArray[i];
        UILabel * scaleLabel = self.labelArray[i];
        
        scaleView.frame = CGRectMake(0, scalePostionY - 0.5, 5, 1);
        
        CGSize actualsize = [scaleLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        scaleLabel.frame = CGRectMake(CGRectGetMaxX(scaleView.frame) + 3, scalePostionY - 0.5 * actualsize.height, self.width - CGRectGetMaxX(scaleView.frame) - 3, actualsize.height);
    }
    
    CGSize actualsize = [self.infoLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
    CGFloat labelCenterY = [self.modelGroup calculatePositionYForKLineChartByNumber:self.infoNum];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.infoLabel.frame = CGRectMake(0, labelCenterY - actualsize.height / 2, self.width, actualsize.height);
    }];
    
}


#pragma mark public
- (void)reloadData{
    //清除所有刻度
    for (int i = 0; i < self.lineArray.count; i++) {
        UIView * line = self.lineArray[i];
        UILabel * label = self.labelArray[i];
        
        [line removeFromSuperview];
        [label removeFromSuperview];
    }
    self.lineArray = nil;
    self.labelArray = nil;
    
    //重新创建
    NSArray * scaleArr = [[self.modelGroup generateScaleDictionaryForKLineChart] objectForKey:ScaleNumberKey];
    for (int i = 0; i < scaleArr.count; i++) {
        CGFloat scaleNum = [scaleArr[i] floatValue];
        
        UIView * scaleView = [[UIView alloc] init];
        scaleView.backgroundColor = [HSStockChartColor scaleLineColor];
        [self addSubview:scaleView];
        [self.lineArray addObject:scaleView];
        
        UILabel * scaleLabel = [[UILabel alloc] init];
        scaleLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        scaleLabel.textColor = [HSStockChartColor scaleLabelColor];
        scaleLabel.text = [NSString stringWithFormat:@"%.0f", scaleNum];
        scaleLabel.textAlignment = NSTextAlignmentLeft;
        [self addSubview:scaleLabel];
        [self.labelArray addObject:scaleLabel];
    }
    
    self.infoLabel.text = [NSString stringWithFormat:@"%.0f", self.infoNum];
    if(self.infoNum / 1000 < 1){
        self.infoLabel.text = [NSString stringWithFormat:@"%.2f", self.infoNum];
    }
    
    [self.infoLabel setHidden:self.shouldHideInfo];
    
    [self layoutScaleViews];
}



@end
