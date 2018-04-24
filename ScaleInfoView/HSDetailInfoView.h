//
//  HSDetailInfoView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/23.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSScaleBaseView.h"

@class HSStockChartModel;
@interface HSDetailInfoView : HSScaleBaseView

/**
 *  选取的数据model
 */
@property (nonatomic, strong) HSStockChartModel * chartModel;

@end
