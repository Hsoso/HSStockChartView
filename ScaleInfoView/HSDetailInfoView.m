//
//  HSDetailInfoView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/23.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSDetailInfoView.h"

#import "HSStockChartModel.h"

#import "HSStockChartColor.h"
#import "HSStockChartViewVariable.h"

@interface HSDetailInfoView()

@property (nonatomic, strong) UILabel * firstLineLabel;
@property (nonatomic, strong) UILabel * secondLineLabel;

@end

@implementation HSDetailInfoView

#pragma mark private
- (void)layoutScaleViews{
    self.separatorLine.frame = CGRectMake(0, 0, self.width + [HSStockChartViewVariable chartRightSpaceWidth], 1);
    
    CGSize actualSize = [self.firstLineLabel sizeThatFits:CGSizeMake(self.width, CGFLOAT_MAX)];
    self.firstLineLabel.frame = CGRectMake(3, 4, self.width, actualSize.height);
    self.secondLineLabel.frame = CGRectMake(3, CGRectGetMaxY(self.firstLineLabel.frame) + 4, self.width, actualSize.height);
}


#pragma mark public
- (void)reloadData{

    
    self.firstLineLabel.text = [NSString stringWithFormat:@"开: %.1f  高: %.1f  低: %.1f  收: %.1f", self.chartModel.open, self.chartModel.high, self.chartModel.low, self.chartModel.close];
    
    NSMutableAttributedString * MA5_attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA5: %.2f  ", self.chartModel.MA5_Number]];
    [MA5_attributeString addAttribute:NSForegroundColorAttributeName value:[HSStockChartColor MA5LineColor] range:NSMakeRange(0, MA5_attributeString.length)];
    
    NSMutableAttributedString * MA10_attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA10: %.2f  ", self.chartModel.MA10_Number]];
    [MA10_attributeString addAttribute:NSForegroundColorAttributeName value:[HSStockChartColor MA10LineColor] range:NSMakeRange(0, MA10_attributeString.length)];
    
    NSMutableAttributedString * MA20_attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"MA20: %.2f", self.chartModel.MA20_Number]];
    [MA20_attributeString addAttribute:NSForegroundColorAttributeName value:[HSStockChartColor MA20LineColor] range:NSMakeRange(0, MA20_attributeString.length)];
    
    [MA5_attributeString appendAttributedString:MA10_attributeString];
    [MA5_attributeString appendAttributedString:MA20_attributeString];
    
    self.secondLineLabel.attributedText = MA5_attributeString;
    
    [self.firstLineLabel setHidden:self.shouldHideInfo];
    [self.secondLineLabel setHidden:self.shouldHideInfo];
    
    [self layoutScaleViews];
}

- (UILabel *)firstLineLabel{
    if(_firstLineLabel == nil){
        _firstLineLabel = [[UILabel alloc] init];
        _firstLineLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _firstLineLabel.textColor = [HSStockChartColor scaleLabelColor];
        _firstLineLabel.textAlignment = NSTextAlignmentLeft;
        _firstLineLabel.layer.zPosition = 10;
        [self addSubview:_firstLineLabel];
    }
    return _firstLineLabel;
}

- (UILabel *)secondLineLabel{
    if(_secondLineLabel == nil){
        _secondLineLabel = [[UILabel alloc] init];
        _secondLineLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _secondLineLabel.textAlignment = NSTextAlignmentLeft;
        _secondLineLabel.layer.zPosition = 10;
        [self addSubview:_secondLineLabel];
    }
    return _secondLineLabel;
}


@end
