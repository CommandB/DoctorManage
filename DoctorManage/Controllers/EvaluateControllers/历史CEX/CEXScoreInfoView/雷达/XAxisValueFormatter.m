//
//  XAxisValueFormatter.m
//  ChartsDemo
//
//  Created by 陈海峰 on 2019/1/7.
//  Copyright © 2019年 dcg. All rights reserved.
//

#import "XAxisValueFormatter.h"

@implementation XAxisValueFormatter
/// 实现协议方法，返回 x 轴的数据
- (NSString *)stringForValue:(double)value axis:(ChartAxisBase *)axis {
    
    NSMutableArray *array = [NSMutableArray arrayWithObjects:@"问诊技巧",@"体格检查",@"操作技能",@"临床诊断",@"健康宣教",@"组织效能",@"人文关怀",@"人文关怀", nil];
    //     value 为 x 轴的值
    return array[(NSInteger)value];
    //    NSLog(@"%@",[NSString stringWithFormat:@"%ld 月", (NSInteger)value + 1]);
    //    return [NSString stringWithFormat:@"%ld 月", (NSInteger)value + 1];
}
@end
