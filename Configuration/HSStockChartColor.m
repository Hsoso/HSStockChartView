//
//  HSStockChartColor.m
//  liantiao
//
//  Created by GZ GZ on 2018/3/19.
//  Copyright © 2018年 com.gz.liantiao. All rights reserved.
//

#import "HSStockChartColor.h"

@implementation HSStockChartColor

+ (UIColor *)chartBackgroundColor{
    return [UIColor blackColor];
}

+ (UIColor *)riseColor{
    return [UIColor colorWithRed:0 / 255.0 green:198 / 255.0 blue:130 / 255.0 alpha:1.0];
}


+ (UIColor *)dropColor{
    return [UIColor colorWithRed:255 / 255.0 green:64 / 255.0 blue:76 / 255.0 alpha:1.0];
}

+ (UIColor *)separatorColor{
    return [UIColor darkGrayColor];
}

+ (UIColor *)crossLineColor{
    return [UIColor whiteColor];
}

+ (UIColor *)scaleLineColor{
    return [UIColor grayColor];
}

+ (UIColor *)scaleLabelColor{
    return [UIColor whiteColor];
}

+ (UIColor *)MA5LineColor{
    return [UIColor colorWithRed:144 / 255.0 green:52 / 255.0 blue:144 / 255.0 alpha:1.0];
}

+ (UIColor *)MA10LineColor{
    return [UIColor colorWithRed:169 / 255.0 green:123 / 255.0 blue:92 / 255.0 alpha:1.0];
}

+ (UIColor *)MA20LineColor{
    return [UIColor colorWithRed:0 / 255.0 green:97 / 255.0 blue:157 / 255.0 alpha:1.0];
}

@end
