//
//  HSDateScaleInfoView.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/22.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSDateScaleInfoView.h"
#import "HSStockChartModelGroup.h"

@implementation HSDateScaleInfoView

#pragma mark private
- (void)layoutScaleViews{
    
    CGSize actualsize = [self.infoLabel sizeThatFits:CGSizeMake(CGFLOAT_MAX, self.height)];
    
    [UIView animateWithDuration:0.15 animations:^{
        self.infoLabel.frame = CGRectMake(self.crossPoint.x - actualsize.width / 2, 0, actualsize.width, self.height);
    }];
    
}


#pragma mark public
- (void)reloadData{
    [self.infoLabel setHidden:self.shouldHideInfo];
    
    [self layoutScaleViews];
}

@end
