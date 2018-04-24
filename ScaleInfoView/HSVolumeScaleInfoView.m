//
//  HSVolumeScaleInfoView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/22.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSVolumeScaleInfoView.h"
#import "HSStockChartModelGroup.h"

#import "HSStockChartColor.h"
#import "HSStockChartViewVariable.h"


@implementation HSVolumeScaleInfoView


#pragma mark private
- (void)layoutScaleViews{
    self.separatorLine.frame = CGRectMake(0, 0, 1, self.height);
    
    NSArray * scalePositionYArr = [[self.modelGroup generateScaleDictionaryForVolumeChart] objectForKey:ScalePositionYKey];
    for (int i = 0; i < self.lineArray.count; i++) {
        CGFloat scalePostionY = [scalePositionYArr[i] floatValue];
        UIView * scaleView = self.lineArray[i];
        UILabel * scaleLabel = self.labelArray[i];
        
        scaleView.frame = CGRectMake(0, scalePostionY - 1, 5, 1);
        
        CGSize actualsize = [scaleLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
        scaleLabel.frame = CGRectMake(CGRectGetMaxX(scaleView.frame) + 3, scalePostionY - 0.5 * actualsize.height, self.width - CGRectGetMaxX(scaleView.frame) - 3, actualsize.height);
    }
    
    CGSize actualsize = [self.infoLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
    CGFloat labelCenterY = [self.modelGroup calculatePositionYForVolumeChartByNumber:self.infoNum];
    
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
    NSArray * scaleArr = [[self.modelGroup generateScaleDictionaryForVolumeChart] objectForKey:ScaleNumberKey];
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
    [self.infoLabel setHidden:self.shouldHideInfo];
    
    [self layoutScaleViews];
}

@end
