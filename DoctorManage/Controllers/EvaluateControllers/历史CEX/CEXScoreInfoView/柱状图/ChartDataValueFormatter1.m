//
//  ChartDataValueFormatter.m
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/8.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import "ChartDataValueFormatter1.h"

@implementation ChartDataValueFormatter1
/// 实现协议方法，返回柱形上显示的数据格式
- (NSString * _Nonnull)stringForValue:(double)value
                                entry:(ChartDataEntry * _Nonnull)entry
                         dataSetIndex:(NSInteger)dataSetIndex
                      viewPortHandler:(ChartViewPortHandler * _Nullable)viewPortHandler {
    
    return [NSString stringWithFormat:@"%.1f", entry.y];
}

@end
