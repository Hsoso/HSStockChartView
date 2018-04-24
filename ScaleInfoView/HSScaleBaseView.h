//
//  HSScaleBaseView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/22.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HSStockChartModelGroup;
@interface HSScaleBaseView : UIView

@property (nonatomic, strong) NSMutableArray * lineArray;
@property (nonatomic, strong) NSMutableArray * labelArray;
@property (nonatomic, strong) UILabel * infoLabel;
@property (nonatomic, strong) UIView * separatorLine;

/**
 *  数据源
 */
@property (nonatomic, strong) HSStockChartModelGroup * modelGroup;

/**
 *  是否隐藏数据
 */
@property (nonatomic, assign) BOOL shouldHideInfo;


/**
 *  点击位置显示数据
 */
@property (nonatomic, assign) CGFloat infoNum;



/**
 *  刷新显示内容
 */
- (void)reloadData;

@end
