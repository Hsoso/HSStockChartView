//
//  HSCrossLineView.h
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSCrossLineModel, HSCrossLineView;
@protocol HSCrossLineViewDelegate <NSObject>

- (void)crossLineView:(HSCrossLineView *)crossLineView didPanToPoint:(CGPoint)point;

@end


@interface HSCrossLineView : UIView

/**
 *  代理
 */
@property (nonatomic, weak) id<HSCrossLineViewDelegate> delegate;


/**
 *  选取的数据model
 */
@property (nonatomic, strong) HSCrossLineModel * crossLineModel;



/**
 *  刷新交叉线位置及显示内容
 */
- (void)reloadData;

@end
