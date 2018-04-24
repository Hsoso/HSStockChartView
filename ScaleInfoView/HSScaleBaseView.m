//
//  HSScaleBaseView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/22.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSScaleBaseView.h"

#import "HSStockChartViewVariable.h"
#import "HSStockChartColor.h"

@implementation HSScaleBaseView

- (instancetype)init{
    self = [super init];
    if(self){
        self.shouldHideInfo = YES;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self layoutScaleViews];
}

- (void)layoutScaleViews{
    NSLog(@"需要被子类重写！");
}

- (void)reloadData{
    NSLog(@"需要被子类重写！");
}

#pragma mark getters
- (NSMutableArray *)lineArray{
    if(_lineArray == nil){
        _lineArray = @[].mutableCopy;
    }
    return _lineArray;
}

- (NSMutableArray *)labelArray{
    if(_labelArray == nil){
        _labelArray = @[].mutableCopy;
    }
    return _labelArray;
}

- (UILabel *)infoLabel{
    if(_infoLabel == nil){
        _infoLabel = [[UILabel alloc] init];
        _infoLabel.font = [UIFont systemFontOfSize:[HSStockChartViewVariable scaleFontSize]];
        _infoLabel.textColor = [UIColor blackColor];
        _infoLabel.textAlignment = NSTextAlignmentCenter;
        _infoLabel.backgroundColor = [HSStockChartColor scaleLabelColor];
        _infoLabel.layer.zPosition = 10;
        [self addSubview:_infoLabel];
    }
    return _infoLabel;
}

- (UIView *)separatorLine{
    if(_separatorLine == nil){
        _separatorLine = [[UIView alloc] init];
        _separatorLine.backgroundColor = [HSStockChartColor separatorColor];
        
        [self addSubview:_separatorLine];
    }
    return _separatorLine;
}


@end
