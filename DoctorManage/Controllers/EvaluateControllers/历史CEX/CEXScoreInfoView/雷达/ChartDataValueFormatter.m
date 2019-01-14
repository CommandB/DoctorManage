//
//  ChartDataValueFormatter.m
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/7.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import "ChartDataValueFormatter.h"

@implementation ChartDataValueFormatter
/// 实现协议方法，返回辐射线拐点上显示的数据格式
- (NSString * _Nonnull)stringForValue:(double)value
                                entry:(ChartDataEntry * _Nonnull)entry
                         dataSetIndex:(NSInteger)dataSetIndex
                      viewPortHandler:(ChartViewPortHandler * _Nullable)viewPortHandler {
    //    return [NSString stringWithFormat:@"%.2f", 10.00];
    return [NSString stringWithFormat:@"%.2f", entry.y];
    
    //    return [NSString stringWithFormat:@"%.0f%%", entry.y];
}
@end
