//
//  HSBarChartSegmentView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HSBarChartSegmentView : UIView

/**
 *  初始化方法
 */
- (instancetype)initWithIsRise:(BOOL)isRise;


/**
 *  index代表这个segment存在于modelArray的坐标
 */
@property (nonatomic, assign) NSInteger index;

@end
