//
//  YAxisValueFormatter.m
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import "YAxisValueFormatter1.h"

@implementation YAxisValueFormatter1
/// 实现协议方法，返回 y 轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    // value 为 y 轴的值
    
    return [NSString stringWithFormat:@"%ld",(long)value];
}

@end
